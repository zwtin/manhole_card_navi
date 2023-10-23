// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'privacy_policy.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$PrivacyPolicy {
  String get value => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PrivacyPolicyCopyWith<PrivacyPolicy> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrivacyPolicyCopyWith<$Res> {
  factory $PrivacyPolicyCopyWith(
          PrivacyPolicy value, $Res Function(PrivacyPolicy) then) =
      _$PrivacyPolicyCopyWithImpl<$Res, PrivacyPolicy>;
  @useResult
  $Res call({String value});
}

/// @nodoc
class _$PrivacyPolicyCopyWithImpl<$Res, $Val extends PrivacyPolicy>
    implements $PrivacyPolicyCopyWith<$Res> {
  _$PrivacyPolicyCopyWithImpl(this._value, this._then);

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
abstract class _$$_PrivacyPolicyCopyWith<$Res>
    implements $PrivacyPolicyCopyWith<$Res> {
  factory _$$_PrivacyPolicyCopyWith(
          _$_PrivacyPolicy value, $Res Function(_$_PrivacyPolicy) then) =
      __$$_PrivacyPolicyCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String value});
}

/// @nodoc
class __$$_PrivacyPolicyCopyWithImpl<$Res>
    extends _$PrivacyPolicyCopyWithImpl<$Res, _$_PrivacyPolicy>
    implements _$$_PrivacyPolicyCopyWith<$Res> {
  __$$_PrivacyPolicyCopyWithImpl(
      _$_PrivacyPolicy _value, $Res Function(_$_PrivacyPolicy) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
  }) {
    return _then(_$_PrivacyPolicy(
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_PrivacyPolicy extends _PrivacyPolicy {
  const _$_PrivacyPolicy({required this.value}) : super._();

  @override
  final String value;

  @override
  String toString() {
    return 'PrivacyPolicy(value: $value)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PrivacyPolicy &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PrivacyPolicyCopyWith<_$_PrivacyPolicy> get copyWith =>
      __$$_PrivacyPolicyCopyWithImpl<_$_PrivacyPolicy>(this, _$identity);
}

abstract class _PrivacyPolicy extends PrivacyPolicy {
  const factory _PrivacyPolicy({required final String value}) =
      _$_PrivacyPolicy;
  const _PrivacyPolicy._() : super._();

  @override
  String get value;
  @override
  @JsonKey(ignore: true)
  _$$_PrivacyPolicyCopyWith<_$_PrivacyPolicy> get copyWith =>
      throw _privateConstructorUsedError;
}
