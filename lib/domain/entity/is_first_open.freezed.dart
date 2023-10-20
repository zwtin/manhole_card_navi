// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'is_first_open.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$IsFirstOpen {
  bool get value => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $IsFirstOpenCopyWith<IsFirstOpen> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IsFirstOpenCopyWith<$Res> {
  factory $IsFirstOpenCopyWith(
          IsFirstOpen value, $Res Function(IsFirstOpen) then) =
      _$IsFirstOpenCopyWithImpl<$Res, IsFirstOpen>;
  @useResult
  $Res call({bool value});
}

/// @nodoc
class _$IsFirstOpenCopyWithImpl<$Res, $Val extends IsFirstOpen>
    implements $IsFirstOpenCopyWith<$Res> {
  _$IsFirstOpenCopyWithImpl(this._value, this._then);

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
abstract class _$$_IsFirstOpenCopyWith<$Res>
    implements $IsFirstOpenCopyWith<$Res> {
  factory _$$_IsFirstOpenCopyWith(
          _$_IsFirstOpen value, $Res Function(_$_IsFirstOpen) then) =
      __$$_IsFirstOpenCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool value});
}

/// @nodoc
class __$$_IsFirstOpenCopyWithImpl<$Res>
    extends _$IsFirstOpenCopyWithImpl<$Res, _$_IsFirstOpen>
    implements _$$_IsFirstOpenCopyWith<$Res> {
  __$$_IsFirstOpenCopyWithImpl(
      _$_IsFirstOpen _value, $Res Function(_$_IsFirstOpen) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
  }) {
    return _then(_$_IsFirstOpen(
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_IsFirstOpen extends _IsFirstOpen {
  const _$_IsFirstOpen({required this.value}) : super._();

  @override
  final bool value;

  @override
  String toString() {
    return 'IsFirstOpen(value: $value)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_IsFirstOpen &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_IsFirstOpenCopyWith<_$_IsFirstOpen> get copyWith =>
      __$$_IsFirstOpenCopyWithImpl<_$_IsFirstOpen>(this, _$identity);
}

abstract class _IsFirstOpen extends IsFirstOpen {
  const factory _IsFirstOpen({required final bool value}) = _$_IsFirstOpen;
  const _IsFirstOpen._() : super._();

  @override
  bool get value;
  @override
  @JsonKey(ignore: true)
  _$$_IsFirstOpenCopyWith<_$_IsFirstOpen> get copyWith =>
      throw _privateConstructorUsedError;
}
