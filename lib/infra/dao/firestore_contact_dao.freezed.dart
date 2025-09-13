// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'firestore_contact_dao.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FirestoreContactDAO {

 String get address; String get id; double get latitude; double get longitude; String get name; String get nameUrl; String get other; String get phoneNumber; String get time; String get timeOther;
/// Create a copy of FirestoreContactDAO
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FirestoreContactDAOCopyWith<FirestoreContactDAO> get copyWith => _$FirestoreContactDAOCopyWithImpl<FirestoreContactDAO>(this as FirestoreContactDAO, _$identity);

  /// Serializes this FirestoreContactDAO to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FirestoreContactDAO&&(identical(other.address, address) || other.address == address)&&(identical(other.id, id) || other.id == id)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameUrl, nameUrl) || other.nameUrl == nameUrl)&&(identical(other.other, this.other) || other.other == this.other)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.time, time) || other.time == time)&&(identical(other.timeOther, timeOther) || other.timeOther == timeOther));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,address,id,latitude,longitude,name,nameUrl,other,phoneNumber,time,timeOther);

@override
String toString() {
  return 'FirestoreContactDAO(address: $address, id: $id, latitude: $latitude, longitude: $longitude, name: $name, nameUrl: $nameUrl, other: $other, phoneNumber: $phoneNumber, time: $time, timeOther: $timeOther)';
}


}

/// @nodoc
abstract mixin class $FirestoreContactDAOCopyWith<$Res>  {
  factory $FirestoreContactDAOCopyWith(FirestoreContactDAO value, $Res Function(FirestoreContactDAO) _then) = _$FirestoreContactDAOCopyWithImpl;
@useResult
$Res call({
 String address, String id, double latitude, double longitude, String name, String nameUrl, String other, String phoneNumber, String time, String timeOther
});




}
/// @nodoc
class _$FirestoreContactDAOCopyWithImpl<$Res>
    implements $FirestoreContactDAOCopyWith<$Res> {
  _$FirestoreContactDAOCopyWithImpl(this._self, this._then);

  final FirestoreContactDAO _self;
  final $Res Function(FirestoreContactDAO) _then;

/// Create a copy of FirestoreContactDAO
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? address = null,Object? id = null,Object? latitude = null,Object? longitude = null,Object? name = null,Object? nameUrl = null,Object? other = null,Object? phoneNumber = null,Object? time = null,Object? timeOther = null,}) {
  return _then(_self.copyWith(
address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameUrl: null == nameUrl ? _self.nameUrl : nameUrl // ignore: cast_nullable_to_non_nullable
as String,other: null == other ? _self.other : other // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,timeOther: null == timeOther ? _self.timeOther : timeOther // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _FirestoreContactDAO extends FirestoreContactDAO {
  const _FirestoreContactDAO({required this.address, required this.id, required this.latitude, required this.longitude, required this.name, required this.nameUrl, required this.other, required this.phoneNumber, required this.time, required this.timeOther}): super._();
  factory _FirestoreContactDAO.fromJson(Map<String, dynamic> json) => _$FirestoreContactDAOFromJson(json);

@override final  String address;
@override final  String id;
@override final  double latitude;
@override final  double longitude;
@override final  String name;
@override final  String nameUrl;
@override final  String other;
@override final  String phoneNumber;
@override final  String time;
@override final  String timeOther;

/// Create a copy of FirestoreContactDAO
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FirestoreContactDAOCopyWith<_FirestoreContactDAO> get copyWith => __$FirestoreContactDAOCopyWithImpl<_FirestoreContactDAO>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FirestoreContactDAOToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FirestoreContactDAO&&(identical(other.address, address) || other.address == address)&&(identical(other.id, id) || other.id == id)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameUrl, nameUrl) || other.nameUrl == nameUrl)&&(identical(other.other, this.other) || other.other == this.other)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.time, time) || other.time == time)&&(identical(other.timeOther, timeOther) || other.timeOther == timeOther));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,address,id,latitude,longitude,name,nameUrl,other,phoneNumber,time,timeOther);

@override
String toString() {
  return 'FirestoreContactDAO(address: $address, id: $id, latitude: $latitude, longitude: $longitude, name: $name, nameUrl: $nameUrl, other: $other, phoneNumber: $phoneNumber, time: $time, timeOther: $timeOther)';
}


}

/// @nodoc
abstract mixin class _$FirestoreContactDAOCopyWith<$Res> implements $FirestoreContactDAOCopyWith<$Res> {
  factory _$FirestoreContactDAOCopyWith(_FirestoreContactDAO value, $Res Function(_FirestoreContactDAO) _then) = __$FirestoreContactDAOCopyWithImpl;
@override @useResult
$Res call({
 String address, String id, double latitude, double longitude, String name, String nameUrl, String other, String phoneNumber, String time, String timeOther
});




}
/// @nodoc
class __$FirestoreContactDAOCopyWithImpl<$Res>
    implements _$FirestoreContactDAOCopyWith<$Res> {
  __$FirestoreContactDAOCopyWithImpl(this._self, this._then);

  final _FirestoreContactDAO _self;
  final $Res Function(_FirestoreContactDAO) _then;

/// Create a copy of FirestoreContactDAO
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? address = null,Object? id = null,Object? latitude = null,Object? longitude = null,Object? name = null,Object? nameUrl = null,Object? other = null,Object? phoneNumber = null,Object? time = null,Object? timeOther = null,}) {
  return _then(_FirestoreContactDAO(
address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameUrl: null == nameUrl ? _self.nameUrl : nameUrl // ignore: cast_nullable_to_non_nullable
as String,other: null == other ? _self.other : other // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,timeOther: null == timeOther ? _self.timeOther : timeOther // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
