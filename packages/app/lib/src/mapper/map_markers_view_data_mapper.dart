import 'dart:io';

import 'package:domain/domain.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

import '../service/image_load_monitor.dart';
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
        final icon = await _buildIcon(card: pin.card, alreadyGet: alreadyGet);
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

    final future = _produceIcon(key: key, card: card, alreadyGet: alreadyGet);
    _inFlight[key] = future;
    return future.whenComplete(() => _inFlight.remove(key));
  }

  /// ディスクキャッシュ / DL + 合成でアイコンを生成する。
  static Future<Uint8List?> _produceIcon({
    required String key,
    required ManholeCard card,
    required bool alreadyGet,
  }) async {
    final fromDisk = await _readDisk(key);
    if (fromDisk != null) {
      cache[key] = fromDisk;
      return fromDisk;
    }

    if (card.image.isEmpty) {
      return null;
    }

    try {
      // 原本画像を DL。http.get はネットワーク待ちの間メイン Isolate を塞が
      // ないため、compute で別 Isolate を立てるより spawn コストがかからない。
      // 縮小デコードと合成（dart:ui）はメイン Isolate で行う必要がある。
      final originalBytes = await _downloadImage(card.image, card.imageSub);
      if (originalBytes == null || originalBytes.isEmpty) {
        return null;
      }
      final icon = await MarkerIconBuilder.build(
        originalBytes: originalBytes,
        distributionState: card.distributionState,
        alreadyGet: alreadyGet,
      );
      cache[key] = icon;
      await _writeDisk(key, icon);
      return icon;
    } catch (_) {
      // 合成やキャッシュ書き込みの失敗でマーカー全体を落とさない。DL の失敗は
      // _downloadImage 側で ImageLoadMonitor に記録済み。
      return null;
    }
  }

  /// 原本画像 DL 用の HTTP クライアント。コネクションを再利用してハンドシェイク
  /// コストを抑える。
  ///
  /// 接続タイムアウトを明示しているのは、既定（null）だと OS のタイムアウト
  /// （Darwin で約75秒）まで待ってしまい、フォールバックに移るのが遅すぎるため。
  static final http.Client _httpClient = IOClient(
    HttpClient()
      ..connectionTimeout = const Duration(seconds: 8)
      // 1ホストへの同時接続数の上限。既定は無制限で、近傍30件を一斉に取りに
      // いくとモバイル回線では SYN が落ちて ETIMEDOUT の原因になる。
      ..maxConnectionsPerHost = 6,
  );

  /// レスポンス全体を待つ時間の上限。
  static const Duration _downloadTimeout = Duration(seconds: 12);

  /// 原本画像を DL してエンコード済みバイト列を返す。
  ///
  /// [url] で取れなければ代替配信元 [subUrl]（master の `image_sub_url`）から
  /// 取り直す。一覧・詳細の画像はキャッシュ層（card_image_cache_manager.dart）が
  /// 同じことをしているが、マーカーはそこを通さず直接 DL するため、ここにも
  /// 同じ手当てが要る。
  static Future<Uint8List?> _downloadImage(String url, String subUrl) async {
    final primaryResult = await _tryDownload(url);
    if (primaryResult.bytes != null) {
      return primaryResult.bytes;
    }

    if (subUrl.isEmpty) {
      ImageLoadMonitor.recordFailure(
        url: url,
        error: primaryResult.error!,
        recovered: false,
      );
      return null;
    }

    final fallbackResult = await _tryDownload(subUrl);
    ImageLoadMonitor.recordFailure(
      url: url,
      error: primaryResult.error!,
      recovered: fallbackResult.bytes != null,
    );
    return fallbackResult.bytes;
  }

  /// 1 回分の DL 試行。成功なら bytes、失敗なら error が入る。
  ///
  /// `on Exception` ではなく `catch` で受けるのは、不正な URI を渡したときの
  /// [ArgumentError] のように Error 型が飛んでくる経路があるため。
  static Future<({Uint8List? bytes, Object? error})> _tryDownload(
    String url,
  ) async {
    try {
      final response =
          await _httpClient.get(Uri.parse(url)).timeout(_downloadTimeout);
      if (response.statusCode != 200) {
        return (
          bytes: null,
          error: HttpExceptionWithStatus(
            response.statusCode,
            'Invalid statusCode: ${response.statusCode}',
            uri: Uri.tryParse(url),
          ),
        );
      }
      if (response.bodyBytes.isEmpty) {
        return (bytes: null, error: const HttpException('empty body'));
      }
      return (bytes: response.bodyBytes, error: null);
    } catch (error) {
      return (bytes: null, error: error);
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
