// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'is_first_open_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$IsFirstOpenDTO {
  bool get value => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $IsFirstOpenDTOCopyWith<IsFirstOpenDTO> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IsFirstOpenDTOCopyWith<$Res> {
  factory $IsFirstOpenDTOCopyWith(
          IsFirstOpenDTO value, $Res Function(IsFirstOpenDTO) then) =
      _$IsFirstOpenDTOCopyWithImpl<$Res, IsFirstOpenDTO>;
  @useResult
  $Res call({bool value});
}

/// @nodoc
class _$IsFirstOpenDTOCopyWithImpl<$Res, $Val extends IsFirstOpenDTO>
    implements $IsFirstOpenDTOCopyWith<$Res> {
  _$IsFirstOpenDTOCopyWithImpl(this._value, this._then);

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
abstract class _$$_IsFirstOpenDTOCopyWith<$Res>
    implements $IsFirstOpenDTOCopyWith<$Res> {
  factory _$$_IsFirstOpenDTOCopyWith(
          _$_IsFirstOpenDTO value, $Res Function(_$_IsFirstOpenDTO) then) =
      __$$_IsFirstOpenDTOCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool value});
}

/// @nodoc
class __$$_IsFirstOpenDTOCopyWithImpl<$Res>
    extends _$IsFirstOpenDTOCopyWithImpl<$Res, _$_IsFirstOpenDTO>
    implements _$$_IsFirstOpenDTOCopyWith<$Res> {
  __$$_IsFirstOpenDTOCopyWithImpl(
      _$_IsFirstOpenDTO _value, $Res Function(_$_IsFirstOpenDTO) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
  }) {
    return _then(_$_IsFirstOpenDTO(
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_IsFirstOpenDTO extends _IsFirstOpenDTO {
  const _$_IsFirstOpenDTO({required this.value}) : super._();

  @override
  final bool value;

  @override
  String toString() {
    return 'IsFirstOpenDTO(value: $value)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_IsFirstOpenDTO &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_IsFirstOpenDTOCopyWith<_$_IsFirstOpenDTO> get copyWith =>
      __$$_IsFirstOpenDTOCopyWithImpl<_$_IsFirstOpenDTO>(this, _$identity);
}

abstract class _IsFirstOpenDTO extends IsFirstOpenDTO {
  const factory _IsFirstOpenDTO({required final bool value}) =
      _$_IsFirstOpenDTO;
  const _IsFirstOpenDTO._() : super._();

  @override
  bool get value;
  @override
  @JsonKey(ignore: true)
  _$$_IsFirstOpenDTOCopyWith<_$_IsFirstOpenDTO> get copyWith =>
      throw _privateConstructorUsedError;
}
