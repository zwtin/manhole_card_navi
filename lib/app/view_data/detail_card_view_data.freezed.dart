// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'detail_card_view_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DetailCardViewData {

 String get id; String get imageUrl; String get name; String get prefecture; String get volume; String get publicationDate; List<DetailContactViewData> get contacts; String get distributionLinkText; String get distributionLinkUrl; String get distributionText; String get distributionOther;
/// Create a copy of DetailCardViewData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DetailCardViewDataCopyWith<DetailCardViewData> get copyWith => _$DetailCardViewDataCopyWithImpl<DetailCardViewData>(this as DetailCardViewData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DetailCardViewData&&(identical(other.id, id) || other.id == id)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.name, name) || other.name == name)&&(identical(other.prefecture, prefecture) || other.prefecture == prefecture)&&(identical(other.volume, volume) || other.volume == volume)&&(identical(other.publicationDate, publicationDate) || other.publicationDate == publicationDate)&&const DeepCollectionEquality().equals(other.contacts, contacts)&&(identical(other.distributionLinkText, distributionLinkText) || other.distributionLinkText == distributionLinkText)&&(identical(other.distributionLinkUrl, distributionLinkUrl) || other.distributionLinkUrl == distributionLinkUrl)&&(identical(other.distributionText, distributionText) || other.distributionText == distributionText)&&(identical(other.distributionOther, distributionOther) || other.distributionOther == distributionOther));
}


@override
int get hashCode => Object.hash(runtimeType,id,imageUrl,name,prefecture,volume,publicationDate,const DeepCollectionEquality().hash(contacts),distributionLinkText,distributionLinkUrl,distributionText,distributionOther);

@override
String toString() {
  return 'DetailCardViewData(id: $id, imageUrl: $imageUrl, name: $name, prefecture: $prefecture, volume: $volume, publicationDate: $publicationDate, contacts: $contacts, distributionLinkText: $distributionLinkText, distributionLinkUrl: $distributionLinkUrl, distributionText: $distributionText, distributionOther: $distributionOther)';
}


}

/// @nodoc
abstract mixin class $DetailCardViewDataCopyWith<$Res>  {
  factory $DetailCardViewDataCopyWith(DetailCardViewData value, $Res Function(DetailCardViewData) _then) = _$DetailCardViewDataCopyWithImpl;
@useResult
$Res call({
 String id, String imageUrl, String name, String prefecture, String volume, String publicationDate, List<DetailContactViewData> contacts, String distributionLinkText, String distributionLinkUrl, String distributionText, String distributionOther
});




}
/// @nodoc
class _$DetailCardViewDataCopyWithImpl<$Res>
    implements $DetailCardViewDataCopyWith<$Res> {
  _$DetailCardViewDataCopyWithImpl(this._self, this._then);

  final DetailCardViewData _self;
  final $Res Function(DetailCardViewData) _then;

/// Create a copy of DetailCardViewData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? imageUrl = null,Object? name = null,Object? prefecture = null,Object? volume = null,Object? publicationDate = null,Object? contacts = null,Object? distributionLinkText = null,Object? distributionLinkUrl = null,Object? distributionText = null,Object? distributionOther = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,prefecture: null == prefecture ? _self.prefecture : prefecture // ignore: cast_nullable_to_non_nullable
as String,volume: null == volume ? _self.volume : volume // ignore: cast_nullable_to_non_nullable
as String,publicationDate: null == publicationDate ? _self.publicationDate : publicationDate // ignore: cast_nullable_to_non_nullable
as String,contacts: null == contacts ? _self.contacts : contacts // ignore: cast_nullable_to_non_nullable
as List<DetailContactViewData>,distributionLinkText: null == distributionLinkText ? _self.distributionLinkText : distributionLinkText // ignore: cast_nullable_to_non_nullable
as String,distributionLinkUrl: null == distributionLinkUrl ? _self.distributionLinkUrl : distributionLinkUrl // ignore: cast_nullable_to_non_nullable
as String,distributionText: null == distributionText ? _self.distributionText : distributionText // ignore: cast_nullable_to_non_nullable
as String,distributionOther: null == distributionOther ? _self.distributionOther : distributionOther // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc


class _DetailCardViewData extends DetailCardViewData {
  const _DetailCardViewData({required this.id, required this.imageUrl, required this.name, required this.prefecture, required this.volume, required this.publicationDate, required final  List<DetailContactViewData> contacts, required this.distributionLinkText, required this.distributionLinkUrl, required this.distributionText, required this.distributionOther}): _contacts = contacts,super._();
  

@override final  String id;
@override final  String imageUrl;
@override final  String name;
@override final  String prefecture;
@override final  String volume;
@override final  String publicationDate;
 final  List<DetailContactViewData> _contacts;
@override List<DetailContactViewData> get contacts {
  if (_contacts is EqualUnmodifiableListView) return _contacts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_contacts);
}

@override final  String distributionLinkText;
@override final  String distributionLinkUrl;
@override final  String distributionText;
@override final  String distributionOther;

/// Create a copy of DetailCardViewData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DetailCardViewDataCopyWith<_DetailCardViewData> get copyWith => __$DetailCardViewDataCopyWithImpl<_DetailCardViewData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DetailCardViewData&&(identical(other.id, id) || other.id == id)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.name, name) || other.name == name)&&(identical(other.prefecture, prefecture) || other.prefecture == prefecture)&&(identical(other.volume, volume) || other.volume == volume)&&(identical(other.publicationDate, publicationDate) || other.publicationDate == publicationDate)&&const DeepCollectionEquality().equals(other._contacts, _contacts)&&(identical(other.distributionLinkText, distributionLinkText) || other.distributionLinkText == distributionLinkText)&&(identical(other.distributionLinkUrl, distributionLinkUrl) || other.distributionLinkUrl == distributionLinkUrl)&&(identical(other.distributionText, distributionText) || other.distributionText == distributionText)&&(identical(other.distributionOther, distributionOther) || other.distributionOther == distributionOther));
}


