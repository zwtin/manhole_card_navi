// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'firestore_card_dao.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FirestoreCardDAO {

 String get id; double get latitude; double get longitude; String get name; String get publicationDate; String get imageId; String get prefectureId; String get volumeId; String get distributionState; String get distributionLinkText; String get distributionLinkUrl; String get distributionText; String get distributionOther;
/// Create a copy of FirestoreCardDAO
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FirestoreCardDAOCopyWith<FirestoreCardDAO> get copyWith => _$FirestoreCardDAOCopyWithImpl<FirestoreCardDAO>(this as FirestoreCardDAO, _$identity);

  /// Serializes this FirestoreCardDAO to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FirestoreCardDAO&&(identical(other.id, id) || other.id == id)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.name, name) || other.name == name)&&(identical(other.publicationDate, publicationDate) || other.publicationDate == publicationDate)&&(identical(other.imageId, imageId) || other.imageId == imageId)&&(identical(other.prefectureId, prefectureId) || other.prefectureId == prefectureId)&&(identical(other.volumeId, volumeId) || other.volumeId == volumeId)&&(identical(other.distributionState, distributionState) || other.distributionState == distributionState)&&(identical(other.distributionLinkText, distributionLinkText) || other.distributionLinkText == distributionLinkText)&&(identical(other.distributionLinkUrl, distributionLinkUrl) || other.distributionLinkUrl == distributionLinkUrl)&&(identical(other.distributionText, distributionText) || other.distributionText == distributionText)&&(identical(other.distributionOther, distributionOther) || other.distributionOther == distributionOther));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,latitude,longitude,name,publicationDate,imageId,prefectureId,volumeId,distributionState,distributionLinkText,distributionLinkUrl,distributionText,distributionOther);

@override
String toString() {
  return 'FirestoreCardDAO(id: $id, latitude: $latitude, longitude: $longitude, name: $name, publicationDate: $publicationDate, imageId: $imageId, prefectureId: $prefectureId, volumeId: $volumeId, distributionState: $distributionState, distributionLinkText: $distributionLinkText, distributionLinkUrl: $distributionLinkUrl, distributionText: $distributionText, distributionOther: $distributionOther)';
}


}

/// @nodoc
abstract mixin class $FirestoreCardDAOCopyWith<$Res>  {
  factory $FirestoreCardDAOCopyWith(FirestoreCardDAO value, $Res Function(FirestoreCardDAO) _then) = _$FirestoreCardDAOCopyWithImpl;
@useResult
$Res call({
 String id, double latitude, double longitude, String name, String publicationDate, String imageId, String prefectureId, String volumeId, String distributionState, String distributionLinkText, String distributionLinkUrl, String distributionText, String distributionOther
});




}
/// @nodoc
class _$FirestoreCardDAOCopyWithImpl<$Res>
    implements $FirestoreCardDAOCopyWith<$Res> {
  _$FirestoreCardDAOCopyWithImpl(this._self, this._then);

  final FirestoreCardDAO _self;
  final $Res Function(FirestoreCardDAO) _then;

/// Create a copy of FirestoreCardDAO
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? latitude = null,Object? longitude = null,Object? name = null,Object? publicationDate = null,Object? imageId = null,Object? prefectureId = null,Object? volumeId = null,Object? distributionState = null,Object? distributionLinkText = null,Object? distributionLinkUrl = null,Object? distributionText = null,Object? distributionOther = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,publicationDate: null == publicationDate ? _self.publicationDate : publicationDate // ignore: cast_nullable_to_non_nullable
as String,imageId: null == imageId ? _self.imageId : imageId // ignore: cast_nullable_to_non_nullable
as String,prefectureId: null == prefectureId ? _self.prefectureId : prefectureId // ignore: cast_nullable_to_non_nullable
as String,volumeId: null == volumeId ? _self.volumeId : volumeId // ignore: cast_nullable_to_non_nullable
as String,distributionState: null == distributionState ? _self.distributionState : distributionState // ignore: cast_nullable_to_non_nullable
as String,distributionLinkText: null == distributionLinkText ? _self.distributionLinkText : distributionLinkText // ignore: cast_nullable_to_non_nullable
as String,distributionLinkUrl: null == distributionLinkUrl ? _self.distributionLinkUrl : distributionLinkUrl // ignore: cast_nullable_to_non_nullable
as String,distributionText: null == distributionText ? _self.distributionText : distributionText // ignore: cast_nullable_to_non_nullable
as String,distributionOther: null == distributionOther ? _self.distributionOther : distributionOther // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _FirestoreCardDAO extends FirestoreCardDAO {
  const _FirestoreCardDAO({required this.id, required this.latitude, required this.longitude, required this.name, required this.publicationDate, required this.imageId, required this.prefectureId, required this.volumeId, required this.distributionState, required this.distributionLinkText, required this.distributionLinkUrl, required this.distributionText, required this.distributionOther}): super._();
  factory _FirestoreCardDAO.fromJson(Map<String, dynamic> json) => _$FirestoreCardDAOFromJson(json);

@override final  String id;
@override final  double latitude;
@override final  double longitude;
@override final  String name;
@override final  String publicationDate;
@override final  String imageId;
@override final  String prefectureId;
@override final  String volumeId;
@override final  String distributionState;
@override final  String distributionLinkText;
@override final  String distributionLinkUrl;
@override final  String distributionText;
@override final  String distributionOther;

/// Create a copy of FirestoreCardDAO
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FirestoreCardDAOCopyWith<_FirestoreCardDAO> get copyWith => __$FirestoreCardDAOCopyWithImpl<_FirestoreCardDAO>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FirestoreCardDAOToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FirestoreCardDAO&&(identical(other.id, id) || other.id == id)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.name, name) || other.name == name)&&(identical(other.publicationDate, publicationDate) || other.publicationDate == publicationDate)&&(identical(other.imageId, imageId) || other.imageId == imageId)&&(identical(other.prefectureId, prefectureId) || other.prefectureId == prefectureId)&&(identical(other.volumeId, volumeId) || other.volumeId == volumeId)&&(identical(other.distributionState, distributionState) || other.distributionState == distributionState)&&(identical(other.distributionLinkText, distributionLinkText) || other.distributionLinkText == distributionLinkText)&&(identical(other.distributionLinkUrl, distributionLinkUrl) || other.distributionLinkUrl == distributionLinkUrl)&&(identical(other.distributionText, distributionText) || other.distributionText == distributionText)&&(identical(other.distributionOther, distributionOther) || other.distributionOther == distributionOther));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,latitude,longitude,name,publicationDate,imageId,prefectureId,volumeId,distributionState,distributionLinkText,distributionLinkUrl,distributionText,distributionOther);

