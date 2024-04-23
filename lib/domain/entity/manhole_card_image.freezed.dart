// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'manhole_card_image.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ManholeCardImage {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ManholeCardImageCopyWith<ManholeCardImage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ManholeCardImageCopyWith<$Res> {
  factory $ManholeCardImageCopyWith(
          ManholeCardImage value, $Res Function(ManholeCardImage) then) =
      _$ManholeCardImageCopyWithImpl<$Res, ManholeCardImage>;
  @useResult
  $Res call({String id, String name});
}

/// @nodoc
class _$ManholeCardImageCopyWithImpl<$Res, $Val extends ManholeCardImage>
    implements $ManholeCardImageCopyWith<$Res> {
  _$ManholeCardImageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ManholeCardImageImplCopyWith<$Res>
    implements $ManholeCardImageCopyWith<$Res> {
  factory _$$ManholeCardImageImplCopyWith(_$ManholeCardImageImpl value,
          $Res Function(_$ManholeCardImageImpl) then) =
      __$$ManholeCardImageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name});
}

/// @nodoc
class __$$ManholeCardImageImplCopyWithImpl<$Res>
    extends _$ManholeCardImageCopyWithImpl<$Res, _$ManholeCardImageImpl>
    implements _$$ManholeCardImageImplCopyWith<$Res> {
  __$$ManholeCardImageImplCopyWithImpl(_$ManholeCardImageImpl _value,
      $Res Function(_$ManholeCardImageImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
  }) {
    return _then(_$ManholeCardImageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ManholeCardImageImpl extends _ManholeCardImage {
  const _$ManholeCardImageImpl({required this.id, required this.name})
      : super._();

  @override
  final String id;
  @override
  final String name;

  @override
  String toString() {
    return 'ManholeCardImage(id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ManholeCardImageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ManholeCardImageImplCopyWith<_$ManholeCardImageImpl> get copyWith =>
      __$$ManholeCardImageImplCopyWithImpl<_$ManholeCardImageImpl>(
          this, _$identity);
}

abstract class _ManholeCardImage extends ManholeCardImage {
  const factory _ManholeCardImage(
      {required final String id,
      required final String name}) = _$ManholeCardImageImpl;
  const _ManholeCardImage._() : super._();

  @override
  String get id;
  @override
  String get name;
  @override
  @JsonKey(ignore: true)
  _$$ManholeCardImageImplCopyWith<_$ManholeCardImageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
