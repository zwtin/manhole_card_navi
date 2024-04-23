// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'manhole_cards.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ManholeCards {
  List<ManholeCard> get list => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ManholeCardsCopyWith<ManholeCards> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ManholeCardsCopyWith<$Res> {
  factory $ManholeCardsCopyWith(
          ManholeCards value, $Res Function(ManholeCards) then) =
      _$ManholeCardsCopyWithImpl<$Res, ManholeCards>;
  @useResult
  $Res call({List<ManholeCard> list});
}

/// @nodoc
class _$ManholeCardsCopyWithImpl<$Res, $Val extends ManholeCards>
    implements $ManholeCardsCopyWith<$Res> {
  _$ManholeCardsCopyWithImpl(this._value, this._then);

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
              as List<ManholeCard>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ManholeCardsImplCopyWith<$Res>
    implements $ManholeCardsCopyWith<$Res> {
  factory _$$ManholeCardsImplCopyWith(
          _$ManholeCardsImpl value, $Res Function(_$ManholeCardsImpl) then) =
      __$$ManholeCardsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<ManholeCard> list});
}

/// @nodoc
class __$$ManholeCardsImplCopyWithImpl<$Res>
    extends _$ManholeCardsCopyWithImpl<$Res, _$ManholeCardsImpl>
    implements _$$ManholeCardsImplCopyWith<$Res> {
  __$$ManholeCardsImplCopyWithImpl(
      _$ManholeCardsImpl _value, $Res Function(_$ManholeCardsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? list = null,
  }) {
    return _then(_$ManholeCardsImpl(
      list: null == list
          ? _value._list
          : list // ignore: cast_nullable_to_non_nullable
              as List<ManholeCard>,
    ));
  }
}

/// @nodoc

class _$ManholeCardsImpl extends _ManholeCards {
  const _$ManholeCardsImpl({required final List<ManholeCard> list})
      : _list = list,
        super._();

  final List<ManholeCard> _list;
  @override
  List<ManholeCard> get list {
    if (_list is EqualUnmodifiableListView) return _list;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_list);
  }

  @override
  String toString() {
    return 'ManholeCards(list: $list)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ManholeCardsImpl &&
            const DeepCollectionEquality().equals(other._list, _list));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_list));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ManholeCardsImplCopyWith<_$ManholeCardsImpl> get copyWith =>
      __$$ManholeCardsImplCopyWithImpl<_$ManholeCardsImpl>(this, _$identity);
}

abstract class _ManholeCards extends ManholeCards {
  const factory _ManholeCards({required final List<ManholeCard> list}) =
      _$ManholeCardsImpl;
  const _ManholeCards._() : super._();

  @override
  List<ManholeCard> get list;
  @override
  @JsonKey(ignore: true)
  _$$ManholeCardsImplCopyWith<_$ManholeCardsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
