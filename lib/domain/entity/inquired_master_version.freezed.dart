// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inquired_master_version.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$InquiredMasterVersion {
  String get value => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $InquiredMasterVersionCopyWith<InquiredMasterVersion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InquiredMasterVersionCopyWith<$Res> {
  factory $InquiredMasterVersionCopyWith(InquiredMasterVersion value,
          $Res Function(InquiredMasterVersion) then) =
      _$InquiredMasterVersionCopyWithImpl<$Res, InquiredMasterVersion>;
  @useResult
  $Res call({String value});
}

/// @nodoc
class _$InquiredMasterVersionCopyWithImpl<$Res,
        $Val extends InquiredMasterVersion>
    implements $InquiredMasterVersionCopyWith<$Res> {
  _$InquiredMasterVersionCopyWithImpl(this._value, this._then);

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
abstract class _$$InquiredMasterVersionImplCopyWith<$Res>
    implements $InquiredMasterVersionCopyWith<$Res> {
  factory _$$InquiredMasterVersionImplCopyWith(
          _$InquiredMasterVersionImpl value,
          $Res Function(_$InquiredMasterVersionImpl) then) =
      __$$InquiredMasterVersionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String value});
}

/// @nodoc
class __$$InquiredMasterVersionImplCopyWithImpl<$Res>
    extends _$InquiredMasterVersionCopyWithImpl<$Res,
        _$InquiredMasterVersionImpl>
    implements _$$InquiredMasterVersionImplCopyWith<$Res> {
  __$$InquiredMasterVersionImplCopyWithImpl(_$InquiredMasterVersionImpl _value,
      $Res Function(_$InquiredMasterVersionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
  }) {
    return _then(_$InquiredMasterVersionImpl(
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$InquiredMasterVersionImpl extends _InquiredMasterVersion {
  const _$InquiredMasterVersionImpl({required this.value}) : super._();

  @override
  final String value;

  @override
  String toString() {
    return 'InquiredMasterVersion(value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InquiredMasterVersionImpl &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InquiredMasterVersionImplCopyWith<_$InquiredMasterVersionImpl>
      get copyWith => __$$InquiredMasterVersionImplCopyWithImpl<
          _$InquiredMasterVersionImpl>(this, _$identity);
}

abstract class _InquiredMasterVersion extends InquiredMasterVersion {
  const factory _InquiredMasterVersion({required final String value}) =
      _$InquiredMasterVersionImpl;
  const _InquiredMasterVersion._() : super._();

  @override
  String get value;
  @override
  @JsonKey(ignore: true)
  _$$InquiredMasterVersionImplCopyWith<_$InquiredMasterVersionImpl>
      get copyWith => throw _privateConstructorUsedError;
}
