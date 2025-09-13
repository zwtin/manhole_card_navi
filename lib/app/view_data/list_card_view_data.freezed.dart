// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'list_card_view_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ListCardViewData {

 String get id; String get imageUrl; String get name; String get volume; String get publicationDate;
/// Create a copy of ListCardViewData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ListCardViewDataCopyWith<ListCardViewData> get copyWith => _$ListCardViewDataCopyWithImpl<ListCardViewData>(this as ListCardViewData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ListCardViewData&&(identical(other.id, id) || other.id == id)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.name, name) || other.name == name)&&(identical(other.volume, volume) || other.volume == volume)&&(identical(other.publicationDate, publicationDate) || other.publicationDate == publicationDate));
}


@override
int get hashCode => Object.hash(runtimeType,id,imageUrl,name,volume,publicationDate);

@override
String toString() {
  return 'ListCardViewData(id: $id, imageUrl: $imageUrl, name: $name, volume: $volume, publicationDate: $publicationDate)';
}


}

/// @nodoc
abstract mixin class $ListCardViewDataCopyWith<$Res>  {
  factory $ListCardViewDataCopyWith(ListCardViewData value, $Res Function(ListCardViewData) _then) = _$ListCardViewDataCopyWithImpl;
@useResult
$Res call({
 String id, String imageUrl, String name, String volume, String publicationDate
});




}
/// @nodoc
class _$ListCardViewDataCopyWithImpl<$Res>
    implements $ListCardViewDataCopyWith<$Res> {
  _$ListCardViewDataCopyWithImpl(this._self, this._then);

  final ListCardViewData _self;
  final $Res Function(ListCardViewData) _then;

/// Create a copy of ListCardViewData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? imageUrl = null,Object? name = null,Object? volume = null,Object? publicationDate = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,volume: null == volume ? _self.volume : volume // ignore: cast_nullable_to_non_nullable
as String,publicationDate: null == publicationDate ? _self.publicationDate : publicationDate // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc


class _ListCardViewData extends ListCardViewData {
  const _ListCardViewData({required this.id, required this.imageUrl, required this.name, required this.volume, required this.publicationDate}): super._();
  

@override final  String id;
@override final  String imageUrl;
@override final  String name;
@override final  String volume;
@override final  String publicationDate;

/// Create a copy of ListCardViewData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ListCardViewDataCopyWith<_ListCardViewData> get copyWith => __$ListCardViewDataCopyWithImpl<_ListCardViewData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ListCardViewData&&(identical(other.id, id) || other.id == id)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.name, name) || other.name == name)&&(identical(other.volume, volume) || other.volume == volume)&&(identical(other.publicationDate, publicationDate) || other.publicationDate == publicationDate));
}


@override
int get hashCode => Object.hash(runtimeType,id,imageUrl,name,volume,publicationDate);

@override
String toString() {
  return 'ListCardViewData(id: $id, imageUrl: $imageUrl, name: $name, volume: $volume, publicationDate: $publicationDate)';
}


}

/// @nodoc
abstract mixin class _$ListCardViewDataCopyWith<$Res> implements $ListCardViewDataCopyWith<$Res> {
  factory _$ListCardViewDataCopyWith(_ListCardViewData value, $Res Function(_ListCardViewData) _then) = __$ListCardViewDataCopyWithImpl;
@override @useResult
$Res call({
 String id, String imageUrl, String name, String volume, String publicationDate
});




}
/// @nodoc
class __$ListCardViewDataCopyWithImpl<$Res>
    implements _$ListCardViewDataCopyWith<$Res> {
  __$ListCardViewDataCopyWithImpl(this._self, this._then);

  final _ListCardViewData _self;
  final $Res Function(_ListCardViewData) _then;

/// Create a copy of ListCardViewData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? imageUrl = null,Object? name = null,Object? volume = null,Object? publicationDate = null,}) {
  return _then(_ListCardViewData(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,volume: null == volume ? _self.volume : volume // ignore: cast_nullable_to_non_nullable
as String,publicationDate: null == publicationDate ? _self.publicationDate : publicationDate // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
