// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'manhole_card_prefectures.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ManholeCardPrefectures {
  List<ManholeCardPrefecture> get list => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ManholeCardPrefecturesCopyWith<ManholeCardPrefectures> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ManholeCardPrefecturesCopyWith<$Res> {
  factory $ManholeCardPrefecturesCopyWith(ManholeCardPrefectures value,
          $Res Function(ManholeCardPrefectures) then) =
      _$ManholeCardPrefecturesCopyWithImpl<$Res, ManholeCardPrefectures>;
  @useResult
  $Res call({List<ManholeCardPrefecture> list});
}

/// @nodoc
class _$ManholeCardPrefecturesCopyWithImpl<$Res,
        $Val extends ManholeCardPrefectures>
    implements $ManholeCardPrefecturesCopyWith<$Res> {
  _$ManholeCardPrefecturesCopyWithImpl(this._value, this._then);

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
              as List<ManholeCardPrefecture>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ManholeCardPrefecturesImplCopyWith<$Res>
    implements $ManholeCardPrefecturesCopyWith<$Res> {
  factory _$$ManholeCardPrefecturesImplCopyWith(
          _$ManholeCardPrefecturesImpl value,
          $Res Function(_$ManholeCardPrefecturesImpl) then) =
      __$$ManholeCardPrefecturesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<ManholeCardPrefecture> list});
}

/// @nodoc
class __$$ManholeCardPrefecturesImplCopyWithImpl<$Res>
    extends _$ManholeCardPrefecturesCopyWithImpl<$Res,
        _$ManholeCardPrefecturesImpl>
    implements _$$ManholeCardPrefecturesImplCopyWith<$Res> {
  __$$ManholeCardPrefecturesImplCopyWithImpl(
      _$ManholeCardPrefecturesImpl _value,
      $Res Function(_$ManholeCardPrefecturesImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? list = null,
  }) {
    return _then(_$ManholeCardPrefecturesImpl(
      list: null == list
          ? _value._list
          : list // ignore: cast_nullable_to_non_nullable
              as List<ManholeCardPrefecture>,
    ));
  }
}

/// @nodoc

class _$ManholeCardPrefecturesImpl extends _ManholeCardPrefectures {
  const _$ManholeCardPrefecturesImpl(
      {required final List<ManholeCardPrefecture> list})
      : _list = list,
        super._();

  final List<ManholeCardPrefecture> _list;
  @override
  List<ManholeCardPrefecture> get list {
    if (_list is EqualUnmodifiableListView) return _list;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_list);
  }

  @override
  String toString() {
    return 'ManholeCardPrefectures(list: $list)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ManholeCardPrefecturesImpl &&
            const DeepCollectionEquality().equals(other._list, _list));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_list));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ManholeCardPrefecturesImplCopyWith<_$ManholeCardPrefecturesImpl>
      get copyWith => __$$ManholeCardPrefecturesImplCopyWithImpl<
          _$ManholeCardPrefecturesImpl>(this, _$identity);
}

abstract class _ManholeCardPrefectures extends ManholeCardPrefectures {
  const factory _ManholeCardPrefectures(
          {required final List<ManholeCardPrefecture> list}) =
      _$ManholeCardPrefecturesImpl;
  const _ManholeCardPrefectures._() : super._();

  @override
  List<ManholeCardPrefecture> get list;
  @override
  @JsonKey(ignore: true)
  _$$ManholeCardPrefecturesImplCopyWith<_$ManholeCardPrefecturesImpl>
      get copyWith => throw _privateConstructorUsedError;
}
