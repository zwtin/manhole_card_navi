// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'agreed_terms_of_service_version.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AgreedTermsOfServiceVersion {
  String get value => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AgreedTermsOfServiceVersionCopyWith<AgreedTermsOfServiceVersion>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AgreedTermsOfServiceVersionCopyWith<$Res> {
  factory $AgreedTermsOfServiceVersionCopyWith(
          AgreedTermsOfServiceVersion value,
          $Res Function(AgreedTermsOfServiceVersion) then) =
      _$AgreedTermsOfServiceVersionCopyWithImpl<$Res,
          AgreedTermsOfServiceVersion>;
  @useResult
  $Res call({String value});
}

/// @nodoc
class _$AgreedTermsOfServiceVersionCopyWithImpl<$Res,
        $Val extends AgreedTermsOfServiceVersion>
    implements $AgreedTermsOfServiceVersionCopyWith<$Res> {
  _$AgreedTermsOfServiceVersionCopyWithImpl(this._value, this._then);

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
abstract class _$$AgreedTermsOfServiceVersionImplCopyWith<$Res>
    implements $AgreedTermsOfServiceVersionCopyWith<$Res> {
  factory _$$AgreedTermsOfServiceVersionImplCopyWith(
          _$AgreedTermsOfServiceVersionImpl value,
          $Res Function(_$AgreedTermsOfServiceVersionImpl) then) =
      __$$AgreedTermsOfServiceVersionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String value});
}

/// @nodoc
class __$$AgreedTermsOfServiceVersionImplCopyWithImpl<$Res>
    extends _$AgreedTermsOfServiceVersionCopyWithImpl<$Res,
        _$AgreedTermsOfServiceVersionImpl>
    implements _$$AgreedTermsOfServiceVersionImplCopyWith<$Res> {
  __$$AgreedTermsOfServiceVersionImplCopyWithImpl(
      _$AgreedTermsOfServiceVersionImpl _value,
      $Res Function(_$AgreedTermsOfServiceVersionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
  }) {
    return _then(_$AgreedTermsOfServiceVersionImpl(
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AgreedTermsOfServiceVersionImpl extends _AgreedTermsOfServiceVersion {
  const _$AgreedTermsOfServiceVersionImpl({required this.value}) : super._();

  @override
  final String value;

  @override
  String toString() {
    return 'AgreedTermsOfServiceVersion(value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AgreedTermsOfServiceVersionImpl &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AgreedTermsOfServiceVersionImplCopyWith<_$AgreedTermsOfServiceVersionImpl>
      get copyWith => __$$AgreedTermsOfServiceVersionImplCopyWithImpl<
          _$AgreedTermsOfServiceVersionImpl>(this, _$identity);
}

abstract class _AgreedTermsOfServiceVersion
    extends AgreedTermsOfServiceVersion {
  const factory _AgreedTermsOfServiceVersion({required final String value}) =
      _$AgreedTermsOfServiceVersionImpl;
  const _AgreedTermsOfServiceVersion._() : super._();

  @override
  String get value;
  @override
  @JsonKey(ignore: true)
  _$$AgreedTermsOfServiceVersionImplCopyWith<_$AgreedTermsOfServiceVersionImpl>
      get copyWith => throw _privateConstructorUsedError;
}
