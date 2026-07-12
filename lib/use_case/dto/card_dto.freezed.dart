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

 String get id; String get name;/// カード画像の Firebase Hosting 上のパス。
 String get imagePath; double get latitude; double get longitude; String get prefectureId; String get prefectureName; String get volumeId; String get volumeName; DateTime get publicationDate; String get distributionPlaceHtml; String get stockHtml;
/// Create a copy of CardDTO
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CardDTOCopyWith<CardDTO> get copyWith => _$CardDTOCopyWithImpl<CardDTO>(this as CardDTO, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CardDTO&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.imagePath, imagePath) || other.imagePath == imagePath)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.prefectureId, prefectureId) || other.prefectureId == prefectureId)&&(identical(other.prefectureName, prefectureName) || other.prefectureName == prefectureName)&&(identical(other.volumeId, volumeId) || other.volumeId == volumeId)&&(identical(other.volumeName, volumeName) || other.volumeName == volumeName)&&(identical(other.publicationDate, publicationDate) || other.publicationDate == publicationDate)&&(identical(other.distributionPlaceHtml, distributionPlaceHtml) || other.distributionPlaceHtml == distributionPlaceHtml)&&(identical(other.stockHtml, stockHtml) || other.stockHtml == stockHtml));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,imagePath,latitude,longitude,prefectureId,prefectureName,volumeId,volumeName,publicationDate,distributionPlaceHtml,stockHtml);

@override
String toString() {
  return 'CardDTO(id: $id, name: $name, imagePath: $imagePath, latitude: $latitude, longitude: $longitude, prefectureId: $prefectureId, prefectureName: $prefectureName, volumeId: $volumeId, volumeName: $volumeName, publicationDate: $publicationDate, distributionPlaceHtml: $distributionPlaceHtml, stockHtml: $stockHtml)';
}


}

/// @nodoc
abstract mixin class $CardDTOCopyWith<$Res>  {
  factory $CardDTOCopyWith(CardDTO value, $Res Function(CardDTO) _then) = _$CardDTOCopyWithImpl;
@useResult
$Res call({
 String id, String name, String imagePath, double latitude, double longitude, String prefectureId, String prefectureName, String volumeId, String volumeName, DateTime publicationDate, String distributionPlaceHtml, String stockHtml
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? imagePath = null,Object? latitude = null,Object? longitude = null,Object? prefectureId = null,Object? prefectureName = null,Object? volumeId = null,Object? volumeName = null,Object? publicationDate = null,Object? distributionPlaceHtml = null,Object? stockHtml = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,imagePath: null == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,prefectureId: null == prefectureId ? _self.prefectureId : prefectureId // ignore: cast_nullable_to_non_nullable
as String,prefectureName: null == prefectureName ? _self.prefectureName : prefectureName // ignore: cast_nullable_to_non_nullable
as String,volumeId: null == volumeId ? _self.volumeId : volumeId // ignore: cast_nullable_to_non_nullable
as String,volumeName: null == volumeName ? _self.volumeName : volumeName // ignore: cast_nullable_to_non_nullable
as String,publicationDate: null == publicationDate ? _self.publicationDate : publicationDate // ignore: cast_nullable_to_non_nullable
as DateTime,distributionPlaceHtml: null == distributionPlaceHtml ? _self.distributionPlaceHtml : distributionPlaceHtml // ignore: cast_nullable_to_non_nullable
as String,stockHtml: null == stockHtml ? _self.stockHtml : stockHtml // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc


class _CardDTO extends CardDTO {
  const _CardDTO({required this.id, required this.name, required this.imagePath, required this.latitude, required this.longitude, required this.prefectureId, required this.prefectureName, required this.volumeId, required this.volumeName, required this.publicationDate, required this.distributionPlaceHtml, required this.stockHtml}): super._();
  

@override final  String id;
@override final  String name;
/// カード画像の Firebase Hosting 上のパス。
@override final  String imagePath;
@override final  double latitude;
@override final  double longitude;
@override final  String prefectureId;
@override final  String prefectureName;
@override final  String volumeId;
@override final  String volumeName;
@override final  DateTime publicationDate;
@override final  String distributionPlaceHtml;
@override final  String stockHtml;

/// Create a copy of CardDTO
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CardDTOCopyWith<_CardDTO> get copyWith => __$CardDTOCopyWithImpl<_CardDTO>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CardDTO&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.imagePath, imagePath) || other.imagePath == imagePath)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.prefectureId, prefectureId) || other.prefectureId == prefectureId)&&(identical(other.prefectureName, prefectureName) || other.prefectureName == prefectureName)&&(identical(other.volumeId, volumeId) || other.volumeId == volumeId)&&(identical(other.volumeName, volumeName) || other.volumeName == volumeName)&&(identical(other.publicationDate, publicationDate) || other.publicationDate == publicationDate)&&(identical(other.distributionPlaceHtml, distributionPlaceHtml) || other.distributionPlaceHtml == distributionPlaceHtml)&&(identical(other.stockHtml, stockHtml) || other.stockHtml == stockHtml));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,imagePath,latitude,longitude,prefectureId,prefectureName,volumeId,volumeName,publicationDate,distributionPlaceHtml,stockHtml);

@override
String toString() {
  return 'CardDTO(id: $id, name: $name, imagePath: $imagePath, latitude: $latitude, longitude: $longitude, prefectureId: $prefectureId, prefectureName: $prefectureName, volumeId: $volumeId, volumeName: $volumeName, publicationDate: $publicationDate, distributionPlaceHtml: $distributionPlaceHtml, stockHtml: $stockHtml)';
}


}

/// @nodoc
abstract mixin class _$CardDTOCopyWith<$Res> implements $CardDTOCopyWith<$Res> {
  factory _$CardDTOCopyWith(_CardDTO value, $Res Function(_CardDTO) _then) = __$CardDTOCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String imagePath, double latitude, double longitude, String prefectureId, String prefectureName, String volumeId, String volumeName, DateTime publicationDate, String distributionPlaceHtml, String stockHtml
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? imagePath = null,Object? latitude = null,Object? longitude = null,Object? prefectureId = null,Object? prefectureName = null,Object? volumeId = null,Object? volumeName = null,Object? publicationDate = null,Object? distributionPlaceHtml = null,Object? stockHtml = null,}) {
  return _then(_CardDTO(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,imagePath: null == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,prefectureId: null == prefectureId ? _self.prefectureId : prefectureId // ignore: cast_nullable_to_non_nullable
as String,prefectureName: null == prefectureName ? _self.prefectureName : prefectureName // ignore: cast_nullable_to_non_nullable
as String,volumeId: null == volumeId ? _self.volumeId : volumeId // ignore: cast_nullable_to_non_nullable
as String,volumeName: null == volumeName ? _self.volumeName : volumeName // ignore: cast_nullable_to_non_nullable
as String,publicationDate: null == publicationDate ? _self.publicationDate : publicationDate // ignore: cast_nullable_to_non_nullable
as DateTime,distributionPlaceHtml: null == distributionPlaceHtml ? _self.distributionPlaceHtml : distributionPlaceHtml // ignore: cast_nullable_to_non_nullable
as String,stockHtml: null == stockHtml ? _self.stockHtml : stockHtml // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
