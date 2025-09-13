// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'map_markers_view_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MapMarkersViewData {

 List<MapMarkerViewData> get list;
/// Create a copy of MapMarkersViewData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapMarkersViewDataCopyWith<MapMarkersViewData> get copyWith => _$MapMarkersViewDataCopyWithImpl<MapMarkersViewData>(this as MapMarkersViewData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MapMarkersViewData&&const DeepCollectionEquality().equals(other.list, list));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(list));

@override
String toString() {
  return 'MapMarkersViewData(list: $list)';
}


}

/// @nodoc
abstract mixin class $MapMarkersViewDataCopyWith<$Res>  {
  factory $MapMarkersViewDataCopyWith(MapMarkersViewData value, $Res Function(MapMarkersViewData) _then) = _$MapMarkersViewDataCopyWithImpl;
@useResult
$Res call({
 List<MapMarkerViewData> list
});




}
/// @nodoc
class _$MapMarkersViewDataCopyWithImpl<$Res>
    implements $MapMarkersViewDataCopyWith<$Res> {
  _$MapMarkersViewDataCopyWithImpl(this._self, this._then);

  final MapMarkersViewData _self;
  final $Res Function(MapMarkersViewData) _then;

/// Create a copy of MapMarkersViewData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? list = null,}) {
  return _then(_self.copyWith(
list: null == list ? _self.list : list // ignore: cast_nullable_to_non_nullable
as List<MapMarkerViewData>,
  ));
}

}


/// @nodoc


class _MapMarkersViewData extends MapMarkersViewData {
  const _MapMarkersViewData({required final  List<MapMarkerViewData> list}): _list = list,super._();
  

 final  List<MapMarkerViewData> _list;
@override List<MapMarkerViewData> get list {
  if (_list is EqualUnmodifiableListView) return _list;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_list);
}


/// Create a copy of MapMarkersViewData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MapMarkersViewDataCopyWith<_MapMarkersViewData> get copyWith => __$MapMarkersViewDataCopyWithImpl<_MapMarkersViewData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MapMarkersViewData&&const DeepCollectionEquality().equals(other._list, _list));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_list));

@override
String toString() {
  return 'MapMarkersViewData(list: $list)';
}


}

/// @nodoc
abstract mixin class _$MapMarkersViewDataCopyWith<$Res> implements $MapMarkersViewDataCopyWith<$Res> {
  factory _$MapMarkersViewDataCopyWith(_MapMarkersViewData value, $Res Function(_MapMarkersViewData) _then) = __$MapMarkersViewDataCopyWithImpl;
@override @useResult
$Res call({
 List<MapMarkerViewData> list
});




}
/// @nodoc
class __$MapMarkersViewDataCopyWithImpl<$Res>
    implements _$MapMarkersViewDataCopyWith<$Res> {
  __$MapMarkersViewDataCopyWithImpl(this._self, this._then);

  final _MapMarkersViewData _self;
  final $Res Function(_MapMarkersViewData) _then;

/// Create a copy of MapMarkersViewData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? list = null,}) {
  return _then(_MapMarkersViewData(
list: null == list ? _self._list : list // ignore: cast_nullable_to_non_nullable
as List<MapMarkerViewData>,
  ));
}


}

// dart format on
