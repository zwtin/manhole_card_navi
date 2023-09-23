// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'need_app_update_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$NeedAppUpdateDTO {
  bool get need => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $NeedAppUpdateDTOCopyWith<NeedAppUpdateDTO> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NeedAppUpdateDTOCopyWith<$Res> {
  factory $NeedAppUpdateDTOCopyWith(
          NeedAppUpdateDTO value, $Res Function(NeedAppUpdateDTO) then) =
      _$NeedAppUpdateDTOCopyWithImpl<$Res, NeedAppUpdateDTO>;
  @useResult
  $Res call({bool need});
}

/// @nodoc
class _$NeedAppUpdateDTOCopyWithImpl<$Res, $Val extends NeedAppUpdateDTO>
    implements $NeedAppUpdateDTOCopyWith<$Res> {
  _$NeedAppUpdateDTOCopyWithImpl(this._value, this._then);

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
abstract class _$$_NeedAppUpdateDTOCopyWith<$Res>
    implements $NeedAppUpdateDTOCopyWith<$Res> {
  factory _$$_NeedAppUpdateDTOCopyWith(
          _$_NeedAppUpdateDTO value, $Res Function(_$_NeedAppUpdateDTO) then) =
      __$$_NeedAppUpdateDTOCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool need});
}

/// @nodoc
class __$$_NeedAppUpdateDTOCopyWithImpl<$Res>
    extends _$NeedAppUpdateDTOCopyWithImpl<$Res, _$_NeedAppUpdateDTO>
    implements _$$_NeedAppUpdateDTOCopyWith<$Res> {
  __$$_NeedAppUpdateDTOCopyWithImpl(
      _$_NeedAppUpdateDTO _value, $Res Function(_$_NeedAppUpdateDTO) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? need = null,
  }) {
    return _then(_$_NeedAppUpdateDTO(
      need: null == need
          ? _value.need
          : need // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_NeedAppUpdateDTO extends _NeedAppUpdateDTO {
  const _$_NeedAppUpdateDTO({required this.need}) : super._();

  @override
  final bool need;

  @override
  String toString() {
    return 'NeedAppUpdateDTO(need: $need)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_NeedAppUpdateDTO &&
            (identical(other.need, need) || other.need == need));
  }

  @override
  int get hashCode => Object.hash(runtimeType, need);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_NeedAppUpdateDTOCopyWith<_$_NeedAppUpdateDTO> get copyWith =>
      __$$_NeedAppUpdateDTOCopyWithImpl<_$_NeedAppUpdateDTO>(this, _$identity);
}

abstract class _NeedAppUpdateDTO extends NeedAppUpdateDTO {
  const factory _NeedAppUpdateDTO({required final bool need}) =
      _$_NeedAppUpdateDTO;
  const _NeedAppUpdateDTO._() : super._();

  @override
  bool get need;
  @override
  @JsonKey(ignore: true)
  _$$_NeedAppUpdateDTOCopyWith<_$_NeedAppUpdateDTO> get copyWith =>
      throw _privateConstructorUsedError;
}
