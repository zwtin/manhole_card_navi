import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import 'package:data/src/model/distribution_state_model.dart';

part 'search_condition_model.g.dart';

/// 以前のバージョンのアプリが保存したものも読むので、知らない値・欠けた項目・
/// 壊れた JSON は既定値にする。
@JsonSerializable(explicitToJson: true)
class SearchConditionModel {
  const SearchConditionModel({required this.common, required this.map});

  factory SearchConditionModel.fromJson(Map<String, dynamic> json) =>
      _$SearchConditionModelFromJson(json);

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
      // 初期状態で続ける。
    } on TypeError {
      // 初期状態で続ける。
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
      displayFilter: DisplayFilterModel.all,
      volumeIds: {},
      distributionStates: {},
    );
  }

  Map<String, dynamic> toJson() => _$CommonSearchConditionModelToJson(this);

  @JsonKey(
    defaultValue: DisplayFilterModel.all,
    unknownEnumValue: DisplayFilterModel.all,
  )
  final DisplayFilterModel displayFilter;

  @_StringSetConverter()
  final Set<String> volumeIds;

  @_DistributionStateSetConverter()
  final Set<DistributionStateModel> distributionStates;
}

@JsonSerializable()
class MapSearchConditionModel {
  const MapSearchConditionModel({required this.coordinateType});

  factory MapSearchConditionModel.fromJson(Map<String, dynamic> json) =>
      _$MapSearchConditionModelFromJson(json);

  factory MapSearchConditionModel.initial() {
    return const MapSearchConditionModel(
      coordinateType: CoordinateTypeModel.distribution,
    );
  }

  Map<String, dynamic> toJson() => _$MapSearchConditionModelToJson(this);

  @JsonKey(
    defaultValue: CoordinateTypeModel.distribution,
    unknownEnumValue: CoordinateTypeModel.distribution,
  )
  final CoordinateTypeModel coordinateType;
}

/// 値の名前が保存する文字列そのもの。変えると保存済みの値が読めなくなる。
enum DisplayFilterModel {
  all,
  acquired,
  unacquired,
}

/// 値の名前が保存する文字列そのもの。変えると保存済みの値が読めなくなる。
enum CoordinateTypeModel {
  distribution,
  position,
}

class _StringSetConverter implements JsonConverter<Set<String>, Object?> {
  const _StringSetConverter();

  @override
  Set<String> fromJson(Object? json) {
    return json is List<dynamic> ? json.whereType<String>().toSet() : {};
  }

  @override
  Object? toJson(Set<String> object) => object.toList();
}

class _DistributionStateSetConverter
    implements JsonConverter<Set<DistributionStateModel>, Object?> {
  const _DistributionStateSetConverter();

  @override
  Set<DistributionStateModel> fromJson(Object? json) {
    if (json is! List<dynamic>) {
      return {};
    }
    final byName = DistributionStateModel.values.asNameMap();
    return json.map((element) => byName[element]).nonNulls.toSet();
  }

  @override
  Object? toJson(Set<DistributionStateModel> object) {
    return object.map((state) => state.name).toList();
  }
}
