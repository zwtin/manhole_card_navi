// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'terms_of_service_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TermsOfServiceDTO {

 String get value;
/// Create a copy of TermsOfServiceDTO
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TermsOfServiceDTOCopyWith<TermsOfServiceDTO> get copyWith => _$TermsOfServiceDTOCopyWithImpl<TermsOfServiceDTO>(this as TermsOfServiceDTO, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TermsOfServiceDTO&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,value);

@override
String toString() {
  return 'TermsOfServiceDTO(value: $value)';
}


}

/// @nodoc
abstract mixin class $TermsOfServiceDTOCopyWith<$Res>  {
  factory $TermsOfServiceDTOCopyWith(TermsOfServiceDTO value, $Res Function(TermsOfServiceDTO) _then) = _$TermsOfServiceDTOCopyWithImpl;
@useResult
$Res call({
 String value
});




}
/// @nodoc
class _$TermsOfServiceDTOCopyWithImpl<$Res>
    implements $TermsOfServiceDTOCopyWith<$Res> {
  _$TermsOfServiceDTOCopyWithImpl(this._self, this._then);

  final TermsOfServiceDTO _self;
  final $Res Function(TermsOfServiceDTO) _then;

/// Create a copy of TermsOfServiceDTO
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? value = null,}) {
  return _then(_self.copyWith(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc


class _TermsOfServiceDTO extends TermsOfServiceDTO {
  const _TermsOfServiceDTO({required this.value}): super._();
  

@override final  String value;

/// Create a copy of TermsOfServiceDTO
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TermsOfServiceDTOCopyWith<_TermsOfServiceDTO> get copyWith => __$TermsOfServiceDTOCopyWithImpl<_TermsOfServiceDTO>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TermsOfServiceDTO&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,value);

@override
String toString() {
  return 'TermsOfServiceDTO(value: $value)';
}


}

/// @nodoc
abstract mixin class _$TermsOfServiceDTOCopyWith<$Res> implements $TermsOfServiceDTOCopyWith<$Res> {
  factory _$TermsOfServiceDTOCopyWith(_TermsOfServiceDTO value, $Res Function(_TermsOfServiceDTO) _then) = __$TermsOfServiceDTOCopyWithImpl;
@override @useResult
$Res call({
 String value
});




}
/// @nodoc
class __$TermsOfServiceDTOCopyWithImpl<$Res>
    implements _$TermsOfServiceDTOCopyWith<$Res> {
  __$TermsOfServiceDTOCopyWithImpl(this._self, this._then);

  final _TermsOfServiceDTO _self;
  final $Res Function(_TermsOfServiceDTO) _then;

/// Create a copy of TermsOfServiceDTO
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(_TermsOfServiceDTO(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
