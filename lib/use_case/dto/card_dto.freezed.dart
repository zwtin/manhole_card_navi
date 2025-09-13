// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'card_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CardDTO {

 String get id; String get name; String get colorImageUrl; String get grayImageUrl; double get latitude; double get longitude; String get prefectureId; String get prefectureName; String get volumeId; String get volumeName; DateTime get publicationDate; String get distributionLinkText; String get distributionLinkUrl; String get distributionText; String get distributionOther; List<ContactDTO> get contacts;
/// Create a copy of CardDTO
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CardDTOCopyWith<CardDTO> get copyWith => _$CardDTOCopyWithImpl<CardDTO>(this as CardDTO, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CardDTO&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.colorImageUrl, colorImageUrl) || other.colorImageUrl == colorImageUrl)&&(identical(other.grayImageUrl, grayImageUrl) || other.grayImageUrl == grayImageUrl)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.prefectureId, prefectureId) || other.prefectureId == prefectureId)&&(identical(other.prefectureName, prefectureName) || other.prefectureName == prefectureName)&&(identical(other.volumeId, volumeId) || other.volumeId == volumeId)&&(identical(other.volumeName, volumeName) || other.volumeName == volumeName)&&(identical(other.publicationDate, publicationDate) || other.publicationDate == publicationDate)&&(identical(other.distributionLinkText, distributionLinkText) || other.distributionLinkText == distributionLinkText)&&(identical(other.distributionLinkUrl, distributionLinkUrl) || other.distributionLinkUrl == distributionLinkUrl)&&(identical(other.distributionText, distributionText) || other.distributionText == distributionText)&&(identical(other.distributionOther, distributionOther) || other.distributionOther == distributionOther)&&const DeepCollectionEquality().equals(other.contacts, contacts));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,colorImageUrl,grayImageUrl,latitude,longitude,prefectureId,prefectureName,volumeId,volumeName,publicationDate,distributionLinkText,distributionLinkUrl,distributionText,distributionOther,const DeepCollectionEquality().hash(contacts));

@override
String toString() {
  return 'CardDTO(id: $id, name: $name, colorImageUrl: $colorImageUrl, grayImageUrl: $grayImageUrl, latitude: $latitude, longitude: $longitude, prefectureId: $prefectureId, prefectureName: $prefectureName, volumeId: $volumeId, volumeName: $volumeName, publicationDate: $publicationDate, distributionLinkText: $distributionLinkText, distributionLinkUrl: $distributionLinkUrl, distributionText: $distributionText, distributionOther: $distributionOther, contacts: $contacts)';
}


}

/// @nodoc
abstract mixin class $CardDTOCopyWith<$Res>  {
  factory $CardDTOCopyWith(CardDTO value, $Res Function(CardDTO) _then) = _$CardDTOCopyWithImpl;
@useResult
$Res call({
 String id, String name, String colorImageUrl, String grayImageUrl, double latitude, double longitude, String prefectureId, String prefectureName, String volumeId, String volumeName, DateTime publicationDate, String distributionLinkText, String distributionLinkUrl, String distributionText, String distributionOther, List<ContactDTO> contacts
});




}
/// @nodoc
class _$CardDTOCopyWithImpl<$Res>
    implements $CardDTOCopyWith<$Res> {
  _$CardDTOCopyWithImpl(this._self, this._then);

  final CardDTO _self;
  final $Res Function(CardDTO) _then;

/// Create a copy of CardDTO
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? colorImageUrl = null,Object? grayImageUrl = null,Object? latitude = null,Object? longitude = null,Object? prefectureId = null,Object? prefectureName = null,Object? volumeId = null,Object? volumeName = null,Object? publicationDate = null,Object? distributionLinkText = null,Object? distributionLinkUrl = null,Object? distributionText = null,Object? distributionOther = null,Object? contacts = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,colorImageUrl: null == colorImageUrl ? _self.colorImageUrl : colorImageUrl // ignore: cast_nullable_to_non_nullable
as String,grayImageUrl: null == grayImageUrl ? _self.grayImageUrl : grayImageUrl // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,prefectureId: null == prefectureId ? _self.prefectureId : prefectureId // ignore: cast_nullable_to_non_nullable
as String,prefectureName: null == prefectureName ? _self.prefectureName : prefectureName // ignore: cast_nullable_to_non_nullable
as String,volumeId: null == volumeId ? _self.volumeId : volumeId // ignore: cast_nullable_to_non_nullable
as String,volumeName: null == volumeName ? _self.volumeName : volumeName // ignore: cast_nullable_to_non_nullable
as String,publicationDate: null == publicationDate ? _self.publicationDate : publicationDate // ignore: cast_nullable_to_non_nullable
as DateTime,distributionLinkText: null == distributionLinkText ? _self.distributionLinkText : distributionLinkText // ignore: cast_nullable_to_non_nullable
as String,distributionLinkUrl: null == distributionLinkUrl ? _self.distributionLinkUrl : distributionLinkUrl // ignore: cast_nullable_to_non_nullable
as String,distributionText: null == distributionText ? _self.distributionText : distributionText // ignore: cast_nullable_to_non_nullable
as String,distributionOther: null == distributionOther ? _self.distributionOther : distributionOther // ignore: cast_nullable_to_non_nullable
as String,contacts: null == contacts ? _self.contacts : contacts // ignore: cast_nullable_to_non_nullable
as List<ContactDTO>,
  ));
}

}


/// @nodoc


