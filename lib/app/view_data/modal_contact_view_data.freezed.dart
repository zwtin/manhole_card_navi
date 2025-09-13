// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'modal_contact_view_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ModalContactViewData {

 String get id; String get name; String get nameUrl;
/// Create a copy of ModalContactViewData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModalContactViewDataCopyWith<ModalContactViewData> get copyWith => _$ModalContactViewDataCopyWithImpl<ModalContactViewData>(this as ModalContactViewData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModalContactViewData&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameUrl, nameUrl) || other.nameUrl == nameUrl));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,nameUrl);

@override
String toString() {
  return 'ModalContactViewData(id: $id, name: $name, nameUrl: $nameUrl)';
}


}

/// @nodoc
abstract mixin class $ModalContactViewDataCopyWith<$Res>  {
  factory $ModalContactViewDataCopyWith(ModalContactViewData value, $Res Function(ModalContactViewData) _then) = _$ModalContactViewDataCopyWithImpl;
@useResult
$Res call({
 String id, String name, String nameUrl
});




}
/// @nodoc
class _$ModalContactViewDataCopyWithImpl<$Res>
    implements $ModalContactViewDataCopyWith<$Res> {
  _$ModalContactViewDataCopyWithImpl(this._self, this._then);

  final ModalContactViewData _self;
  final $Res Function(ModalContactViewData) _then;

/// Create a copy of ModalContactViewData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? nameUrl = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameUrl: null == nameUrl ? _self.nameUrl : nameUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc


class _ModalContactViewData extends ModalContactViewData {
  const _ModalContactViewData({required this.id, required this.name, required this.nameUrl}): super._();
  

@override final  String id;
@override final  String name;
@override final  String nameUrl;

/// Create a copy of ModalContactViewData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ModalContactViewDataCopyWith<_ModalContactViewData> get copyWith => __$ModalContactViewDataCopyWithImpl<_ModalContactViewData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ModalContactViewData&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameUrl, nameUrl) || other.nameUrl == nameUrl));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,nameUrl);

@override
String toString() {
  return 'ModalContactViewData(id: $id, name: $name, nameUrl: $nameUrl)';
}


}

/// @nodoc
abstract mixin class _$ModalContactViewDataCopyWith<$Res> implements $ModalContactViewDataCopyWith<$Res> {
  factory _$ModalContactViewDataCopyWith(_ModalContactViewData value, $Res Function(_ModalContactViewData) _then) = __$ModalContactViewDataCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String nameUrl
});




}
/// @nodoc
class __$ModalContactViewDataCopyWithImpl<$Res>
    implements _$ModalContactViewDataCopyWith<$Res> {
  __$ModalContactViewDataCopyWithImpl(this._self, this._then);

  final _ModalContactViewData _self;
  final $Res Function(_ModalContactViewData) _then;

/// Create a copy of ModalContactViewData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? nameUrl = null,}) {
  return _then(_ModalContactViewData(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameUrl: null == nameUrl ? _self.nameUrl : nameUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
