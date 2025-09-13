// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_info_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppInfoDTO {

 String get name; String get version;
/// Create a copy of AppInfoDTO
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppInfoDTOCopyWith<AppInfoDTO> get copyWith => _$AppInfoDTOCopyWithImpl<AppInfoDTO>(this as AppInfoDTO, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppInfoDTO&&(identical(other.name, name) || other.name == name)&&(identical(other.version, version) || other.version == version));
}


@override
int get hashCode => Object.hash(runtimeType,name,version);

@override
String toString() {
  return 'AppInfoDTO(name: $name, version: $version)';
}


}

/// @nodoc
abstract mixin class $AppInfoDTOCopyWith<$Res>  {
  factory $AppInfoDTOCopyWith(AppInfoDTO value, $Res Function(AppInfoDTO) _then) = _$AppInfoDTOCopyWithImpl;
@useResult
$Res call({
 String name, String version
});




}
/// @nodoc
class _$AppInfoDTOCopyWithImpl<$Res>
    implements $AppInfoDTOCopyWith<$Res> {
  _$AppInfoDTOCopyWithImpl(this._self, this._then);

  final AppInfoDTO _self;
  final $Res Function(AppInfoDTO) _then;

/// Create a copy of AppInfoDTO
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? version = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc


class _AppInfoDTO extends AppInfoDTO {
  const _AppInfoDTO({required this.name, required this.version}): super._();
  

@override final  String name;
@override final  String version;

/// Create a copy of AppInfoDTO
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppInfoDTOCopyWith<_AppInfoDTO> get copyWith => __$AppInfoDTOCopyWithImpl<_AppInfoDTO>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppInfoDTO&&(identical(other.name, name) || other.name == name)&&(identical(other.version, version) || other.version == version));
}


@override
int get hashCode => Object.hash(runtimeType,name,version);

@override
String toString() {
  return 'AppInfoDTO(name: $name, version: $version)';
}


}

/// @nodoc
abstract mixin class _$AppInfoDTOCopyWith<$Res> implements $AppInfoDTOCopyWith<$Res> {
  factory _$AppInfoDTOCopyWith(_AppInfoDTO value, $Res Function(_AppInfoDTO) _then) = __$AppInfoDTOCopyWithImpl;
@override @useResult
$Res call({
 String name, String version
});




}
/// @nodoc
class __$AppInfoDTOCopyWithImpl<$Res>
    implements _$AppInfoDTOCopyWith<$Res> {
  __$AppInfoDTOCopyWithImpl(this._self, this._then);

  final _AppInfoDTO _self;
  final $Res Function(_AppInfoDTO) _then;

/// Create a copy of AppInfoDTO
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? version = null,}) {
  return _then(_AppInfoDTO(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
