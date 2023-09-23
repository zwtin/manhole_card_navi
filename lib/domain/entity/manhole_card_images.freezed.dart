// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'manhole_card_images.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ManholeCardImages {
  List<ManholeCardImage> get list => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ManholeCardImagesCopyWith<ManholeCardImages> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ManholeCardImagesCopyWith<$Res> {
  factory $ManholeCardImagesCopyWith(
          ManholeCardImages value, $Res Function(ManholeCardImages) then) =
      _$ManholeCardImagesCopyWithImpl<$Res, ManholeCardImages>;
  @useResult
  $Res call({List<ManholeCardImage> list});
}

/// @nodoc
class _$ManholeCardImagesCopyWithImpl<$Res, $Val extends ManholeCardImages>
    implements $ManholeCardImagesCopyWith<$Res> {
  _$ManholeCardImagesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? list = null,
  }) {
    return _then(_value.copyWith(
      list: null == list
          ? _value.list
          : list // ignore: cast_nullable_to_non_nullable
              as List<ManholeCardImage>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ManholeCardImagesCopyWith<$Res>
    implements $ManholeCardImagesCopyWith<$Res> {
  factory _$$_ManholeCardImagesCopyWith(_$_ManholeCardImages value,
          $Res Function(_$_ManholeCardImages) then) =
      __$$_ManholeCardImagesCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<ManholeCardImage> list});
}

/// @nodoc
class __$$_ManholeCardImagesCopyWithImpl<$Res>
    extends _$ManholeCardImagesCopyWithImpl<$Res, _$_ManholeCardImages>
    implements _$$_ManholeCardImagesCopyWith<$Res> {
  __$$_ManholeCardImagesCopyWithImpl(
      _$_ManholeCardImages _value, $Res Function(_$_ManholeCardImages) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? list = null,
  }) {
    return _then(_$_ManholeCardImages(
      list: null == list
          ? _value._list
          : list // ignore: cast_nullable_to_non_nullable
              as List<ManholeCardImage>,
    ));
  }
}

/// @nodoc

class _$_ManholeCardImages extends _ManholeCardImages {
  const _$_ManholeCardImages({required final List<ManholeCardImage> list})
      : _list = list,
        super._();

  final List<ManholeCardImage> _list;
  @override
  List<ManholeCardImage> get list {
    if (_list is EqualUnmodifiableListView) return _list;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_list);
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ManholeCardImages &&
            const DeepCollectionEquality().equals(other._list, _list));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_list));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ManholeCardImagesCopyWith<_$_ManholeCardImages> get copyWith =>
      __$$_ManholeCardImagesCopyWithImpl<_$_ManholeCardImages>(
          this, _$identity);
}

abstract class _ManholeCardImages extends ManholeCardImages {
  const factory _ManholeCardImages(
      {required final List<ManholeCardImage> list}) = _$_ManholeCardImages;
  const _ManholeCardImages._() : super._();

  @override
  List<ManholeCardImage> get list;
  @override
  @JsonKey(ignore: true)
  _$$_ManholeCardImagesCopyWith<_$_ManholeCardImages> get copyWith =>
      throw _privateConstructorUsedError;
}
