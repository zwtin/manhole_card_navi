import 'dart:convert';

import 'package:domain/domain.dart';
import 'package:json_annotation/json_annotation.dart';

part 'search_condition_model.g.dart';

/// 端末に保存する検索条件（SharedPreferences の `search_condition` の JSON）。
///
/// 以前のバージョンのアプリが保存したものも読むので、知らない値・欠けた項目は
/// 既定値にする（読めない値で落とさない）。
@JsonSerializable(explicitToJson: true)
class SearchConditionModel {
  const SearchConditionModel({required this.common, required this.map});

  factory SearchConditionModel.fromJson(Map<String, dynamic> json) =>
      _$SearchConditionModelFromJson(json);

  /// 保存した JSON 文字列から作る。未保存（空文字）・壊れた JSON なら初期状態。
  factory SearchConditionModel.fromJsonString(String source) {
    if (source.isEmpty) {
      return SearchConditionModel.initial();
    }
    try {
      final json = jsonDecode(source);
      if (json is Map<String, dynamic>) {
        return SearchConditionModel.fromJson(json);
      }
    } on FormatException {
      // 壊れた JSON。初期状態で続ける。
    } on TypeError {
      // 項目の型が違う（以前のバージョンの形など）。初期状態で続ける。
    }
    return SearchConditionModel.initial();
  }

  factory SearchConditionModel.initial() {
    return SearchConditionModel(
      common: CommonSearchConditionModel.initial(),
      map: MapSearchConditionModel.initial(),
    );
  }

  Map<String, dynamic> toJson() => _$SearchConditionModelToJson(this);

  String toJsonString() => jsonEncode(toJson());

  @JsonKey(defaultValue: CommonSearchConditionModel.initial)
  final CommonSearchConditionModel common;

  @JsonKey(defaultValue: MapSearchConditionModel.initial)
  final MapSearchConditionModel map;
}

@JsonSerializable()
class CommonSearchConditionModel {
  const CommonSearchConditionModel({
    required this.displayFilter,
    required this.volumeIds,
    required this.distributionStates,
  });

  factory CommonSearchConditionModel.fromJson(Map<String, dynamic> json) =>
      _$CommonSearchConditionModelFromJson(json);

  factory CommonSearchConditionModel.initial() {
    return const CommonSearchConditionModel(
      displayFilter: DisplayFilter.all,
      volumeIds: {},
      distributionStates: {},
    );
  }

  Map<String, dynamic> toJson() => _$CommonSearchConditionModelToJson(this);

  @JsonKey(
    defaultValue: DisplayFilter.all,
    unknownEnumValue: DisplayFilter.all,
  )
  final DisplayFilter displayFilter;

  @_StringSetConverter()
  final Set<String> volumeIds;

  @_DistributionStateSetConverter()
  final Set<ManholeCardDistributionState> distributionStates;
}

@JsonSerializable()
class MapSearchConditionModel {
  const MapSearchConditionModel({required this.coordinateType});

  factory MapSearchConditionModel.fromJson(Map<String, dynamic> json) =>
      _$MapSearchConditionModelFromJson(json);

  factory MapSearchConditionModel.initial() {
    return const MapSearchConditionModel(
      coordinateType: MapCoordinateType.distribution,
    );
  }

  Map<String, dynamic> toJson() => _$MapSearchConditionModelToJson(this);

  @JsonKey(
    defaultValue: MapCoordinateType.distribution,
    unknownEnumValue: MapCoordinateType.distribution,
  )
  final MapCoordinateType coordinateType;
}

/// 文字列の集合。文字列でない要素は読み飛ばす。
class _StringSetConverter implements JsonConverter<Set<String>, Object?> {
  const _StringSetConverter();

  @override
  Set<String> fromJson(Object? json) {
    return json is List<dynamic> ? json.whereType<String>().toSet() : {};
  }

  @override
  Object? toJson(Set<String> object) => object.toList();
}

/// 配布状態の集合。知らない値は読み飛ばす。
class _DistributionStateSetConverter
    implements JsonConverter<Set<ManholeCardDistributionState>, Object?> {
  const _DistributionStateSetConverter();

  @override
  Set<ManholeCardDistributionState> fromJson(Object? json) {
    if (json is! List<dynamic>) {
      return {};
    }
    final byName = ManholeCardDistributionState.values.asNameMap();
    return json.map((element) => byName[element]).nonNulls.toSet();
  }

  @override
  Object? toJson(Set<ManholeCardDistributionState> object) {
    return object.map((state) => state.name).toList();
  }
}
