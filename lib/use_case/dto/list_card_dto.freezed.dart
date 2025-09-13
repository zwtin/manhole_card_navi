// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'list_card_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ListCardDTO {

 String get id; String get name; String get colorImageUrl; String get grayImageUrl; String get prefectureId; String get prefectureName; String get volumeId; String get volumeName; DateTime get publicationDate;
/// Create a copy of ListCardDTO
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ListCardDTOCopyWith<ListCardDTO> get copyWith => _$ListCardDTOCopyWithImpl<ListCardDTO>(this as ListCardDTO, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ListCardDTO&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.colorImageUrl, colorImageUrl) || other.colorImageUrl == colorImageUrl)&&(identical(other.grayImageUrl, grayImageUrl) || other.grayImageUrl == grayImageUrl)&&(identical(other.prefectureId, prefectureId) || other.prefectureId == prefectureId)&&(identical(other.prefectureName, prefectureName) || other.prefectureName == prefectureName)&&(identical(other.volumeId, volumeId) || other.volumeId == volumeId)&&(identical(other.volumeName, volumeName) || other.volumeName == volumeName)&&(identical(other.publicationDate, publicationDate) || other.publicationDate == publicationDate));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,colorImageUrl,grayImageUrl,prefectureId,prefectureName,volumeId,volumeName,publicationDate);

@override
String toString() {
  return 'ListCardDTO(id: $id, name: $name, colorImageUrl: $colorImageUrl, grayImageUrl: $grayImageUrl, prefectureId: $prefectureId, prefectureName: $prefectureName, volumeId: $volumeId, volumeName: $volumeName, publicationDate: $publicationDate)';
}


}

/// @nodoc
abstract mixin class $ListCardDTOCopyWith<$Res>  {
  factory $ListCardDTOCopyWith(ListCardDTO value, $Res Function(ListCardDTO) _then) = _$ListCardDTOCopyWithImpl;
@useResult
$Res call({
 String id, String name, String colorImageUrl, String grayImageUrl, String prefectureId, String prefectureName, String volumeId, String volumeName, DateTime publicationDate
});




}
/// @nodoc
class _$ListCardDTOCopyWithImpl<$Res>
    implements $ListCardDTOCopyWith<$Res> {
  _$ListCardDTOCopyWithImpl(this._self, this._then);

  final ListCardDTO _self;
  final $Res Function(ListCardDTO) _then;

/// Create a copy of ListCardDTO
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? colorImageUrl = null,Object? grayImageUrl = null,Object? prefectureId = null,Object? prefectureName = null,Object? volumeId = null,Object? volumeName = null,Object? publicationDate = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,colorImageUrl: null == colorImageUrl ? _self.colorImageUrl : colorImageUrl // ignore: cast_nullable_to_non_nullable
as String,grayImageUrl: null == grayImageUrl ? _self.grayImageUrl : grayImageUrl // ignore: cast_nullable_to_non_nullable
as String,prefectureId: null == prefectureId ? _self.prefectureId : prefectureId // ignore: cast_nullable_to_non_nullable
as String,prefectureName: null == prefectureName ? _self.prefectureName : prefectureName // ignore: cast_nullable_to_non_nullable
as String,volumeId: null == volumeId ? _self.volumeId : volumeId // ignore: cast_nullable_to_non_nullable
as String,volumeName: null == volumeName ? _self.volumeName : volumeName // ignore: cast_nullable_to_non_nullable
as String,publicationDate: null == publicationDate ? _self.publicationDate : publicationDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// @nodoc


class _ListCardDTO extends ListCardDTO {
  const _ListCardDTO({required this.id, required this.name, required this.colorImageUrl, required this.grayImageUrl, required this.prefectureId, required this.prefectureName, required this.volumeId, required this.volumeName, required this.publicationDate}): super._();
  

@override final  String id;
@override final  String name;
@override final  String colorImageUrl;
@override final  String grayImageUrl;
@override final  String prefectureId;
@override final  String prefectureName;
@override final  String volumeId;
@override final  String volumeName;
@override final  DateTime publicationDate;

/// Create a copy of ListCardDTO
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ListCardDTOCopyWith<_ListCardDTO> get copyWith => __$ListCardDTOCopyWithImpl<_ListCardDTO>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ListCardDTO&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.colorImageUrl, colorImageUrl) || other.colorImageUrl == colorImageUrl)&&(identical(other.grayImageUrl, grayImageUrl) || other.grayImageUrl == grayImageUrl)&&(identical(other.prefectureId, prefectureId) || other.prefectureId == prefectureId)&&(identical(other.prefectureName, prefectureName) || other.prefectureName == prefectureName)&&(identical(other.volumeId, volumeId) || other.volumeId == volumeId)&&(identical(other.volumeName, volumeName) || other.volumeName == volumeName)&&(identical(other.publicationDate, publicationDate) || other.publicationDate == publicationDate));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,colorImageUrl,grayImageUrl,prefectureId,prefectureName,volumeId,volumeName,publicationDate);

@override
String toString() {
  return 'ListCardDTO(id: $id, name: $name, colorImageUrl: $colorImageUrl, grayImageUrl: $grayImageUrl, prefectureId: $prefectureId, prefectureName: $prefectureName, volumeId: $volumeId, volumeName: $volumeName, publicationDate: $publicationDate)';
}


}

/// @nodoc
abstract mixin class _$ListCardDTOCopyWith<$Res> implements $ListCardDTOCopyWith<$Res> {
  factory _$ListCardDTOCopyWith(_ListCardDTO value, $Res Function(_ListCardDTO) _then) = __$ListCardDTOCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String colorImageUrl, String grayImageUrl, String prefectureId, String prefectureName, String volumeId, String volumeName, DateTime publicationDate
});




}
/// @nodoc
class __$ListCardDTOCopyWithImpl<$Res>
    implements _$ListCardDTOCopyWith<$Res> {
  __$ListCardDTOCopyWithImpl(this._self, this._then);

  final _ListCardDTO _self;
  final $Res Function(_ListCardDTO) _then;

/// Create a copy of ListCardDTO
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? colorImageUrl = null,Object? grayImageUrl = null,Object? prefectureId = null,Object? prefectureName = null,Object? volumeId = null,Object? volumeName = null,Object? publicationDate = null,}) {
  return _then(_ListCardDTO(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,colorImageUrl: null == colorImageUrl ? _self.colorImageUrl : colorImageUrl // ignore: cast_nullable_to_non_nullable
as String,grayImageUrl: null == grayImageUrl ? _self.grayImageUrl : grayImageUrl // ignore: cast_nullable_to_non_nullable
as String,prefectureId: null == prefectureId ? _self.prefectureId : prefectureId // ignore: cast_nullable_to_non_nullable
as String,prefectureName: null == prefectureName ? _self.prefectureName : prefectureName // ignore: cast_nullable_to_non_nullable
as String,volumeId: null == volumeId ? _self.volumeId : volumeId // ignore: cast_nullable_to_non_nullable
as String,volumeName: null == volumeName ? _self.volumeName : volumeName // ignore: cast_nullable_to_non_nullable
as String,publicationDate: null == publicationDate ? _self.publicationDate : publicationDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
