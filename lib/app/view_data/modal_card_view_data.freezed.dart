// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'modal_card_view_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ModalCardViewData {

 String get id; String get name; List<ModalContactViewData> get contacts; String get distributionLinkText; String get distributionLinkUrl; String get distributionText; String get distributionOther; double get latitude; double get longitude;
/// Create a copy of ModalCardViewData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModalCardViewDataCopyWith<ModalCardViewData> get copyWith => _$ModalCardViewDataCopyWithImpl<ModalCardViewData>(this as ModalCardViewData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModalCardViewData&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.contacts, contacts)&&(identical(other.distributionLinkText, distributionLinkText) || other.distributionLinkText == distributionLinkText)&&(identical(other.distributionLinkUrl, distributionLinkUrl) || other.distributionLinkUrl == distributionLinkUrl)&&(identical(other.distributionText, distributionText) || other.distributionText == distributionText)&&(identical(other.distributionOther, distributionOther) || other.distributionOther == distributionOther)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(contacts),distributionLinkText,distributionLinkUrl,distributionText,distributionOther,latitude,longitude);

@override
String toString() {
  return 'ModalCardViewData(id: $id, name: $name, contacts: $contacts, distributionLinkText: $distributionLinkText, distributionLinkUrl: $distributionLinkUrl, distributionText: $distributionText, distributionOther: $distributionOther, latitude: $latitude, longitude: $longitude)';
}


}

/// @nodoc
abstract mixin class $ModalCardViewDataCopyWith<$Res>  {
  factory $ModalCardViewDataCopyWith(ModalCardViewData value, $Res Function(ModalCardViewData) _then) = _$ModalCardViewDataCopyWithImpl;
@useResult
$Res call({
 String id, String name, List<ModalContactViewData> contacts, String distributionLinkText, String distributionLinkUrl, String distributionText, String distributionOther, double latitude, double longitude
});




}
/// @nodoc
class _$ModalCardViewDataCopyWithImpl<$Res>
    implements $ModalCardViewDataCopyWith<$Res> {
  _$ModalCardViewDataCopyWithImpl(this._self, this._then);

  final ModalCardViewData _self;
  final $Res Function(ModalCardViewData) _then;

/// Create a copy of ModalCardViewData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? contacts = null,Object? distributionLinkText = null,Object? distributionLinkUrl = null,Object? distributionText = null,Object? distributionOther = null,Object? latitude = null,Object? longitude = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,contacts: null == contacts ? _self.contacts : contacts // ignore: cast_nullable_to_non_nullable
as List<ModalContactViewData>,distributionLinkText: null == distributionLinkText ? _self.distributionLinkText : distributionLinkText // ignore: cast_nullable_to_non_nullable
as String,distributionLinkUrl: null == distributionLinkUrl ? _self.distributionLinkUrl : distributionLinkUrl // ignore: cast_nullable_to_non_nullable
as String,distributionText: null == distributionText ? _self.distributionText : distributionText // ignore: cast_nullable_to_non_nullable
as String,distributionOther: null == distributionOther ? _self.distributionOther : distributionOther // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// @nodoc


class _ModalCardViewData extends ModalCardViewData {
  const _ModalCardViewData({required this.id, required this.name, required final  List<ModalContactViewData> contacts, required this.distributionLinkText, required this.distributionLinkUrl, required this.distributionText, required this.distributionOther, required this.latitude, required this.longitude}): _contacts = contacts,super._();
  

@override final  String id;
@override final  String name;
 final  List<ModalContactViewData> _contacts;
@override List<ModalContactViewData> get contacts {
  if (_contacts is EqualUnmodifiableListView) return _contacts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_contacts);
}

@override final  String distributionLinkText;
@override final  String distributionLinkUrl;
@override final  String distributionText;
@override final  String distributionOther;
@override final  double latitude;
@override final  double longitude;

/// Create a copy of ModalCardViewData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ModalCardViewDataCopyWith<_ModalCardViewData> get copyWith => __$ModalCardViewDataCopyWithImpl<_ModalCardViewData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ModalCardViewData&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._contacts, _contacts)&&(identical(other.distributionLinkText, distributionLinkText) || other.distributionLinkText == distributionLinkText)&&(identical(other.distributionLinkUrl, distributionLinkUrl) || other.distributionLinkUrl == distributionLinkUrl)&&(identical(other.distributionText, distributionText) || other.distributionText == distributionText)&&(identical(other.distributionOther, distributionOther) || other.distributionOther == distributionOther)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(_contacts),distributionLinkText,distributionLinkUrl,distributionText,distributionOther,latitude,longitude);

@override
String toString() {
  return 'ModalCardViewData(id: $id, name: $name, contacts: $contacts, distributionLinkText: $distributionLinkText, distributionLinkUrl: $distributionLinkUrl, distributionText: $distributionText, distributionOther: $distributionOther, latitude: $latitude, longitude: $longitude)';
}


}

/// @nodoc
abstract mixin class _$ModalCardViewDataCopyWith<$Res> implements $ModalCardViewDataCopyWith<$Res> {
  factory _$ModalCardViewDataCopyWith(_ModalCardViewData value, $Res Function(_ModalCardViewData) _then) = __$ModalCardViewDataCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, List<ModalContactViewData> contacts, String distributionLinkText, String distributionLinkUrl, String distributionText, String distributionOther, double latitude, double longitude
});




}
/// @nodoc
class __$ModalCardViewDataCopyWithImpl<$Res>
    implements _$ModalCardViewDataCopyWith<$Res> {
  __$ModalCardViewDataCopyWithImpl(this._self, this._then);

  final _ModalCardViewData _self;
  final $Res Function(_ModalCardViewData) _then;

/// Create a copy of ModalCardViewData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? contacts = null,Object? distributionLinkText = null,Object? distributionLinkUrl = null,Object? distributionText = null,Object? distributionOther = null,Object? latitude = null,Object? longitude = null,}) {
  return _then(_ModalCardViewData(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,contacts: null == contacts ? _self._contacts : contacts // ignore: cast_nullable_to_non_nullable
as List<ModalContactViewData>,distributionLinkText: null == distributionLinkText ? _self.distributionLinkText : distributionLinkText // ignore: cast_nullable_to_non_nullable
as String,distributionLinkUrl: null == distributionLinkUrl ? _self.distributionLinkUrl : distributionLinkUrl // ignore: cast_nullable_to_non_nullable
as String,distributionText: null == distributionText ? _self.distributionText : distributionText // ignore: cast_nullable_to_non_nullable
as String,distributionOther: null == distributionOther ? _self.distributionOther : distributionOther // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
