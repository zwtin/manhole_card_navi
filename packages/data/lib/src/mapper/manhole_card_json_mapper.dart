import 'dart:convert';

import 'package:domain/domain.dart';

/// 端末に保存するカード一式と JSON 文字列の相互変換。
///
/// 自分で書いたファイルを読むので形は決まっているが、壊れたファイルを読んでも
/// 落ちないよう、型を確かめて読む。合わなければ [CorruptedDataException] を投げる。
abstract final class ManholeCardJsonMapper {
  static String toJsonString(List<ManholeCard> cards) {
    return jsonEncode([for (final card in cards) _cardToJson(card)]);
  }

  static List<ManholeCard> fromJsonString(String source) {
    final Object? json;
    try {
      json = jsonDecode(source);
    } on FormatException catch (error, stackTrace) {
      throw CorruptedDataException(
        detail: '端末のマスターデータが JSON として読めません',
        cause: error,
        stackTrace: stackTrace,
      );
    }
    if (json is! List<dynamic>) {
      throw const CorruptedDataException(detail: '端末のマスターデータがカードの一覧ではありません');
    }
    return [for (final card in json) _cardFromJson(card)];
  }

  static Map<String, Object?> _cardToJson(ManholeCard card) {
    return {
      'id': card.id,
      'position': _coordinateToJson(card.position),
      'name': card.name,
      'publicationDate': card.publicationDate.toIso8601String(),
      'distributionState': card.distributionState.name,
      'image': card.image,
      'imageSub': card.imageSub,
      'distributionPlaceHtml': card.distributionPlaceHtml,
      'distributionTimeHtml': card.distributionTimeHtml,
      'stockHtml': card.stockHtml,
      'distributionPoints': [
        for (final point in card.distributionPoints) _coordinateToJson(point),
      ],
      'prefecture': {'id': card.prefecture.id, 'name': card.prefecture.name},
      'volume': {'id': card.volume.id, 'name': card.volume.name},
    };
  }

  static ManholeCard _cardFromJson(Object? json) {
    final card = _asMap(json, 'カード');
    final id = _read<String>(card, 'id');
    final prefecture = _asMap(card['prefecture'], '$id の prefecture');
    final volume = _asMap(card['volume'], '$id の volume');
    final state = _read<String>(card, 'distributionState');
    final publicationDate = DateTime.tryParse(
      _read<String>(card, 'publicationDate'),
    );
    return ManholeCard(
      id: id,
      position: _coordinateFromJson(card['position'], '$id の position'),
      name: _read<String>(card, 'name'),
      publicationDate: publicationDate ??
          (throw CorruptedDataException(detail: '$id の publicationDate が日付ではありません')),
      distributionState: ManholeCardDistributionState.values.asNameMap()[state] ??
          (throw CorruptedDataException(detail: '$id の distributionState が知らない値です（$state）')),
      image: _read<String>(card, 'image'),
      imageSub: _read<String>(card, 'imageSub'),
      distributionPlaceHtml: _read<String>(card, 'distributionPlaceHtml'),
      distributionTimeHtml: _read<String>(card, 'distributionTimeHtml'),
      stockHtml: _read<String>(card, 'stockHtml'),
      distributionPoints: [
        for (final point in _read<List<dynamic>>(card, 'distributionPoints'))
          _coordinateFromJson(point, '$id の distributionPoints'),
      ],
      prefecture: ManholeCardPrefecture(
        id: _read<String>(prefecture, 'id'),
        name: _read<String>(prefecture, 'name'),
      ),
      volume: ManholeCardVolume(
        id: _read<String>(volume, 'id'),
        name: _read<String>(volume, 'name'),
      ),
    );
  }

  static Map<String, Object?> _coordinateToJson(Coordinate coordinate) {
    return {
      'latitude': coordinate.latitude,
      'longitude': coordinate.longitude,
    };
  }

  static Coordinate _coordinateFromJson(Object? json, String label) {
    final coordinate = _asMap(json, label);
    return Coordinate(
      latitude: _read<num>(coordinate, 'latitude').toDouble(),
      longitude: _read<num>(coordinate, 'longitude').toDouble(),
    );
  }

  static Map<String, dynamic> _asMap(Object? json, String label) {
    if (json is Map<String, dynamic>) {
      return json;
    }
    throw CorruptedDataException(detail: '端末のマスターデータの $label が読めません');
  }

  static T _read<T>(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is T) {
      return value;
    }
    throw CorruptedDataException(
      detail: '端末のマスターデータの $key が読めません（${value.runtimeType}）',
    );
  }
}
