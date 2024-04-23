// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_info_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AppInfoDTO {
  String get name => throw _privateConstructorUsedError;
  String get version => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AppInfoDTOCopyWith<AppInfoDTO> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppInfoDTOCopyWith<$Res> {
  factory $AppInfoDTOCopyWith(
          AppInfoDTO value, $Res Function(AppInfoDTO) then) =
      _$AppInfoDTOCopyWithImpl<$Res, AppInfoDTO>;
  @useResult
  $Res call({String name, String version});
}

/// @nodoc
class _$AppInfoDTOCopyWithImpl<$Res, $Val extends AppInfoDTO>
    implements $AppInfoDTOCopyWith<$Res> {
  _$AppInfoDTOCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? version = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppInfoDTOImplCopyWith<$Res>
    implements $AppInfoDTOCopyWith<$Res> {
  factory _$$AppInfoDTOImplCopyWith(
          _$AppInfoDTOImpl value, $Res Function(_$AppInfoDTOImpl) then) =
      __$$AppInfoDTOImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String version});
}

/// @nodoc
class __$$AppInfoDTOImplCopyWithImpl<$Res>
    extends _$AppInfoDTOCopyWithImpl<$Res, _$AppInfoDTOImpl>
    implements _$$AppInfoDTOImplCopyWith<$Res> {
  __$$AppInfoDTOImplCopyWithImpl(
      _$AppInfoDTOImpl _value, $Res Function(_$AppInfoDTOImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? version = null,
  }) {
    return _then(_$AppInfoDTOImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AppInfoDTOImpl extends _AppInfoDTO {
  const _$AppInfoDTOImpl({required this.name, required this.version})
      : super._();

  @override
  final String name;
  @override
  final String version;

  @override
  String toString() {
    return 'AppInfoDTO(name: $name, version: $version)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppInfoDTOImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.version, version) || other.version == version));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name, version);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AppInfoDTOImplCopyWith<_$AppInfoDTOImpl> get copyWith =>
      __$$AppInfoDTOImplCopyWithImpl<_$AppInfoDTOImpl>(this, _$identity);
}

abstract class _AppInfoDTO extends AppInfoDTO {
  const factory _AppInfoDTO(
      {required final String name,
      required final String version}) = _$AppInfoDTOImpl;
  const _AppInfoDTO._() : super._();

  @override
  String get name;
  @override
  String get version;
  @override
  @JsonKey(ignore: true)
  _$$AppInfoDTOImplCopyWith<_$AppInfoDTOImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
