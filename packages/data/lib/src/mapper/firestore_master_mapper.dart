import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domain/domain.dart';
import 'package:intl/intl.dart';

/// Firestore の `master/{version}` 配下のドキュメントをエンティティに変換する。
///
/// サーバーのデータは形が想定と違うことがあるため、キャストに頼らず型を確かめ、
/// 合わなければ [CorruptedDataException] を投げる。[path] はどのドキュメントが
/// おかしいかを調べるための補足に使う。
abstract final class FirestoreMasterMapper {
  static ManholeCardPrefecture toPrefecture(
    Map<String, dynamic> data, {
    required String path,
  }) {
    return ManholeCardPrefecture(
      id: _read<String>(data, 'id', path),
      name: _read<String>(data, 'name', path),
    );
  }

  static ManholeCardVolume toVolume(
    Map<String, dynamic> data, {
    required String path,
  }) {
    return ManholeCardVolume(
      id: _read<String>(data, 'id', path),
      name: _read<String>(data, 'name', path),
    );
  }

  /// カードに変換し、都道府県・弾の名前を [prefectures] / [volumes]（ID から引く表）
  /// から引き当てる。
  static ManholeCard toCard(
    Map<String, dynamic> data, {
    required String path,
    required Map<String, ManholeCardPrefecture> prefectures,
    required Map<String, ManholeCardVolume> volumes,
  }) {
    final location = _read<GeoPoint>(data, 'location', path);
    final prefectureId = _read<String>(data, 'prefecture_id', path);
    final volumeId = _read<String>(data, 'volume_id', path);
    return ManholeCard(
      id: _read<String>(data, 'id', path),
      position: Coordinate(
        latitude: location.latitude,
        longitude: location.longitude,
      ),
      name: _read<String>(data, 'name', path),
      publicationDate: _readDate(data, 'publication_date', path),
      distributionState: _readDistributionState(
        data,
        'distribution_state',
        path,
      ),
      image: _read<String>(data, 'image_url', path),
      // image_sub_url（代替配信元）を持たない世代の master もあるため、無ければ空文字。
      imageSub: _readOptional<String>(data, 'image_sub_url', path) ?? '',
      distributionPlaceHtml: _read<String>(
        data,
        'distribution_place_html',
        path,
      ),
      distributionTimeHtml: _read<String>(data, 'distribution_time_html', path),
      stockHtml: _read<String>(data, 'stock_html', path),
      distributionPoints: _read<List<dynamic>>(data, 'distribution_points', path)
          .whereType<GeoPoint>()
          .map(
            (geoPoint) => Coordinate(
              latitude: geoPoint.latitude,
              longitude: geoPoint.longitude,
            ),
          )
          .toList(),
      // prefectures に無い都道府県 ID のカード（全国向けのカードなど）は名前を空に
      // しておく。一覧では名前が空の都道府県を「全国」として表示する。
      prefecture: prefectures[prefectureId] ??
          ManholeCardPrefecture(id: prefectureId, name: ''),
      volume: volumes[volumeId] ?? ManholeCardVolume(id: volumeId, name: ''),
    );
  }

  static T _read<T>(Map<String, dynamic> data, String key, String path) {
    final value = data[key];
    if (value is T) {
      return value;
    }
    throw CorruptedDataException(
      detail: '$path の $key が $T ではありません（${value.runtimeType}）',
    );
  }

  static T? _readOptional<T>(
    Map<String, dynamic> data,
    String key,
    String path,
  ) {
    if (data[key] == null) {
      return null;
    }
    return _read<T>(data, key, path);
  }

  static DateTime _readDate(
    Map<String, dynamic> data,
    String key,
    String path,
  ) {
    final text = _read<String>(data, key, path);
    try {
      return DateFormat('yyyy/MM/dd').parse(text);
    } on FormatException catch (error, stackTrace) {
      throw CorruptedDataException(
        detail: '$path の $key が日付として読めません（$text）',
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }

  static ManholeCardDistributionState _readDistributionState(
    Map<String, dynamic> data,
    String key,
    String path,
  ) {
    final text = _read<String>(data, key, path);
    final state = ManholeCardDistributionState.values.asNameMap()[text];
    if (state == null) {
      throw CorruptedDataException(detail: '$path の $key が知らない値です（$text）');
    }
    return state;
  }
}