class _CardDTO extends CardDTO {
  const _CardDTO({required this.id, required this.name, required this.colorImageUrl, required this.grayImageUrl, required this.latitude, required this.longitude, required this.prefectureId, required this.prefectureName, required this.volumeId, required this.volumeName, required this.publicationDate, required this.distributionLinkText, required this.distributionLinkUrl, required this.distributionText, required this.distributionOther, required final  List<ContactDTO> contacts}): _contacts = contacts,super._();
  

@override final  String id;
@override final  String name;
@override final  String colorImageUrl;
@override final  String grayImageUrl;
@override final  double latitude;
@override final  double longitude;
@override final  String prefectureId;
@override final  String prefectureName;
@override final  String volumeId;
@override final  String volumeName;
@override final  DateTime publicationDate;
@override final  String distributionLinkText;
@override final  String distributionLinkUrl;
@override final  String distributionText;
@override final  String distributionOther;
 final  List<ContactDTO> _contacts;
@override List<ContactDTO> get contacts {
  if (_contacts is EqualUnmodifiableListView) return _contacts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_contacts);
}


/// Create a copy of CardDTO
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CardDTOCopyWith<_CardDTO> get copyWith => __$CardDTOCopyWithImpl<_CardDTO>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CardDTO&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.colorImageUrl, colorImageUrl) || other.colorImageUrl == colorImageUrl)&&(identical(other.grayImageUrl, grayImageUrl) || other.grayImageUrl == grayImageUrl)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.prefectureId, prefectureId) || other.prefectureId == prefectureId)&&(identical(other.prefectureName, prefectureName) || other.prefectureName == prefectureName)&&(identical(other.volumeId, volumeId) || other.volumeId == volumeId)&&(identical(other.volumeName, volumeName) || other.volumeName == volumeName)&&(identical(other.publicationDate, publicationDate) || other.publicationDate == publicationDate)&&(identical(other.distributionLinkText, distributionLinkText) || other.distributionLinkText == distributionLinkText)&&(identical(other.distributionLinkUrl, distributionLinkUrl) || other.distributionLinkUrl == distributionLinkUrl)&&(identical(other.distributionText, distributionText) || other.distributionText == distributionText)&&(identical(other.distributionOther, distributionOther) || other.distributionOther == distributionOther)&&const DeepCollectionEquality().equals(other._contacts, _contacts));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,colorImageUrl,grayImageUrl,latitude,longitude,prefectureId,prefectureName,volumeId,volumeName,publicationDate,distributionLinkText,distributionLinkUrl,distributionText,distributionOther,const DeepCollectionEquality().hash(_contacts));

@override
String toString() {
  return 'CardDTO(id: $id, name: $name, colorImageUrl: $colorImageUrl, grayImageUrl: $grayImageUrl, latitude: $latitude, longitude: $longitude, prefectureId: $prefectureId, prefectureName: $prefectureName, volumeId: $volumeId, volumeName: $volumeName, publicationDate: $publicationDate, distributionLinkText: $distributionLinkText, distributionLinkUrl: $distributionLinkUrl, distributionText: $distributionText, distributionOther: $distributionOther, contacts: $contacts)';
}


}

/// @nodoc
abstract mixin class _$CardDTOCopyWith<$Res> implements $CardDTOCopyWith<$Res> {
  factory _$CardDTOCopyWith(_CardDTO value, $Res Function(_CardDTO) _then) = __$CardDTOCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String colorImageUrl, String grayImageUrl, double latitude, double longitude, String prefectureId, String prefectureName, String volumeId, String volumeName, DateTime publicationDate, String distributionLinkText, String distributionLinkUrl, String distributionText, String distributionOther, List<ContactDTO> contacts
});




}
/// @nodoc
class __$CardDTOCopyWithImpl<$Res>
    implements _$CardDTOCopyWith<$Res> {
  __$CardDTOCopyWithImpl(this._self, this._then);

  final _CardDTO _self;
  final $Res Function(_CardDTO) _then;

/// Create a copy of CardDTO
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? colorImageUrl = null,Object? grayImageUrl = null,Object? latitude = null,Object? longitude = null,Object? prefectureId = null,Object? prefectureName = null,Object? volumeId = null,Object? volumeName = null,Object? publicationDate = null,Object? distributionLinkText = null,Object? distributionLinkUrl = null,Object? distributionText = null,Object? distributionOther = null,Object? contacts = null,}) {
  return _then(_CardDTO(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,colorImageUrl: null == colorImageUrl ? _self.colorImageUrl : colorImageUrl // ignore: cast_nullable_to_non_nullable
as String,grayImageUrl: null == grayImageUrl ? _self.grayImageUrl : grayImageUrl // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,prefectureId: null == prefectureId ? _self.prefectureId : prefectureId // ignore: cast_nullable_to_non_nullable
as String,prefectureName: null == prefectureName ? _self.prefectureName : prefectureName // ignore: cast_nullable_to_non_nullable
as String,volumeId: null == volumeId ? _self.volumeId : volumeId // ignore: cast_nullable_to_non_nullable
as String,volumeName: null == volumeName ? _self.volumeName : volumeName // ignore: cast_nullable_to_non_nullable
as String,publicationDate: null == publicationDate ? _self.publicationDate : publicationDate // ignore: cast_nullable_to_non_nullable
as DateTime,distributionLinkText: null == distributionLinkText ? _self.distributionLinkText : distributionLinkText // ignore: cast_nullable_to_non_nullable
as String,distributionLinkUrl: null == distributionLinkUrl ? _self.distributionLinkUrl : distributionLinkUrl // ignore: cast_nullable_to_non_nullable
as String,distributionText: null == distributionText ? _self.distributionText : distributionText // ignore: cast_nullable_to_non_nullable
as String,distributionOther: null == distributionOther ? _self.distributionOther : distributionOther // ignore: cast_nullable_to_non_nullable
as String,contacts: null == contacts ? _self._contacts : contacts // ignore: cast_nullable_to_non_nullable
as List<ContactDTO>,
  ));
}


}

// dart format on
