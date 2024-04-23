// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'need_master_update_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$NeedMasterUpdateDTO {
  bool get value => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $NeedMasterUpdateDTOCopyWith<NeedMasterUpdateDTO> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NeedMasterUpdateDTOCopyWith<$Res> {
  factory $NeedMasterUpdateDTOCopyWith(
          NeedMasterUpdateDTO value, $Res Function(NeedMasterUpdateDTO) then) =
      _$NeedMasterUpdateDTOCopyWithImpl<$Res, NeedMasterUpdateDTO>;
  @useResult
  $Res call({bool value});
}

/// @nodoc
class _$NeedMasterUpdateDTOCopyWithImpl<$Res, $Val extends NeedMasterUpdateDTO>
    implements $NeedMasterUpdateDTOCopyWith<$Res> {
  _$NeedMasterUpdateDTOCopyWithImpl(this._value, this._then);

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
abstract class _$$NeedMasterUpdateDTOImplCopyWith<$Res>
    implements $NeedMasterUpdateDTOCopyWith<$Res> {
  factory _$$NeedMasterUpdateDTOImplCopyWith(_$NeedMasterUpdateDTOImpl value,
          $Res Function(_$NeedMasterUpdateDTOImpl) then) =
      __$$NeedMasterUpdateDTOImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool value});
}

/// @nodoc
class __$$NeedMasterUpdateDTOImplCopyWithImpl<$Res>
    extends _$NeedMasterUpdateDTOCopyWithImpl<$Res, _$NeedMasterUpdateDTOImpl>
    implements _$$NeedMasterUpdateDTOImplCopyWith<$Res> {
  __$$NeedMasterUpdateDTOImplCopyWithImpl(_$NeedMasterUpdateDTOImpl _value,
      $Res Function(_$NeedMasterUpdateDTOImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
  }) {
    return _then(_$NeedMasterUpdateDTOImpl(
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$NeedMasterUpdateDTOImpl extends _NeedMasterUpdateDTO {
  const _$NeedMasterUpdateDTOImpl({required this.value}) : super._();

  @override
  final bool value;

  @override
  String toString() {
    return 'NeedMasterUpdateDTO(value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NeedMasterUpdateDTOImpl &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NeedMasterUpdateDTOImplCopyWith<_$NeedMasterUpdateDTOImpl> get copyWith =>
      __$$NeedMasterUpdateDTOImplCopyWithImpl<_$NeedMasterUpdateDTOImpl>(
          this, _$identity);
}

abstract class _NeedMasterUpdateDTO extends NeedMasterUpdateDTO {
  const factory _NeedMasterUpdateDTO({required final bool value}) =
      _$NeedMasterUpdateDTOImpl;
  const _NeedMasterUpdateDTO._() : super._();

  @override
  bool get value;
  @override
  @JsonKey(ignore: true)
  _$$NeedMasterUpdateDTOImplCopyWith<_$NeedMasterUpdateDTOImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
