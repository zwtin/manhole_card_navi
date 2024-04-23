// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'need_terms_of_service_agree_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$NeedTermsOfServiceAgreeDTO {
  bool get value => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $NeedTermsOfServiceAgreeDTOCopyWith<NeedTermsOfServiceAgreeDTO>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NeedTermsOfServiceAgreeDTOCopyWith<$Res> {
  factory $NeedTermsOfServiceAgreeDTOCopyWith(NeedTermsOfServiceAgreeDTO value,
          $Res Function(NeedTermsOfServiceAgreeDTO) then) =
      _$NeedTermsOfServiceAgreeDTOCopyWithImpl<$Res,
          NeedTermsOfServiceAgreeDTO>;
  @useResult
  $Res call({bool value});
}

/// @nodoc
class _$NeedTermsOfServiceAgreeDTOCopyWithImpl<$Res,
        $Val extends NeedTermsOfServiceAgreeDTO>
    implements $NeedTermsOfServiceAgreeDTOCopyWith<$Res> {
  _$NeedTermsOfServiceAgreeDTOCopyWithImpl(this._value, this._then);

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
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NeedTermsOfServiceAgreeDTOImplCopyWith<$Res>
    implements $NeedTermsOfServiceAgreeDTOCopyWith<$Res> {
  factory _$$NeedTermsOfServiceAgreeDTOImplCopyWith(
          _$NeedTermsOfServiceAgreeDTOImpl value,
          $Res Function(_$NeedTermsOfServiceAgreeDTOImpl) then) =
      __$$NeedTermsOfServiceAgreeDTOImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool value});
}

/// @nodoc
class __$$NeedTermsOfServiceAgreeDTOImplCopyWithImpl<$Res>
    extends _$NeedTermsOfServiceAgreeDTOCopyWithImpl<$Res,
        _$NeedTermsOfServiceAgreeDTOImpl>
    implements _$$NeedTermsOfServiceAgreeDTOImplCopyWith<$Res> {
  __$$NeedTermsOfServiceAgreeDTOImplCopyWithImpl(
      _$NeedTermsOfServiceAgreeDTOImpl _value,
      $Res Function(_$NeedTermsOfServiceAgreeDTOImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
  }) {
    return _then(_$NeedTermsOfServiceAgreeDTOImpl(
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$NeedTermsOfServiceAgreeDTOImpl extends _NeedTermsOfServiceAgreeDTO {
  const _$NeedTermsOfServiceAgreeDTOImpl({required this.value}) : super._();

  @override
  final bool value;

  @override
  String toString() {
    return 'NeedTermsOfServiceAgreeDTO(value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NeedTermsOfServiceAgreeDTOImpl &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NeedTermsOfServiceAgreeDTOImplCopyWith<_$NeedTermsOfServiceAgreeDTOImpl>
      get copyWith => __$$NeedTermsOfServiceAgreeDTOImplCopyWithImpl<
          _$NeedTermsOfServiceAgreeDTOImpl>(this, _$identity);
}

abstract class _NeedTermsOfServiceAgreeDTO extends NeedTermsOfServiceAgreeDTO {
  const factory _NeedTermsOfServiceAgreeDTO({required final bool value}) =
      _$NeedTermsOfServiceAgreeDTOImpl;
  const _NeedTermsOfServiceAgreeDTO._() : super._();

  @override
  bool get value;
  @override
  @JsonKey(ignore: true)
  _$$NeedTermsOfServiceAgreeDTOImplCopyWith<_$NeedTermsOfServiceAgreeDTOImpl>
      get copyWith => throw _privateConstructorUsedError;
}
