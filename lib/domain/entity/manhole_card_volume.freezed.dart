// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'manhole_card_volume.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ManholeCardVolume {

 String get id; String get name;
/// Create a copy of ManholeCardVolume
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ManholeCardVolumeCopyWith<ManholeCardVolume> get copyWith => _$ManholeCardVolumeCopyWithImpl<ManholeCardVolume>(this as ManholeCardVolume, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ManholeCardVolume&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'ManholeCardVolume(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $ManholeCardVolumeCopyWith<$Res>  {
  factory $ManholeCardVolumeCopyWith(ManholeCardVolume value, $Res Function(ManholeCardVolume) _then) = _$ManholeCardVolumeCopyWithImpl;
@useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class _$ManholeCardVolumeCopyWithImpl<$Res>
    implements $ManholeCardVolumeCopyWith<$Res> {
  _$ManholeCardVolumeCopyWithImpl(this._self, this._then);

  final ManholeCardVolume _self;
  final $Res Function(ManholeCardVolume) _then;

/// Create a copy of ManholeCardVolume
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc


class _ManholeCardVolume extends ManholeCardVolume {
  const _ManholeCardVolume({required this.id, required this.name}): super._();
  

@override final  String id;
@override final  String name;

/// Create a copy of ManholeCardVolume
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ManholeCardVolumeCopyWith<_ManholeCardVolume> get copyWith => __$ManholeCardVolumeCopyWithImpl<_ManholeCardVolume>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ManholeCardVolume&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'ManholeCardVolume(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$ManholeCardVolumeCopyWith<$Res> implements $ManholeCardVolumeCopyWith<$Res> {
  factory _$ManholeCardVolumeCopyWith(_ManholeCardVolume value, $Res Function(_ManholeCardVolume) _then) = __$ManholeCardVolumeCopyWithImpl;
@override @useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class __$ManholeCardVolumeCopyWithImpl<$Res>
    implements _$ManholeCardVolumeCopyWith<$Res> {
  __$ManholeCardVolumeCopyWithImpl(this._self, this._then);

  final _ManholeCardVolume _self;
  final $Res Function(_ManholeCardVolume) _then;

/// Create a copy of ManholeCardVolume
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_ManholeCardVolume(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
