// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inquired_app_version.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$InquiredAppVersion {
  String get value => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $InquiredAppVersionCopyWith<InquiredAppVersion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InquiredAppVersionCopyWith<$Res> {
  factory $InquiredAppVersionCopyWith(
          InquiredAppVersion value, $Res Function(InquiredAppVersion) then) =
      _$InquiredAppVersionCopyWithImpl<$Res, InquiredAppVersion>;
  @useResult
  $Res call({String value});
}

/// @nodoc
class _$InquiredAppVersionCopyWithImpl<$Res, $Val extends InquiredAppVersion>
    implements $InquiredAppVersionCopyWith<$Res> {
  _$InquiredAppVersionCopyWithImpl(this._value, this._then);

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
abstract class _$$InquiredAppVersionImplCopyWith<$Res>
    implements $InquiredAppVersionCopyWith<$Res> {
  factory _$$InquiredAppVersionImplCopyWith(_$InquiredAppVersionImpl value,
          $Res Function(_$InquiredAppVersionImpl) then) =
      __$$InquiredAppVersionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String value});
}

/// @nodoc
class __$$InquiredAppVersionImplCopyWithImpl<$Res>
    extends _$InquiredAppVersionCopyWithImpl<$Res, _$InquiredAppVersionImpl>
    implements _$$InquiredAppVersionImplCopyWith<$Res> {
  __$$InquiredAppVersionImplCopyWithImpl(_$InquiredAppVersionImpl _value,
      $Res Function(_$InquiredAppVersionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
  }) {
    return _then(_$InquiredAppVersionImpl(
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$InquiredAppVersionImpl extends _InquiredAppVersion {
  const _$InquiredAppVersionImpl({required this.value}) : super._();

  @override
  final String value;

  @override
  String toString() {
    return 'InquiredAppVersion(value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InquiredAppVersionImpl &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InquiredAppVersionImplCopyWith<_$InquiredAppVersionImpl> get copyWith =>
      __$$InquiredAppVersionImplCopyWithImpl<_$InquiredAppVersionImpl>(
          this, _$identity);
}

abstract class _InquiredAppVersion extends InquiredAppVersion {
  const factory _InquiredAppVersion({required final String value}) =
      _$InquiredAppVersionImpl;
  const _InquiredAppVersion._() : super._();

  @override
  String get value;
  @override
  @JsonKey(ignore: true)
  _$$InquiredAppVersionImplCopyWith<_$InquiredAppVersionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
