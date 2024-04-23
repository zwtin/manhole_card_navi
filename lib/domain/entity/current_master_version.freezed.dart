// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'current_master_version.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CurrentMasterVersion {
  String get value => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CurrentMasterVersionCopyWith<CurrentMasterVersion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CurrentMasterVersionCopyWith<$Res> {
  factory $CurrentMasterVersionCopyWith(CurrentMasterVersion value,
          $Res Function(CurrentMasterVersion) then) =
      _$CurrentMasterVersionCopyWithImpl<$Res, CurrentMasterVersion>;
  @useResult
  $Res call({String value});
}

/// @nodoc
class _$CurrentMasterVersionCopyWithImpl<$Res,
        $Val extends CurrentMasterVersion>
    implements $CurrentMasterVersionCopyWith<$Res> {
  _$CurrentMasterVersionCopyWithImpl(this._value, this._then);

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
abstract class _$$CurrentMasterVersionImplCopyWith<$Res>
    implements $CurrentMasterVersionCopyWith<$Res> {
  factory _$$CurrentMasterVersionImplCopyWith(_$CurrentMasterVersionImpl value,
          $Res Function(_$CurrentMasterVersionImpl) then) =
      __$$CurrentMasterVersionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String value});
}

/// @nodoc
class __$$CurrentMasterVersionImplCopyWithImpl<$Res>
    extends _$CurrentMasterVersionCopyWithImpl<$Res, _$CurrentMasterVersionImpl>
    implements _$$CurrentMasterVersionImplCopyWith<$Res> {
  __$$CurrentMasterVersionImplCopyWithImpl(_$CurrentMasterVersionImpl _value,
      $Res Function(_$CurrentMasterVersionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
  }) {
    return _then(_$CurrentMasterVersionImpl(
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$CurrentMasterVersionImpl extends _CurrentMasterVersion {
  const _$CurrentMasterVersionImpl({required this.value}) : super._();

  @override
  final String value;

  @override
  String toString() {
    return 'CurrentMasterVersion(value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CurrentMasterVersionImpl &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CurrentMasterVersionImplCopyWith<_$CurrentMasterVersionImpl>
      get copyWith =>
          __$$CurrentMasterVersionImplCopyWithImpl<_$CurrentMasterVersionImpl>(
              this, _$identity);
}

abstract class _CurrentMasterVersion extends CurrentMasterVersion {
  const factory _CurrentMasterVersion({required final String value}) =
      _$CurrentMasterVersionImpl;
  const _CurrentMasterVersion._() : super._();

  @override
  String get value;
  @override
  @JsonKey(ignore: true)
  _$$CurrentMasterVersionImplCopyWith<_$CurrentMasterVersionImpl>
      get copyWith => throw _privateConstructorUsedError;
}
