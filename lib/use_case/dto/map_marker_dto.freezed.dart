// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'map_marker_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MapMarkerDTO {

 String get cardId; String get colorImageUrl; String get grayImageUrl; double get latitude; double get longitude;
/// Create a copy of MapMarkerDTO
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapMarkerDTOCopyWith<MapMarkerDTO> get copyWith => _$MapMarkerDTOCopyWithImpl<MapMarkerDTO>(this as MapMarkerDTO, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MapMarkerDTO&&(identical(other.cardId, cardId) || other.cardId == cardId)&&(identical(other.colorImageUrl, colorImageUrl) || other.colorImageUrl == colorImageUrl)&&(identical(other.grayImageUrl, grayImageUrl) || other.grayImageUrl == grayImageUrl)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude));
}


@override
int get hashCode => Object.hash(runtimeType,cardId,colorImageUrl,grayImageUrl,latitude,longitude);

@override
String toString() {
  return 'MapMarkerDTO(cardId: $cardId, colorImageUrl: $colorImageUrl, grayImageUrl: $grayImageUrl, latitude: $latitude, longitude: $longitude)';
}


}

/// @nodoc
abstract mixin class $MapMarkerDTOCopyWith<$Res>  {
  factory $MapMarkerDTOCopyWith(MapMarkerDTO value, $Res Function(MapMarkerDTO) _then) = _$MapMarkerDTOCopyWithImpl;
@useResult
$Res call({
 String cardId, String colorImageUrl, String grayImageUrl, double latitude, double longitude
});




}
/// @nodoc
class _$MapMarkerDTOCopyWithImpl<$Res>
    implements $MapMarkerDTOCopyWith<$Res> {
  _$MapMarkerDTOCopyWithImpl(this._self, this._then);

  final MapMarkerDTO _self;
  final $Res Function(MapMarkerDTO) _then;

/// Create a copy of MapMarkerDTO
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cardId = null,Object? colorImageUrl = null,Object? grayImageUrl = null,Object? latitude = null,Object? longitude = null,}) {
  return _then(_self.copyWith(
cardId: null == cardId ? _self.cardId : cardId // ignore: cast_nullable_to_non_nullable
as String,colorImageUrl: null == colorImageUrl ? _self.colorImageUrl : colorImageUrl // ignore: cast_nullable_to_non_nullable
as String,grayImageUrl: null == grayImageUrl ? _self.grayImageUrl : grayImageUrl // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// @nodoc


class _MapMarkerDTO extends MapMarkerDTO {
  const _MapMarkerDTO({required this.cardId, required this.colorImageUrl, required this.grayImageUrl, required this.latitude, required this.longitude}): super._();
  

@override final  String cardId;
@override final  String colorImageUrl;
@override final  String grayImageUrl;
@override final  double latitude;
@override final  double longitude;

/// Create a copy of MapMarkerDTO
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MapMarkerDTOCopyWith<_MapMarkerDTO> get copyWith => __$MapMarkerDTOCopyWithImpl<_MapMarkerDTO>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MapMarkerDTO&&(identical(other.cardId, cardId) || other.cardId == cardId)&&(identical(other.colorImageUrl, colorImageUrl) || other.colorImageUrl == colorImageUrl)&&(identical(other.grayImageUrl, grayImageUrl) || other.grayImageUrl == grayImageUrl)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude));
}


@override
int get hashCode => Object.hash(runtimeType,cardId,colorImageUrl,grayImageUrl,latitude,longitude);

@override
String toString() {
  return 'MapMarkerDTO(cardId: $cardId, colorImageUrl: $colorImageUrl, grayImageUrl: $grayImageUrl, latitude: $latitude, longitude: $longitude)';
}


}

/// @nodoc
abstract mixin class _$MapMarkerDTOCopyWith<$Res> implements $MapMarkerDTOCopyWith<$Res> {
  factory _$MapMarkerDTOCopyWith(_MapMarkerDTO value, $Res Function(_MapMarkerDTO) _then) = __$MapMarkerDTOCopyWithImpl;
@override @useResult
$Res call({
 String cardId, String colorImageUrl, String grayImageUrl, double latitude, double longitude
});




}
/// @nodoc
class __$MapMarkerDTOCopyWithImpl<$Res>
    implements _$MapMarkerDTOCopyWith<$Res> {
  __$MapMarkerDTOCopyWithImpl(this._self, this._then);

  final _MapMarkerDTO _self;
  final $Res Function(_MapMarkerDTO) _then;

/// Create a copy of MapMarkerDTO
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cardId = null,Object? colorImageUrl = null,Object? grayImageUrl = null,Object? latitude = null,Object? longitude = null,}) {
  return _then(_MapMarkerDTO(
cardId: null == cardId ? _self.cardId : cardId // ignore: cast_nullable_to_non_nullable
as String,colorImageUrl: null == colorImageUrl ? _self.colorImageUrl : colorImageUrl // ignore: cast_nullable_to_non_nullable
as String,grayImageUrl: null == grayImageUrl ? _self.grayImageUrl : grayImageUrl // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
