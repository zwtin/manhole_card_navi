import 'package:domain/domain.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../service/marker_icon_builder.dart';
import '../view_data/map_marker_view_data.dart';
import '../view_data/map_markers_view_data.dart';

/// マップに立てるピン 1 本分。どのカードのピンを、どの座標に立てるか。
typedef CardPin = ({ManholeCard card, Coordinate coordinate});

class MapMarkersViewDataMapper {
  /// 合成済みマーカーアイコンのメモリキャッシュ。
  /// キーは `cardId_distributionState_alreadyGet`。
  static Map<String, Uint8List> cache = <String, Uint8List>{};

  /// 合成済みマーカーアイコンのディスクキャッシュ。次回起動時も再利用する。
  static final BaseCacheManager _diskCache = CacheManager(
    Config(
      'markerIconCache',
      stalePeriod: const Duration(days: 30),
      maxNrOfCacheObjects: 2000,
    ),
  );

  /// 座標の種別に応じて、カードからピンを作る。配布場所では配布地点の数だけ
  /// ピンを立てる（配布地点が 0 件のカードにはピンが立たない）。
  static List<CardPin> pinsOf(
    List<ManholeCard> cards,
    MapCoordinateType coordinateType,
  ) {
    switch (coordinateType) {
      case MapCoordinateType.position:
        return [
          for (final card in cards) (card: card, coordinate: card.position),
        ];
      case MapCoordinateType.distribution:
        return [
          for (final card in cards)
            for (final point in card.distributionPoints)
              (card: card, coordinate: point),
        ];
    }
  }

  /// 表示対象を中心座標の近傍 30 件に絞り込む。距離計算のみで軽量なため
  /// 別 Isolate に投げず同期的に処理する。
  static List<CardPin> _selectNearest({
    required List<CardPin> pins,
    required LatLng centerCoordinate,
  }) {
    final nearPins = pins.where((pin) {
      final latitude = pin.coordinate.latitude - centerCoordinate.latitude;
      final longitude = pin.coordinate.longitude - centerCoordinate.longitude;
      final distance = latitude * latitude + longitude * longitude;
      return distance < 0.1;
    }).toList()
      ..sort((pin1, pin2) {
        final latitude1 = pin1.coordinate.latitude - centerCoordinate.latitude;
        final longitude1 =
            pin1.coordinate.longitude - centerCoordinate.longitude;
        final latitude2 = pin2.coordinate.latitude - centerCoordinate.latitude;
        final longitude2 =
            pin2.coordinate.longitude - centerCoordinate.longitude;
        final distance1 = latitude1 * latitude1 + longitude1 * longitude1;
        final distance2 = latitude2 * latitude2 + longitude2 * longitude2;
        return distance1.compareTo(distance2);
      });
    return nearPins.take(30).toList();
  }

  /// マーカー ViewData を生成する。
  ///
  /// [onPartial] を渡すと、生成が完了したマーカーから順次（プログレッシブに）
  /// 現時点の一覧を通知する。メモリキャッシュ済みのマーカーはまとめて即座に
  /// 通知されるため、地図停止直後にキャッシュ済みマーカーがすぐ表示される。
  /// 戻り値は全件の生成が完了した最終的な一覧。
  static Future<MapMarkersViewData> convertToViewData({
    required List<CardPin> pins,
    required Set<String> alreadyGetCardIds,
    required LatLng centerCoordinate,
    required CommonSearchCondition searchCondition,
    required CardImageUseCase cardImageUseCase,
    void Function(MapMarkersViewData partial)? onPartial,
  }) async {
    // 近傍 30 件に絞る前に、横断フィルタ（弾数・配布状態・取得状態）を適用する。
    // 先に絞ることで、フィルタ対象外のカードが近傍枠を消費しないようにする。
    final filtered = pins.where((pin) {
      return searchCondition.matchesVolume(pin.card.volume.id) &&
          searchCondition.matchesDistributionState(
            pin.card.distributionState,
          ) &&
          searchCondition.matchesDisplay(
            alreadyGet: alreadyGetCardIds.contains(pin.card.id),
          );
    }).toList();

    final nearestPins = _selectNearest(
      pins: filtered,
      centerCoordinate: centerCoordinate,
    );

    final results = <MapMarkerViewData>[];

    // メモリキャッシュ済みは合成不要なため先にまとめて反映する。
    final pending = <CardPin>[];
    for (final pin in nearestPins) {
      final alreadyGet = alreadyGetCardIds.contains(pin.card.id);
      final key = _cacheKey(card: pin.card, alreadyGet: alreadyGet);
      final cached = cache[key];
      if (cached != null) {
        results.add(_toViewData(pin: pin, icon: cached));
      } else {
        pending.add(pin);
      }
    }
    if (onPartial != null && results.isNotEmpty) {
      onPartial(MapMarkersViewData(list: List.of(results)));
    }

    // 残りは DL / 合成が必要。並列実行し、完成した順に反映する。
    // 直列 await だと DL・合成が積み重なりラグの原因になる。
    await Future.wait(
      pending.map((pin) async {
        final alreadyGet = alreadyGetCardIds.contains(pin.card.id);
        final icon = await _buildIcon(
          card: pin.card,
          alreadyGet: alreadyGet,
          cardImageUseCase: cardImageUseCase,
        );
        if (icon == null) {
          return;
        }
        results.add(_toViewData(pin: pin, icon: icon));
        if (onPartial != null) {
          onPartial(MapMarkersViewData(list: List.of(results)));
        }
      }),
    );

    return MapMarkersViewData(list: results);
  }

