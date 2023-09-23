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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ManholeCardImage {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get path => throw _privateConstructorUsedError;

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
  $Res call({String id, String name, String path});
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
    Object? path = null,
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
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ManholeCardImageCopyWith<$Res>
    implements $ManholeCardImageCopyWith<$Res> {
  factory _$$_ManholeCardImageCopyWith(
          _$_ManholeCardImage value, $Res Function(_$_ManholeCardImage) then) =
      __$$_ManholeCardImageCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, String path});
}

/// @nodoc
class __$$_ManholeCardImageCopyWithImpl<$Res>
    extends _$ManholeCardImageCopyWithImpl<$Res, _$_ManholeCardImage>
    implements _$$_ManholeCardImageCopyWith<$Res> {
  __$$_ManholeCardImageCopyWithImpl(
      _$_ManholeCardImage _value, $Res Function(_$_ManholeCardImage) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? path = null,
  }) {
    return _then(_$_ManholeCardImage(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_ManholeCardImage extends _ManholeCardImage {
  const _$_ManholeCardImage(
      {required this.id, required this.name, required this.path})
      : super._();

  @override
  final String id;
  @override
  final String name;
  @override
  final String path;

  @override
  String toString() {
    return 'ManholeCardImage(id: $id, name: $name, path: $path)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ManholeCardImage &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.path, path) || other.path == path));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, name, path);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ManholeCardImageCopyWith<_$_ManholeCardImage> get copyWith =>
      __$$_ManholeCardImageCopyWithImpl<_$_ManholeCardImage>(this, _$identity);
}

abstract class _ManholeCardImage extends ManholeCardImage {
  const factory _ManholeCardImage(
      {required final String id,
      required final String name,
      required final String path}) = _$_ManholeCardImage;
  const _ManholeCardImage._() : super._();

  @override
  String get id;
  @override
  String get name;
  @override
  String get path;
  @override
  @JsonKey(ignore: true)
  _$$_ManholeCardImageCopyWith<_$_ManholeCardImage> get copyWith =>
      throw _privateConstructorUsedError;
}
