import 'dart:convert';

import '/domain/entity/display_filter.dart';
import '/domain/entity/manhole_card_distribution_state.dart';
import '/domain/entity/map_coordinate_type.dart';
import '/domain/entity/search_condition.dart';

/// [SearchCondition] と端末保存用 JSON 文字列の相互変換。
///
/// Repository（保存）と QueryService（取得・購読）の両方から使う。復号は堅牢に
/// 行い、空文字・壊れた JSON・未知の enum 値などは黙って無視して
/// [SearchCondition.initial] へフォールバックする（アプリのバージョン間で JSON が
/// 変わっても落ちないように）。
class SearchConditionJsonMapper {
  const SearchConditionJsonMapper._();

  static String toJsonString(SearchCondition condition) {
    final map = <String, dynamic>{
      'common': <String, dynamic>{
        'displayFilter': condition.common.displayFilter.name,
        'volumeIds': condition.common.volumeIds.toList(),
        'distributionStates': condition.common.distributionStates
            .map((state) => state.toStringValue())
            .toList(),
      },
      'map': <String, dynamic>{
        'coordinateType': condition.map.coordinateType.name,
      },
    };
    return jsonEncode(map);
  }

  static SearchCondition fromJsonString(String? source) {
    if (source == null || source.isEmpty) {
      return SearchCondition.initial();
    }
    try {
      final decoded = jsonDecode(source);
      if (decoded is! Map<String, dynamic>) {
        return SearchCondition.initial();
      }
      final common = decoded['common'];
      final map = decoded['map'];
      return SearchCondition(
        common: common is Map<String, dynamic>
            ? _commonFromMap(common)
            : const CommonSearchCondition(),
        map: map is Map<String, dynamic>
            ? _mapFromMap(map)
            : const MapSearchCondition(),
      );
    } on Object {
      return SearchCondition.initial();
    }
  }

  static CommonSearchCondition _commonFromMap(Map<String, dynamic> map) {
    return CommonSearchCondition(
      displayFilter: _displayFilterFromName(map['displayFilter']),
      volumeIds: _stringSet(map['volumeIds']),
      distributionStates: _distributionStateSet(map['distributionStates']),
    );
  }

  static MapSearchCondition _mapFromMap(Map<String, dynamic> map) {
    return MapSearchCondition(
      coordinateType: _coordinateTypeFromName(map['coordinateType']),
    );
  }

  static DisplayFilter _displayFilterFromName(Object? name) {
    return DisplayFilter.values.firstWhere(
      (value) => value.name == name,
      orElse: () => DisplayFilter.all,
    );
  }

  static MapCoordinateType _coordinateTypeFromName(Object? name) {
    return MapCoordinateType.values.firstWhere(
      (value) => value.name == name,
      orElse: () => MapCoordinateType.distribution,
    );
  }

  static Set<String> _stringSet(Object? value) {
    if (value is! List) {
      return const {};
    }
    return value.whereType<String>().toSet();
  }

  static Set<ManholeCardDistributionState> _distributionStateSet(Object? value) {
    if (value is! List) {
      return const {};
    }
    final result = <ManholeCardDistributionState>{};
    for (final element in value) {
      final state = _distributionStateFromValue(element);
      if (state != null) {
        result.add(state);
      }
    }
    return result;
  }

  static ManholeCardDistributionState? _distributionStateFromValue(
    Object? value,
  ) {
    switch (value) {
      case 'distributing':
        return const ManholeCardDistributionState.distributing();
      case 'stopped':
        return const ManholeCardDistributionState.stopped();
      case 'notClear':
        return const ManholeCardDistributionState.notClear();
      default:
        return null;
    }
  }
}
