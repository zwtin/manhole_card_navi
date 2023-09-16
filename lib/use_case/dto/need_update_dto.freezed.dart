// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'need_update_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$NeedUpdateDTO {
  bool get need => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $NeedUpdateDTOCopyWith<NeedUpdateDTO> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NeedUpdateDTOCopyWith<$Res> {
  factory $NeedUpdateDTOCopyWith(
          NeedUpdateDTO value, $Res Function(NeedUpdateDTO) then) =
      _$NeedUpdateDTOCopyWithImpl<$Res, NeedUpdateDTO>;
  @useResult
  $Res call({bool need});
}

/// @nodoc
class _$NeedUpdateDTOCopyWithImpl<$Res, $Val extends NeedUpdateDTO>
    implements $NeedUpdateDTOCopyWith<$Res> {
  _$NeedUpdateDTOCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? need = null,
  }) {
    return _then(_value.copyWith(
      need: null == need
          ? _value.need
          : need // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_NeedUpdateDTOCopyWith<$Res>
    implements $NeedUpdateDTOCopyWith<$Res> {
  factory _$$_NeedUpdateDTOCopyWith(
          _$_NeedUpdateDTO value, $Res Function(_$_NeedUpdateDTO) then) =
      __$$_NeedUpdateDTOCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool need});
}

/// @nodoc
class __$$_NeedUpdateDTOCopyWithImpl<$Res>
    extends _$NeedUpdateDTOCopyWithImpl<$Res, _$_NeedUpdateDTO>
    implements _$$_NeedUpdateDTOCopyWith<$Res> {
  __$$_NeedUpdateDTOCopyWithImpl(
      _$_NeedUpdateDTO _value, $Res Function(_$_NeedUpdateDTO) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? need = null,
  }) {
    return _then(_$_NeedUpdateDTO(
      need: null == need
          ? _value.need
          : need // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_NeedUpdateDTO extends _NeedUpdateDTO {
  const _$_NeedUpdateDTO({required this.need}) : super._();

  @override
  final bool need;

  @override
  String toString() {
    return 'NeedUpdateDTO(need: $need)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_NeedUpdateDTO &&
            (identical(other.need, need) || other.need == need));
  }

  @override
  int get hashCode => Object.hash(runtimeType, need);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_NeedUpdateDTOCopyWith<_$_NeedUpdateDTO> get copyWith =>
      __$$_NeedUpdateDTOCopyWithImpl<_$_NeedUpdateDTO>(this, _$identity);
}

abstract class _NeedUpdateDTO extends NeedUpdateDTO {
  const factory _NeedUpdateDTO({required final bool need}) = _$_NeedUpdateDTO;
  const _NeedUpdateDTO._() : super._();

  @override
  bool get need;
  @override
  @JsonKey(ignore: true)
  _$$_NeedUpdateDTOCopyWith<_$_NeedUpdateDTO> get copyWith =>
      throw _privateConstructorUsedError;
}
