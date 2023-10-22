// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'current_app_version_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$CurrentAppVersionDTO {
  String get value => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CurrentAppVersionDTOCopyWith<CurrentAppVersionDTO> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CurrentAppVersionDTOCopyWith<$Res> {
  factory $CurrentAppVersionDTOCopyWith(CurrentAppVersionDTO value,
          $Res Function(CurrentAppVersionDTO) then) =
      _$CurrentAppVersionDTOCopyWithImpl<$Res, CurrentAppVersionDTO>;
  @useResult
  $Res call({String value});
}

/// @nodoc
class _$CurrentAppVersionDTOCopyWithImpl<$Res,
        $Val extends CurrentAppVersionDTO>
    implements $CurrentAppVersionDTOCopyWith<$Res> {
  _$CurrentAppVersionDTOCopyWithImpl(this._value, this._then);

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
abstract class _$$_CurrentAppVersionDTOCopyWith<$Res>
    implements $CurrentAppVersionDTOCopyWith<$Res> {
  factory _$$_CurrentAppVersionDTOCopyWith(_$_CurrentAppVersionDTO value,
          $Res Function(_$_CurrentAppVersionDTO) then) =
      __$$_CurrentAppVersionDTOCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String value});
}

/// @nodoc
class __$$_CurrentAppVersionDTOCopyWithImpl<$Res>
    extends _$CurrentAppVersionDTOCopyWithImpl<$Res, _$_CurrentAppVersionDTO>
    implements _$$_CurrentAppVersionDTOCopyWith<$Res> {
  __$$_CurrentAppVersionDTOCopyWithImpl(_$_CurrentAppVersionDTO _value,
      $Res Function(_$_CurrentAppVersionDTO) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
  }) {
    return _then(_$_CurrentAppVersionDTO(
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_CurrentAppVersionDTO extends _CurrentAppVersionDTO {
  const _$_CurrentAppVersionDTO({required this.value}) : super._();

  @override
  final String value;

  @override
  String toString() {
    return 'CurrentAppVersionDTO(value: $value)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CurrentAppVersionDTO &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_CurrentAppVersionDTOCopyWith<_$_CurrentAppVersionDTO> get copyWith =>
      __$$_CurrentAppVersionDTOCopyWithImpl<_$_CurrentAppVersionDTO>(
          this, _$identity);
}

abstract class _CurrentAppVersionDTO extends CurrentAppVersionDTO {
  const factory _CurrentAppVersionDTO({required final String value}) =
      _$_CurrentAppVersionDTO;
  const _CurrentAppVersionDTO._() : super._();

  @override
  String get value;
  @override
  @JsonKey(ignore: true)
  _$$_CurrentAppVersionDTOCopyWith<_$_CurrentAppVersionDTO> get copyWith =>
      throw _privateConstructorUsedError;
}
