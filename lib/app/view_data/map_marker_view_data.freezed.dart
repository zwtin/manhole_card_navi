// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'map_marker_view_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MapMarkerViewData {

 String get id; String get cardId; Uint8List get icon; String get imageUrl; double get latitude; double get longitude;
/// Create a copy of MapMarkerViewData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapMarkerViewDataCopyWith<MapMarkerViewData> get copyWith => _$MapMarkerViewDataCopyWithImpl<MapMarkerViewData>(this as MapMarkerViewData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MapMarkerViewData&&(identical(other.id, id) || other.id == id)&&(identical(other.cardId, cardId) || other.cardId == cardId)&&const DeepCollectionEquality().equals(other.icon, icon)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude));
}


@override
int get hashCode => Object.hash(runtimeType,id,cardId,const DeepCollectionEquality().hash(icon),imageUrl,latitude,longitude);

@override
String toString() {
  return 'MapMarkerViewData(id: $id, cardId: $cardId, icon: $icon, imageUrl: $imageUrl, latitude: $latitude, longitude: $longitude)';
}


}

/// @nodoc
abstract mixin class $MapMarkerViewDataCopyWith<$Res>  {
  factory $MapMarkerViewDataCopyWith(MapMarkerViewData value, $Res Function(MapMarkerViewData) _then) = _$MapMarkerViewDataCopyWithImpl;
@useResult
$Res call({
 String id, String cardId, Uint8List icon, String imageUrl, double latitude, double longitude
});




}
/// @nodoc
class _$MapMarkerViewDataCopyWithImpl<$Res>
    implements $MapMarkerViewDataCopyWith<$Res> {
  _$MapMarkerViewDataCopyWithImpl(this._self, this._then);

  final MapMarkerViewData _self;
  final $Res Function(MapMarkerViewData) _then;

/// Create a copy of MapMarkerViewData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? cardId = null,Object? icon = null,Object? imageUrl = null,Object? latitude = null,Object? longitude = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,cardId: null == cardId ? _self.cardId : cardId // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as Uint8List,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// @nodoc


class _MapMarkerViewData extends MapMarkerViewData {
  const _MapMarkerViewData({required this.id, required this.cardId, required this.icon, required this.imageUrl, required this.latitude, required this.longitude}): super._();
  

@override final  String id;
@override final  String cardId;
@override final  Uint8List icon;
@override final  String imageUrl;
@override final  double latitude;
@override final  double longitude;

/// Create a copy of MapMarkerViewData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MapMarkerViewDataCopyWith<_MapMarkerViewData> get copyWith => __$MapMarkerViewDataCopyWithImpl<_MapMarkerViewData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MapMarkerViewData&&(identical(other.id, id) || other.id == id)&&(identical(other.cardId, cardId) || other.cardId == cardId)&&const DeepCollectionEquality().equals(other.icon, icon)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude));
}


@override
int get hashCode => Object.hash(runtimeType,id,cardId,const DeepCollectionEquality().hash(icon),imageUrl,latitude,longitude);

@override
String toString() {
  return 'MapMarkerViewData(id: $id, cardId: $cardId, icon: $icon, imageUrl: $imageUrl, latitude: $latitude, longitude: $longitude)';
}


}

/// @nodoc
abstract mixin class _$MapMarkerViewDataCopyWith<$Res> implements $MapMarkerViewDataCopyWith<$Res> {
  factory _$MapMarkerViewDataCopyWith(_MapMarkerViewData value, $Res Function(_MapMarkerViewData) _then) = __$MapMarkerViewDataCopyWithImpl;
@override @useResult
$Res call({
 String id, String cardId, Uint8List icon, String imageUrl, double latitude, double longitude
});




}
/// @nodoc
class __$MapMarkerViewDataCopyWithImpl<$Res>
    implements _$MapMarkerViewDataCopyWith<$Res> {
  __$MapMarkerViewDataCopyWithImpl(this._self, this._then);

  final _MapMarkerViewData _self;
  final $Res Function(_MapMarkerViewData) _then;

/// Create a copy of MapMarkerViewData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? cardId = null,Object? icon = null,Object? imageUrl = null,Object? latitude = null,Object? longitude = null,}) {
  return _then(_MapMarkerViewData(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,cardId: null == cardId ? _self.cardId : cardId // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as Uint8List,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
