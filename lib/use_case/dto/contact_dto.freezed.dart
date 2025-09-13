// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contact_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ContactDTO {

 String get id; String get name; String get nameUrl; String get address; String get phoneNumber; double get latitude; double get longitude; String get other; String get time; String get timeOther;
/// Create a copy of ContactDTO
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContactDTOCopyWith<ContactDTO> get copyWith => _$ContactDTOCopyWithImpl<ContactDTO>(this as ContactDTO, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContactDTO&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameUrl, nameUrl) || other.nameUrl == nameUrl)&&(identical(other.address, address) || other.address == address)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.other, this.other) || other.other == this.other)&&(identical(other.time, time) || other.time == time)&&(identical(other.timeOther, timeOther) || other.timeOther == timeOther));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,nameUrl,address,phoneNumber,latitude,longitude,other,time,timeOther);

@override
String toString() {
  return 'ContactDTO(id: $id, name: $name, nameUrl: $nameUrl, address: $address, phoneNumber: $phoneNumber, latitude: $latitude, longitude: $longitude, other: $other, time: $time, timeOther: $timeOther)';
}


}

/// @nodoc
abstract mixin class $ContactDTOCopyWith<$Res>  {
  factory $ContactDTOCopyWith(ContactDTO value, $Res Function(ContactDTO) _then) = _$ContactDTOCopyWithImpl;
@useResult
$Res call({
 String id, String name, String nameUrl, String address, String phoneNumber, double latitude, double longitude, String other, String time, String timeOther
});




}
/// @nodoc
class _$ContactDTOCopyWithImpl<$Res>
    implements $ContactDTOCopyWith<$Res> {
  _$ContactDTOCopyWithImpl(this._self, this._then);

  final ContactDTO _self;
  final $Res Function(ContactDTO) _then;

/// Create a copy of ContactDTO
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? nameUrl = null,Object? address = null,Object? phoneNumber = null,Object? latitude = null,Object? longitude = null,Object? other = null,Object? time = null,Object? timeOther = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameUrl: null == nameUrl ? _self.nameUrl : nameUrl // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,other: null == other ? _self.other : other // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,timeOther: null == timeOther ? _self.timeOther : timeOther // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc


class _ContactDTO extends ContactDTO {
  const _ContactDTO({required this.id, required this.name, required this.nameUrl, required this.address, required this.phoneNumber, required this.latitude, required this.longitude, required this.other, required this.time, required this.timeOther}): super._();
  

@override final  String id;
@override final  String name;
@override final  String nameUrl;
@override final  String address;
@override final  String phoneNumber;
@override final  double latitude;
@override final  double longitude;
@override final  String other;
@override final  String time;
@override final  String timeOther;

/// Create a copy of ContactDTO
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContactDTOCopyWith<_ContactDTO> get copyWith => __$ContactDTOCopyWithImpl<_ContactDTO>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContactDTO&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameUrl, nameUrl) || other.nameUrl == nameUrl)&&(identical(other.address, address) || other.address == address)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.other, this.other) || other.other == this.other)&&(identical(other.time, time) || other.time == time)&&(identical(other.timeOther, timeOther) || other.timeOther == timeOther));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,nameUrl,address,phoneNumber,latitude,longitude,other,time,timeOther);

@override
String toString() {
  return 'ContactDTO(id: $id, name: $name, nameUrl: $nameUrl, address: $address, phoneNumber: $phoneNumber, latitude: $latitude, longitude: $longitude, other: $other, time: $time, timeOther: $timeOther)';
}


}

/// @nodoc
abstract mixin class _$ContactDTOCopyWith<$Res> implements $ContactDTOCopyWith<$Res> {
  factory _$ContactDTOCopyWith(_ContactDTO value, $Res Function(_ContactDTO) _then) = __$ContactDTOCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String nameUrl, String address, String phoneNumber, double latitude, double longitude, String other, String time, String timeOther
});




}
/// @nodoc
class __$ContactDTOCopyWithImpl<$Res>
    implements _$ContactDTOCopyWith<$Res> {
  __$ContactDTOCopyWithImpl(this._self, this._then);

  final _ContactDTO _self;
  final $Res Function(_ContactDTO) _then;

/// Create a copy of ContactDTO
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? nameUrl = null,Object? address = null,Object? phoneNumber = null,Object? latitude = null,Object? longitude = null,Object? other = null,Object? time = null,Object? timeOther = null,}) {
  return _then(_ContactDTO(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameUrl: null == nameUrl ? _self.nameUrl : nameUrl // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,other: null == other ? _self.other : other // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,timeOther: null == timeOther ? _self.timeOther : timeOther // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
