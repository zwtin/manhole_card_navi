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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$NeedAppUpdateDTO {
  bool get value => throw _privateConstructorUsedError;

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
  $Res call({bool value});
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
abstract class _$$NeedAppUpdateDTOImplCopyWith<$Res>
    implements $NeedAppUpdateDTOCopyWith<$Res> {
  factory _$$NeedAppUpdateDTOImplCopyWith(_$NeedAppUpdateDTOImpl value,
          $Res Function(_$NeedAppUpdateDTOImpl) then) =
      __$$NeedAppUpdateDTOImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool value});
}

/// @nodoc
class __$$NeedAppUpdateDTOImplCopyWithImpl<$Res>
    extends _$NeedAppUpdateDTOCopyWithImpl<$Res, _$NeedAppUpdateDTOImpl>
    implements _$$NeedAppUpdateDTOImplCopyWith<$Res> {
  __$$NeedAppUpdateDTOImplCopyWithImpl(_$NeedAppUpdateDTOImpl _value,
      $Res Function(_$NeedAppUpdateDTOImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
  }) {
    return _then(_$NeedAppUpdateDTOImpl(
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$NeedAppUpdateDTOImpl extends _NeedAppUpdateDTO {
  const _$NeedAppUpdateDTOImpl({required this.value}) : super._();

  @override
  final bool value;

  @override
  String toString() {
    return 'NeedAppUpdateDTO(value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NeedAppUpdateDTOImpl &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NeedAppUpdateDTOImplCopyWith<_$NeedAppUpdateDTOImpl> get copyWith =>
      __$$NeedAppUpdateDTOImplCopyWithImpl<_$NeedAppUpdateDTOImpl>(
          this, _$identity);
}

abstract class _NeedAppUpdateDTO extends NeedAppUpdateDTO {
  const factory _NeedAppUpdateDTO({required final bool value}) =
      _$NeedAppUpdateDTOImpl;
  const _NeedAppUpdateDTO._() : super._();

  @override
  bool get value;
  @override
  @JsonKey(ignore: true)
  _$$NeedAppUpdateDTOImplCopyWith<_$NeedAppUpdateDTOImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
