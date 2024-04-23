// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'custom_exception.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CustomException {
  String get title => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CustomExceptionCopyWith<CustomException> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomExceptionCopyWith<$Res> {
  factory $CustomExceptionCopyWith(
          CustomException value, $Res Function(CustomException) then) =
      _$CustomExceptionCopyWithImpl<$Res, CustomException>;
  @useResult
  $Res call({String title, String text});
}

/// @nodoc
class _$CustomExceptionCopyWithImpl<$Res, $Val extends CustomException>
    implements $CustomExceptionCopyWith<$Res> {
  _$CustomExceptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? text = null,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CustomExceptionImplCopyWith<$Res>
    implements $CustomExceptionCopyWith<$Res> {
  factory _$$CustomExceptionImplCopyWith(_$CustomExceptionImpl value,
          $Res Function(_$CustomExceptionImpl) then) =
      __$$CustomExceptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String title, String text});
}

/// @nodoc
class __$$CustomExceptionImplCopyWithImpl<$Res>
    extends _$CustomExceptionCopyWithImpl<$Res, _$CustomExceptionImpl>
    implements _$$CustomExceptionImplCopyWith<$Res> {
  __$$CustomExceptionImplCopyWithImpl(
      _$CustomExceptionImpl _value, $Res Function(_$CustomExceptionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? text = null,
  }) {
    return _then(_$CustomExceptionImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$CustomExceptionImpl extends _CustomException {
  const _$CustomExceptionImpl({required this.title, required this.text})
      : super._();

  @override
  final String title;
  @override
  final String text;

  @override
  String toString() {
    return 'CustomException(title: $title, text: $text)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomExceptionImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.text, text) || other.text == text));
  }

  @override
  int get hashCode => Object.hash(runtimeType, title, text);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomExceptionImplCopyWith<_$CustomExceptionImpl> get copyWith =>
      __$$CustomExceptionImplCopyWithImpl<_$CustomExceptionImpl>(
          this, _$identity);
}

abstract class _CustomException extends CustomException {
  const factory _CustomException(
      {required final String title,
      required final String text}) = _$CustomExceptionImpl;
  const _CustomException._() : super._();

  @override
  String get title;
  @override
  String get text;
  @override
  @JsonKey(ignore: true)
  _$$CustomExceptionImplCopyWith<_$CustomExceptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
