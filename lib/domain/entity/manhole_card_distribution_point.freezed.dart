// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'manhole_card_distribution_point.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ManholeCardDistributionPoint {

 double get latitude; double get longitude;
/// Create a copy of ManholeCardDistributionPoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ManholeCardDistributionPointCopyWith<ManholeCardDistributionPoint> get copyWith => _$ManholeCardDistributionPointCopyWithImpl<ManholeCardDistributionPoint>(this as ManholeCardDistributionPoint, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ManholeCardDistributionPoint&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude));
}


@override
int get hashCode => Object.hash(runtimeType,latitude,longitude);

@override
String toString() {
  return 'ManholeCardDistributionPoint(latitude: $latitude, longitude: $longitude)';
}


}

/// @nodoc
abstract mixin class $ManholeCardDistributionPointCopyWith<$Res>  {
  factory $ManholeCardDistributionPointCopyWith(ManholeCardDistributionPoint value, $Res Function(ManholeCardDistributionPoint) _then) = _$ManholeCardDistributionPointCopyWithImpl;
@useResult
$Res call({
 double latitude, double longitude
});




}
/// @nodoc
class _$ManholeCardDistributionPointCopyWithImpl<$Res>
    implements $ManholeCardDistributionPointCopyWith<$Res> {
  _$ManholeCardDistributionPointCopyWithImpl(this._self, this._then);

  final ManholeCardDistributionPoint _self;
  final $Res Function(ManholeCardDistributionPoint) _then;

/// Create a copy of ManholeCardDistributionPoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? latitude = null,Object? longitude = null,}) {
  return _then(_self.copyWith(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// @nodoc


class _ManholeCardDistributionPoint extends ManholeCardDistributionPoint {
  const _ManholeCardDistributionPoint({required this.latitude, required this.longitude}): super._();
  

@override final  double latitude;
@override final  double longitude;

/// Create a copy of ManholeCardDistributionPoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ManholeCardDistributionPointCopyWith<_ManholeCardDistributionPoint> get copyWith => __$ManholeCardDistributionPointCopyWithImpl<_ManholeCardDistributionPoint>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ManholeCardDistributionPoint&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude));
}


@override
int get hashCode => Object.hash(runtimeType,latitude,longitude);

@override
String toString() {
  return 'ManholeCardDistributionPoint(latitude: $latitude, longitude: $longitude)';
}


}

/// @nodoc
abstract mixin class _$ManholeCardDistributionPointCopyWith<$Res> implements $ManholeCardDistributionPointCopyWith<$Res> {
  factory _$ManholeCardDistributionPointCopyWith(_ManholeCardDistributionPoint value, $Res Function(_ManholeCardDistributionPoint) _then) = __$ManholeCardDistributionPointCopyWithImpl;
@override @useResult
$Res call({
 double latitude, double longitude
});




}
/// @nodoc
class __$ManholeCardDistributionPointCopyWithImpl<$Res>
    implements _$ManholeCardDistributionPointCopyWith<$Res> {
  __$ManholeCardDistributionPointCopyWithImpl(this._self, this._then);

  final _ManholeCardDistributionPoint _self;
  final $Res Function(_ManholeCardDistributionPoint) _then;

/// Create a copy of ManholeCardDistributionPoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? latitude = null,Object? longitude = null,}) {
  return _then(_ManholeCardDistributionPoint(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
