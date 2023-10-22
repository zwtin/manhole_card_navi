// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'terms_of_service.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$TermsOfService {
  String get value => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TermsOfServiceCopyWith<TermsOfService> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TermsOfServiceCopyWith<$Res> {
  factory $TermsOfServiceCopyWith(
          TermsOfService value, $Res Function(TermsOfService) then) =
      _$TermsOfServiceCopyWithImpl<$Res, TermsOfService>;
  @useResult
  $Res call({String value});
}

/// @nodoc
class _$TermsOfServiceCopyWithImpl<$Res, $Val extends TermsOfService>
    implements $TermsOfServiceCopyWith<$Res> {
  _$TermsOfServiceCopyWithImpl(this._value, this._then);

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
abstract class _$$_TermsOfServiceCopyWith<$Res>
    implements $TermsOfServiceCopyWith<$Res> {
  factory _$$_TermsOfServiceCopyWith(
          _$_TermsOfService value, $Res Function(_$_TermsOfService) then) =
      __$$_TermsOfServiceCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String value});
}

/// @nodoc
class __$$_TermsOfServiceCopyWithImpl<$Res>
    extends _$TermsOfServiceCopyWithImpl<$Res, _$_TermsOfService>
    implements _$$_TermsOfServiceCopyWith<$Res> {
  __$$_TermsOfServiceCopyWithImpl(
      _$_TermsOfService _value, $Res Function(_$_TermsOfService) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
  }) {
    return _then(_$_TermsOfService(
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_TermsOfService extends _TermsOfService {
  const _$_TermsOfService({required this.value}) : super._();

  @override
  final String value;

  @override
  String toString() {
    return 'TermsOfService(value: $value)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_TermsOfService &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_TermsOfServiceCopyWith<_$_TermsOfService> get copyWith =>
      __$$_TermsOfServiceCopyWithImpl<_$_TermsOfService>(this, _$identity);
}

abstract class _TermsOfService extends TermsOfService {
  const factory _TermsOfService({required final String value}) =
      _$_TermsOfService;
  const _TermsOfService._() : super._();

  @override
  String get value;
  @override
  @JsonKey(ignore: true)
  _$$_TermsOfServiceCopyWith<_$_TermsOfService> get copyWith =>
      throw _privateConstructorUsedError;
}
