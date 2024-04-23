// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'terms_of_service_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TermsOfServiceDTO {
  String get value => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TermsOfServiceDTOCopyWith<TermsOfServiceDTO> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TermsOfServiceDTOCopyWith<$Res> {
  factory $TermsOfServiceDTOCopyWith(
          TermsOfServiceDTO value, $Res Function(TermsOfServiceDTO) then) =
      _$TermsOfServiceDTOCopyWithImpl<$Res, TermsOfServiceDTO>;
  @useResult
  $Res call({String value});
}

/// @nodoc
class _$TermsOfServiceDTOCopyWithImpl<$Res, $Val extends TermsOfServiceDTO>
    implements $TermsOfServiceDTOCopyWith<$Res> {
  _$TermsOfServiceDTOCopyWithImpl(this._value, this._then);

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
abstract class _$$TermsOfServiceDTOImplCopyWith<$Res>
    implements $TermsOfServiceDTOCopyWith<$Res> {
  factory _$$TermsOfServiceDTOImplCopyWith(_$TermsOfServiceDTOImpl value,
          $Res Function(_$TermsOfServiceDTOImpl) then) =
      __$$TermsOfServiceDTOImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String value});
}

/// @nodoc
class __$$TermsOfServiceDTOImplCopyWithImpl<$Res>
    extends _$TermsOfServiceDTOCopyWithImpl<$Res, _$TermsOfServiceDTOImpl>
    implements _$$TermsOfServiceDTOImplCopyWith<$Res> {
  __$$TermsOfServiceDTOImplCopyWithImpl(_$TermsOfServiceDTOImpl _value,
      $Res Function(_$TermsOfServiceDTOImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
  }) {
    return _then(_$TermsOfServiceDTOImpl(
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$TermsOfServiceDTOImpl extends _TermsOfServiceDTO {
  const _$TermsOfServiceDTOImpl({required this.value}) : super._();

  @override
  final String value;

  @override
  String toString() {
    return 'TermsOfServiceDTO(value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TermsOfServiceDTOImpl &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TermsOfServiceDTOImplCopyWith<_$TermsOfServiceDTOImpl> get copyWith =>
      __$$TermsOfServiceDTOImplCopyWithImpl<_$TermsOfServiceDTOImpl>(
          this, _$identity);
}

abstract class _TermsOfServiceDTO extends TermsOfServiceDTO {
  const factory _TermsOfServiceDTO({required final String value}) =
      _$TermsOfServiceDTOImpl;
  const _TermsOfServiceDTO._() : super._();

  @override
  String get value;
  @override
  @JsonKey(ignore: true)
  _$$TermsOfServiceDTOImplCopyWith<_$TermsOfServiceDTOImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