  static String _cacheKey({
    required ManholeCard card,
    required bool alreadyGet,
  }) {
    // アイコンサイズを含める。サイズ変更時に旧サイズのキャッシュを引かないため。
    // ディスクキャッシュのキーにもなるので、形を変えると端末に保存済みの
    // アイコンをすべて作り直すことになる。
    return '${card.id}_${card.distributionState.name}_${alreadyGet}_'
        '${MarkerIconBuilder.sizeKey}';
  }

  static MapMarkerViewData _toViewData({
    required CardPin pin,
    required Uint8List icon,
  }) {
    return MapMarkerViewData(
      // マーカーの識別子は再生成をまたいで安定させる。ランダムだと GoogleMap が
      // 同一カードを「削除 + 追加」と誤認してちらつく。配布モードでは同一カードが
      // 複数地点に出るため座標も含めて一意にする。
      id: '${pin.card.id}_${pin.coordinate.latitude}_'
          '${pin.coordinate.longitude}',
      cardId: pin.card.id,
      icon: icon,
      imageUrl: pin.card.image,
      imageSubUrl: pin.card.imageSub,
      latitude: pin.coordinate.latitude,
      longitude: pin.coordinate.longitude,
    );
  }

  /// 同一キーのアイコンを生成中の Future。並列・複数経路から同じキーが要求され
  /// たとき、二重 DL・二重合成を避けて 1 本の処理に相乗りさせる。
  static final Map<String, Future<Uint8List?>> _inFlight =
      <String, Future<Uint8List?>>{};

  /// マーカーアイコン（合成済み PNG バイト列）を取得する。
  /// メモリ → 生成中 Future → 生成（ディスク / DL + 合成）の順に探す。
  /// 取得・合成に失敗した場合は null を返す（当該マーカーは表示しない）。
  static Future<Uint8List?> _buildIcon({
    required ManholeCard card,
    required bool alreadyGet,
    required CardImageUseCase cardImageUseCase,
  }) {
    final key = _cacheKey(card: card, alreadyGet: alreadyGet);

    final fromMemory = cache[key];
    if (fromMemory != null) {
      return Future.value(fromMemory);
    }

    // 既に同一キーの生成が進行中なら、その結果を共有して待つ。
    final inFlight = _inFlight[key];
    if (inFlight != null) {
      return inFlight;
    }

    final future = _produceIcon(
      key: key,
      card: card,
      alreadyGet: alreadyGet,
      cardImageUseCase: cardImageUseCase,
    );
    _inFlight[key] = future;
    return future.whenComplete(() => _inFlight.remove(key));
  }

  /// ディスクキャッシュ / DL + 合成でアイコンを生成する。
  static Future<Uint8List?> _produceIcon({
    required String key,
    required ManholeCard card,
    required bool alreadyGet,
    required CardImageUseCase cardImageUseCase,
  }) async {
    final fromDisk = await _readDisk(key);
    if (fromDisk != null) {
      cache[key] = fromDisk;
      return fromDisk;
    }

    // 原本画像は一覧・詳細と同じく data から受け取る（端末に保存済みならそれを
    // 使い、主系で取れなければ代わりの配信元から取る。失敗の計測も data が行う）。
    // 保存するのは合成したアイコンだけにし、原本は保存しない。
    final Uint8List originalBytes;
    switch (await cardImageUseCase.fetchWithoutStoring(
      url: card.image,
      subUrl: card.imageSub,
    )) {
      case Failure():
        return null;
      case Success(:final value):
        originalBytes = value;
    }

    try {
      // 縮小デコードと合成（dart:ui）はメイン Isolate で行う必要がある。
      final icon = await MarkerIconBuilder.build(
        originalBytes: originalBytes,
        distributionState: card.distributionState,
        alreadyGet: alreadyGet,
      );
      cache[key] = icon;
      await _writeDisk(key, icon);
      return icon;
    } catch (_) {
      // 合成やキャッシュ書き込みの失敗でマーカー全体を落とさない。
      return null;
    }
  }

  static Future<Uint8List?> _readDisk(String key) async {
    try {
      final fileInfo = await _diskCache.getFileFromCache(key);
      if (fileInfo == null) {
        return null;
      }
      return fileInfo.file.readAsBytes();
    } on Exception {
      return null;
    }
  }

  static Future<void> _writeDisk(String key, Uint8List bytes) async {
    try {
      await _diskCache.putFile(
        key,
        bytes,
        fileExtension: 'png',
      );
    } on Exception {
      // ディスク書き込み失敗は致命的ではないため無視する。
    }
  }
}
