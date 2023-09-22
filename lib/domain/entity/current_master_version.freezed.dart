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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$CurrentMasterVersion {
  String get version => throw _privateConstructorUsedError;

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
  $Res call({String version});
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
abstract class _$$_CurrentMasterVersionCopyWith<$Res>
    implements $CurrentMasterVersionCopyWith<$Res> {
  factory _$$_CurrentMasterVersionCopyWith(_$_CurrentMasterVersion value,
          $Res Function(_$_CurrentMasterVersion) then) =
      __$$_CurrentMasterVersionCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String version});
}

/// @nodoc
class __$$_CurrentMasterVersionCopyWithImpl<$Res>
    extends _$CurrentMasterVersionCopyWithImpl<$Res, _$_CurrentMasterVersion>
    implements _$$_CurrentMasterVersionCopyWith<$Res> {
  __$$_CurrentMasterVersionCopyWithImpl(_$_CurrentMasterVersion _value,
      $Res Function(_$_CurrentMasterVersion) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = null,
  }) {
    return _then(_$_CurrentMasterVersion(
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_CurrentMasterVersion extends _CurrentMasterVersion {
  const _$_CurrentMasterVersion({required this.version}) : super._();

  @override
  final String version;

  @override
  String toString() {
    return 'CurrentMasterVersion(version: $version)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CurrentMasterVersion &&
            (identical(other.version, version) || other.version == version));
  }

  @override
  int get hashCode => Object.hash(runtimeType, version);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_CurrentMasterVersionCopyWith<_$_CurrentMasterVersion> get copyWith =>
      __$$_CurrentMasterVersionCopyWithImpl<_$_CurrentMasterVersion>(
          this, _$identity);
}

abstract class _CurrentMasterVersion extends CurrentMasterVersion {
  const factory _CurrentMasterVersion({required final String version}) =
      _$_CurrentMasterVersion;
  const _CurrentMasterVersion._() : super._();

  @override
  String get version;
  @override
  @JsonKey(ignore: true)
  _$$_CurrentMasterVersionCopyWith<_$_CurrentMasterVersion> get copyWith =>
      throw _privateConstructorUsedError;
}
