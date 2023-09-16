// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'current_app_version.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$CurrentAppVersion {
  String get version => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CurrentAppVersionCopyWith<CurrentAppVersion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CurrentAppVersionCopyWith<$Res> {
  factory $CurrentAppVersionCopyWith(
          CurrentAppVersion value, $Res Function(CurrentAppVersion) then) =
      _$CurrentAppVersionCopyWithImpl<$Res, CurrentAppVersion>;
  @useResult
  $Res call({String version});
}

/// @nodoc
class _$CurrentAppVersionCopyWithImpl<$Res, $Val extends CurrentAppVersion>
    implements $CurrentAppVersionCopyWith<$Res> {
  _$CurrentAppVersionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = null,
  }) {
    return _then(_value.copyWith(
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_CurrentAppVersionCopyWith<$Res>
    implements $CurrentAppVersionCopyWith<$Res> {
  factory _$$_CurrentAppVersionCopyWith(_$_CurrentAppVersion value,
          $Res Function(_$_CurrentAppVersion) then) =
      __$$_CurrentAppVersionCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String version});
}

/// @nodoc
class __$$_CurrentAppVersionCopyWithImpl<$Res>
    extends _$CurrentAppVersionCopyWithImpl<$Res, _$_CurrentAppVersion>
    implements _$$_CurrentAppVersionCopyWith<$Res> {
  __$$_CurrentAppVersionCopyWithImpl(
      _$_CurrentAppVersion _value, $Res Function(_$_CurrentAppVersion) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = null,
  }) {
    return _then(_$_CurrentAppVersion(
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_CurrentAppVersion extends _CurrentAppVersion {
  const _$_CurrentAppVersion({required this.version}) : super._();

  @override
  final String version;

  @override
  String toString() {
    return 'CurrentAppVersion(version: $version)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CurrentAppVersion &&
            (identical(other.version, version) || other.version == version));
  }

  @override
  int get hashCode => Object.hash(runtimeType, version);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_CurrentAppVersionCopyWith<_$_CurrentAppVersion> get copyWith =>
      __$$_CurrentAppVersionCopyWithImpl<_$_CurrentAppVersion>(
          this, _$identity);
}

abstract class _CurrentAppVersion extends CurrentAppVersion {
  const factory _CurrentAppVersion({required final String version}) =
      _$_CurrentAppVersion;
  const _CurrentAppVersion._() : super._();

  @override
  String get version;
  @override
  @JsonKey(ignore: true)
  _$$_CurrentAppVersionCopyWith<_$_CurrentAppVersion> get copyWith =>
      throw _privateConstructorUsedError;
}
