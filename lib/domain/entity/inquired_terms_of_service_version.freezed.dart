// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inquired_terms_of_service_version.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$InquiredTermsOfServiceVersion {
  String get value => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $InquiredTermsOfServiceVersionCopyWith<InquiredTermsOfServiceVersion>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InquiredTermsOfServiceVersionCopyWith<$Res> {
  factory $InquiredTermsOfServiceVersionCopyWith(
          InquiredTermsOfServiceVersion value,
          $Res Function(InquiredTermsOfServiceVersion) then) =
      _$InquiredTermsOfServiceVersionCopyWithImpl<$Res,
          InquiredTermsOfServiceVersion>;
  @useResult
  $Res call({String value});
}

/// @nodoc
class _$InquiredTermsOfServiceVersionCopyWithImpl<$Res,
        $Val extends InquiredTermsOfServiceVersion>
    implements $InquiredTermsOfServiceVersionCopyWith<$Res> {
  _$InquiredTermsOfServiceVersionCopyWithImpl(this._value, this._then);

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
abstract class _$$InquiredTermsOfServiceVersionImplCopyWith<$Res>
    implements $InquiredTermsOfServiceVersionCopyWith<$Res> {
  factory _$$InquiredTermsOfServiceVersionImplCopyWith(
          _$InquiredTermsOfServiceVersionImpl value,
          $Res Function(_$InquiredTermsOfServiceVersionImpl) then) =
      __$$InquiredTermsOfServiceVersionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String value});
}

/// @nodoc
class __$$InquiredTermsOfServiceVersionImplCopyWithImpl<$Res>
    extends _$InquiredTermsOfServiceVersionCopyWithImpl<$Res,
        _$InquiredTermsOfServiceVersionImpl>
    implements _$$InquiredTermsOfServiceVersionImplCopyWith<$Res> {
  __$$InquiredTermsOfServiceVersionImplCopyWithImpl(
      _$InquiredTermsOfServiceVersionImpl _value,
      $Res Function(_$InquiredTermsOfServiceVersionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
  }) {
    return _then(_$InquiredTermsOfServiceVersionImpl(
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$InquiredTermsOfServiceVersionImpl
    extends _InquiredTermsOfServiceVersion {
  const _$InquiredTermsOfServiceVersionImpl({required this.value}) : super._();

  @override
  final String value;

  @override
  String toString() {
    return 'InquiredTermsOfServiceVersion(value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InquiredTermsOfServiceVersionImpl &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InquiredTermsOfServiceVersionImplCopyWith<
          _$InquiredTermsOfServiceVersionImpl>
      get copyWith => __$$InquiredTermsOfServiceVersionImplCopyWithImpl<
          _$InquiredTermsOfServiceVersionImpl>(this, _$identity);
}

abstract class _InquiredTermsOfServiceVersion
    extends InquiredTermsOfServiceVersion {
  const factory _InquiredTermsOfServiceVersion({required final String value}) =
      _$InquiredTermsOfServiceVersionImpl;
  const _InquiredTermsOfServiceVersion._() : super._();

  @override
  String get value;
  @override
  @JsonKey(ignore: true)
  _$$InquiredTermsOfServiceVersionImplCopyWith<
          _$InquiredTermsOfServiceVersionImpl>
      get copyWith => throw _privateConstructorUsedError;
}
