// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'first_open_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$FirstOpenDTO {
  bool get isFirst => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $FirstOpenDTOCopyWith<FirstOpenDTO> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FirstOpenDTOCopyWith<$Res> {
  factory $FirstOpenDTOCopyWith(
          FirstOpenDTO value, $Res Function(FirstOpenDTO) then) =
      _$FirstOpenDTOCopyWithImpl<$Res, FirstOpenDTO>;
  @useResult
  $Res call({bool isFirst});
}

/// @nodoc
class _$FirstOpenDTOCopyWithImpl<$Res, $Val extends FirstOpenDTO>
    implements $FirstOpenDTOCopyWith<$Res> {
  _$FirstOpenDTOCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isFirst = null,
  }) {
    return _then(_value.copyWith(
      isFirst: null == isFirst
          ? _value.isFirst
          : isFirst // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_FirstOpenDTOCopyWith<$Res>
    implements $FirstOpenDTOCopyWith<$Res> {
  factory _$$_FirstOpenDTOCopyWith(
          _$_FirstOpenDTO value, $Res Function(_$_FirstOpenDTO) then) =
      __$$_FirstOpenDTOCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isFirst});
}

/// @nodoc
class __$$_FirstOpenDTOCopyWithImpl<$Res>
    extends _$FirstOpenDTOCopyWithImpl<$Res, _$_FirstOpenDTO>
    implements _$$_FirstOpenDTOCopyWith<$Res> {
  __$$_FirstOpenDTOCopyWithImpl(
      _$_FirstOpenDTO _value, $Res Function(_$_FirstOpenDTO) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isFirst = null,
  }) {
    return _then(_$_FirstOpenDTO(
      isFirst: null == isFirst
          ? _value.isFirst
          : isFirst // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_FirstOpenDTO extends _FirstOpenDTO {
  const _$_FirstOpenDTO({required this.isFirst}) : super._();

  @override
  final bool isFirst;

  @override
  String toString() {
    return 'FirstOpenDTO(isFirst: $isFirst)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_FirstOpenDTO &&
            (identical(other.isFirst, isFirst) || other.isFirst == isFirst));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isFirst);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_FirstOpenDTOCopyWith<_$_FirstOpenDTO> get copyWith =>
      __$$_FirstOpenDTOCopyWithImpl<_$_FirstOpenDTO>(this, _$identity);
}

abstract class _FirstOpenDTO extends FirstOpenDTO {
  const factory _FirstOpenDTO({required final bool isFirst}) = _$_FirstOpenDTO;
  const _FirstOpenDTO._() : super._();

  @override
  bool get isFirst;
  @override
  @JsonKey(ignore: true)
  _$$_FirstOpenDTOCopyWith<_$_FirstOpenDTO> get copyWith =>
      throw _privateConstructorUsedError;
}
