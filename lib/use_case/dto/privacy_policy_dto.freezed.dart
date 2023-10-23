// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'privacy_policy_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$PrivacyPolicyDTO {
  String get value => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PrivacyPolicyDTOCopyWith<PrivacyPolicyDTO> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrivacyPolicyDTOCopyWith<$Res> {
  factory $PrivacyPolicyDTOCopyWith(
          PrivacyPolicyDTO value, $Res Function(PrivacyPolicyDTO) then) =
      _$PrivacyPolicyDTOCopyWithImpl<$Res, PrivacyPolicyDTO>;
  @useResult
  $Res call({String value});
}

/// @nodoc
class _$PrivacyPolicyDTOCopyWithImpl<$Res, $Val extends PrivacyPolicyDTO>
    implements $PrivacyPolicyDTOCopyWith<$Res> {
  _$PrivacyPolicyDTOCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
  }) {
    return _then(_value.copyWith(
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_PrivacyPolicyDTOCopyWith<$Res>
    implements $PrivacyPolicyDTOCopyWith<$Res> {
  factory _$$_PrivacyPolicyDTOCopyWith(
          _$_PrivacyPolicyDTO value, $Res Function(_$_PrivacyPolicyDTO) then) =
      __$$_PrivacyPolicyDTOCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String value});
}

/// @nodoc
class __$$_PrivacyPolicyDTOCopyWithImpl<$Res>
    extends _$PrivacyPolicyDTOCopyWithImpl<$Res, _$_PrivacyPolicyDTO>
    implements _$$_PrivacyPolicyDTOCopyWith<$Res> {
  __$$_PrivacyPolicyDTOCopyWithImpl(
      _$_PrivacyPolicyDTO _value, $Res Function(_$_PrivacyPolicyDTO) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
  }) {
    return _then(_$_PrivacyPolicyDTO(
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_PrivacyPolicyDTO extends _PrivacyPolicyDTO {
  const _$_PrivacyPolicyDTO({required this.value}) : super._();

  @override
  final String value;

  @override
  String toString() {
    return 'PrivacyPolicyDTO(value: $value)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PrivacyPolicyDTO &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PrivacyPolicyDTOCopyWith<_$_PrivacyPolicyDTO> get copyWith =>
      __$$_PrivacyPolicyDTOCopyWithImpl<_$_PrivacyPolicyDTO>(this, _$identity);
}

abstract class _PrivacyPolicyDTO extends PrivacyPolicyDTO {
  const factory _PrivacyPolicyDTO({required final String value}) =
      _$_PrivacyPolicyDTO;
  const _PrivacyPolicyDTO._() : super._();

  @override
  String get value;
  @override
  @JsonKey(ignore: true)
  _$$_PrivacyPolicyDTOCopyWith<_$_PrivacyPolicyDTO> get copyWith =>
      throw _privateConstructorUsedError;
}