@override
int get hashCode => Object.hash(runtimeType,id,imageUrl,name,prefecture,volume,publicationDate,const DeepCollectionEquality().hash(_contacts),distributionLinkText,distributionLinkUrl,distributionText,distributionOther);

@override
String toString() {
  return 'DetailCardViewData(id: $id, imageUrl: $imageUrl, name: $name, prefecture: $prefecture, volume: $volume, publicationDate: $publicationDate, contacts: $contacts, distributionLinkText: $distributionLinkText, distributionLinkUrl: $distributionLinkUrl, distributionText: $distributionText, distributionOther: $distributionOther)';
}


}

/// @nodoc
abstract mixin class _$DetailCardViewDataCopyWith<$Res> implements $DetailCardViewDataCopyWith<$Res> {
  factory _$DetailCardViewDataCopyWith(_DetailCardViewData value, $Res Function(_DetailCardViewData) _then) = __$DetailCardViewDataCopyWithImpl;
@override @useResult
$Res call({
 String id, String imageUrl, String name, String prefecture, String volume, String publicationDate, List<DetailContactViewData> contacts, String distributionLinkText, String distributionLinkUrl, String distributionText, String distributionOther
});




}
/// @nodoc
class __$DetailCardViewDataCopyWithImpl<$Res>
    implements _$DetailCardViewDataCopyWith<$Res> {
  __$DetailCardViewDataCopyWithImpl(this._self, this._then);

  final _DetailCardViewData _self;
  final $Res Function(_DetailCardViewData) _then;

/// Create a copy of DetailCardViewData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? imageUrl = null,Object? name = null,Object? prefecture = null,Object? volume = null,Object? publicationDate = null,Object? contacts = null,Object? distributionLinkText = null,Object? distributionLinkUrl = null,Object? distributionText = null,Object? distributionOther = null,}) {
  return _then(_DetailCardViewData(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,prefecture: null == prefecture ? _self.prefecture : prefecture // ignore: cast_nullable_to_non_nullable
as String,volume: null == volume ? _self.volume : volume // ignore: cast_nullable_to_non_nullable
as String,publicationDate: null == publicationDate ? _self.publicationDate : publicationDate // ignore: cast_nullable_to_non_nullable
as String,contacts: null == contacts ? _self._contacts : contacts // ignore: cast_nullable_to_non_nullable
as List<DetailContactViewData>,distributionLinkText: null == distributionLinkText ? _self.distributionLinkText : distributionLinkText // ignore: cast_nullable_to_non_nullable
as String,distributionLinkUrl: null == distributionLinkUrl ? _self.distributionLinkUrl : distributionLinkUrl // ignore: cast_nullable_to_non_nullable
as String,distributionText: null == distributionText ? _self.distributionText : distributionText // ignore: cast_nullable_to_non_nullable
as String,distributionOther: null == distributionOther ? _self.distributionOther : distributionOther // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
