// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'map_markers_view_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$MapMarkersViewData {
  List<MapMarkerViewData> get list => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MapMarkersViewDataCopyWith<MapMarkersViewData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MapMarkersViewDataCopyWith<$Res> {
  factory $MapMarkersViewDataCopyWith(
          MapMarkersViewData value, $Res Function(MapMarkersViewData) then) =
      _$MapMarkersViewDataCopyWithImpl<$Res, MapMarkersViewData>;
  @useResult
  $Res call({List<MapMarkerViewData> list});
}

/// @nodoc
class _$MapMarkersViewDataCopyWithImpl<$Res, $Val extends MapMarkersViewData>
    implements $MapMarkersViewDataCopyWith<$Res> {
  _$MapMarkersViewDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? list = null,
  }) {
    return _then(_value.copyWith(
      list: null == list
          ? _value.list
          : list // ignore: cast_nullable_to_non_nullable
              as List<MapMarkerViewData>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_MapMarkersViewDataCopyWith<$Res>
    implements $MapMarkersViewDataCopyWith<$Res> {
  factory _$$_MapMarkersViewDataCopyWith(_$_MapMarkersViewData value,
          $Res Function(_$_MapMarkersViewData) then) =
      __$$_MapMarkersViewDataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<MapMarkerViewData> list});
}

/// @nodoc
class __$$_MapMarkersViewDataCopyWithImpl<$Res>
    extends _$MapMarkersViewDataCopyWithImpl<$Res, _$_MapMarkersViewData>
    implements _$$_MapMarkersViewDataCopyWith<$Res> {
  __$$_MapMarkersViewDataCopyWithImpl(
      _$_MapMarkersViewData _value, $Res Function(_$_MapMarkersViewData) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? list = null,
  }) {
    return _then(_$_MapMarkersViewData(
      list: null == list
          ? _value._list
          : list // ignore: cast_nullable_to_non_nullable
              as List<MapMarkerViewData>,
    ));
  }
}

/// @nodoc

class _$_MapMarkersViewData extends _MapMarkersViewData {
  const _$_MapMarkersViewData({required final List<MapMarkerViewData> list})
      : _list = list,
        super._();

  final List<MapMarkerViewData> _list;
  @override
  List<MapMarkerViewData> get list {
    if (_list is EqualUnmodifiableListView) return _list;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_list);
  }

  @override
  String toString() {
    return 'MapMarkersViewData(list: $list)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_MapMarkersViewData &&
            const DeepCollectionEquality().equals(other._list, _list));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_list));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_MapMarkersViewDataCopyWith<_$_MapMarkersViewData> get copyWith =>
      __$$_MapMarkersViewDataCopyWithImpl<_$_MapMarkersViewData>(
          this, _$identity);
}

abstract class _MapMarkersViewData extends MapMarkersViewData {
  const factory _MapMarkersViewData(
      {required final List<MapMarkerViewData> list}) = _$_MapMarkersViewData;
  const _MapMarkersViewData._() : super._();

  @override
  List<MapMarkerViewData> get list;
  @override
  @JsonKey(ignore: true)
  _$$_MapMarkersViewDataCopyWith<_$_MapMarkersViewData> get copyWith =>
      throw _privateConstructorUsedError;
}