@override
String toString() {
  return 'FirestoreCardDAO(id: $id, latitude: $latitude, longitude: $longitude, name: $name, publicationDate: $publicationDate, imageId: $imageId, prefectureId: $prefectureId, volumeId: $volumeId, distributionState: $distributionState, distributionLinkText: $distributionLinkText, distributionLinkUrl: $distributionLinkUrl, distributionText: $distributionText, distributionOther: $distributionOther)';
}


}

/// @nodoc
abstract mixin class _$FirestoreCardDAOCopyWith<$Res> implements $FirestoreCardDAOCopyWith<$Res> {
  factory _$FirestoreCardDAOCopyWith(_FirestoreCardDAO value, $Res Function(_FirestoreCardDAO) _then) = __$FirestoreCardDAOCopyWithImpl;
@override @useResult
$Res call({
 String id, double latitude, double longitude, String name, String publicationDate, String imageId, String prefectureId, String volumeId, String distributionState, String distributionLinkText, String distributionLinkUrl, String distributionText, String distributionOther
});




}
/// @nodoc
class __$FirestoreCardDAOCopyWithImpl<$Res>
    implements _$FirestoreCardDAOCopyWith<$Res> {
  __$FirestoreCardDAOCopyWithImpl(this._self, this._then);

  final _FirestoreCardDAO _self;
  final $Res Function(_FirestoreCardDAO) _then;

/// Create a copy of FirestoreCardDAO
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? latitude = null,Object? longitude = null,Object? name = null,Object? publicationDate = null,Object? imageId = null,Object? prefectureId = null,Object? volumeId = null,Object? distributionState = null,Object? distributionLinkText = null,Object? distributionLinkUrl = null,Object? distributionText = null,Object? distributionOther = null,}) {
  return _then(_FirestoreCardDAO(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,publicationDate: null == publicationDate ? _self.publicationDate : publicationDate // ignore: cast_nullable_to_non_nullable
as String,imageId: null == imageId ? _self.imageId : imageId // ignore: cast_nullable_to_non_nullable
as String,prefectureId: null == prefectureId ? _self.prefectureId : prefectureId // ignore: cast_nullable_to_non_nullable
as String,volumeId: null == volumeId ? _self.volumeId : volumeId // ignore: cast_nullable_to_non_nullable
as String,distributionState: null == distributionState ? _self.distributionState : distributionState // ignore: cast_nullable_to_non_nullable
as String,distributionLinkText: null == distributionLinkText ? _self.distributionLinkText : distributionLinkText // ignore: cast_nullable_to_non_nullable
as String,distributionLinkUrl: null == distributionLinkUrl ? _self.distributionLinkUrl : distributionLinkUrl // ignore: cast_nullable_to_non_nullable
as String,distributionText: null == distributionText ? _self.distributionText : distributionText // ignore: cast_nullable_to_non_nullable
as String,distributionOther: null == distributionOther ? _self.distributionOther : distributionOther // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
