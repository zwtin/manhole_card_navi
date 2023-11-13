// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'need_terms_of_service_update_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$NeedTermsOfServiceUpdateDTO {
  bool get value => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $NeedTermsOfServiceUpdateDTOCopyWith<NeedTermsOfServiceUpdateDTO>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NeedTermsOfServiceUpdateDTOCopyWith<$Res> {
  factory $NeedTermsOfServiceUpdateDTOCopyWith(
          NeedTermsOfServiceUpdateDTO value,
          $Res Function(NeedTermsOfServiceUpdateDTO) then) =
      _$NeedTermsOfServiceUpdateDTOCopyWithImpl<$Res,
          NeedTermsOfServiceUpdateDTO>;
  @useResult
  $Res call({bool value});
}

/// @nodoc
class _$NeedTermsOfServiceUpdateDTOCopyWithImpl<$Res,
        $Val extends NeedTermsOfServiceUpdateDTO>
    implements $NeedTermsOfServiceUpdateDTOCopyWith<$Res> {
  _$NeedTermsOfServiceUpdateDTOCopyWithImpl(this._value, this._then);

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
abstract class _$$_NeedTermsOfServiceUpdateDTOCopyWith<$Res>
    implements $NeedTermsOfServiceUpdateDTOCopyWith<$Res> {
  factory _$$_NeedTermsOfServiceUpdateDTOCopyWith(
          _$_NeedTermsOfServiceUpdateDTO value,
          $Res Function(_$_NeedTermsOfServiceUpdateDTO) then) =
      __$$_NeedTermsOfServiceUpdateDTOCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool value});
}

/// @nodoc
class __$$_NeedTermsOfServiceUpdateDTOCopyWithImpl<$Res>
    extends _$NeedTermsOfServiceUpdateDTOCopyWithImpl<$Res,
        _$_NeedTermsOfServiceUpdateDTO>
    implements _$$_NeedTermsOfServiceUpdateDTOCopyWith<$Res> {
  __$$_NeedTermsOfServiceUpdateDTOCopyWithImpl(
      _$_NeedTermsOfServiceUpdateDTO _value,
      $Res Function(_$_NeedTermsOfServiceUpdateDTO) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
  }) {
    return _then(_$_NeedTermsOfServiceUpdateDTO(
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_NeedTermsOfServiceUpdateDTO extends _NeedTermsOfServiceUpdateDTO {
  const _$_NeedTermsOfServiceUpdateDTO({required this.value}) : super._();

  @override
  final bool value;

  @override
  String toString() {
    return 'NeedTermsOfServiceUpdateDTO(value: $value)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_NeedTermsOfServiceUpdateDTO &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_NeedTermsOfServiceUpdateDTOCopyWith<_$_NeedTermsOfServiceUpdateDTO>
      get copyWith => __$$_NeedTermsOfServiceUpdateDTOCopyWithImpl<
          _$_NeedTermsOfServiceUpdateDTO>(this, _$identity);
}

abstract class _NeedTermsOfServiceUpdateDTO
    extends NeedTermsOfServiceUpdateDTO {
  const factory _NeedTermsOfServiceUpdateDTO({required final bool value}) =
      _$_NeedTermsOfServiceUpdateDTO;
  const _NeedTermsOfServiceUpdateDTO._() : super._();

  @override
  bool get value;
  @override
  @JsonKey(ignore: true)
  _$$_NeedTermsOfServiceUpdateDTOCopyWith<_$_NeedTermsOfServiceUpdateDTO>
      get copyWith => throw _privateConstructorUsedError;
}
