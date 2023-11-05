// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'list_cards_view_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ListCardsViewData {
  List<ListCardViewData> get list => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ListCardsViewDataCopyWith<ListCardsViewData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ListCardsViewDataCopyWith<$Res> {
  factory $ListCardsViewDataCopyWith(
          ListCardsViewData value, $Res Function(ListCardsViewData) then) =
      _$ListCardsViewDataCopyWithImpl<$Res, ListCardsViewData>;
  @useResult
  $Res call({List<ListCardViewData> list});
}

/// @nodoc
class _$ListCardsViewDataCopyWithImpl<$Res, $Val extends ListCardsViewData>
    implements $ListCardsViewDataCopyWith<$Res> {
  _$ListCardsViewDataCopyWithImpl(this._value, this._then);

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
              as List<ListCardViewData>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ListCardsViewDataCopyWith<$Res>
    implements $ListCardsViewDataCopyWith<$Res> {
  factory _$$_ListCardsViewDataCopyWith(_$_ListCardsViewData value,
          $Res Function(_$_ListCardsViewData) then) =
      __$$_ListCardsViewDataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<ListCardViewData> list});
}

/// @nodoc
class __$$_ListCardsViewDataCopyWithImpl<$Res>
    extends _$ListCardsViewDataCopyWithImpl<$Res, _$_ListCardsViewData>
    implements _$$_ListCardsViewDataCopyWith<$Res> {
  __$$_ListCardsViewDataCopyWithImpl(
      _$_ListCardsViewData _value, $Res Function(_$_ListCardsViewData) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? list = null,
  }) {
    return _then(_$_ListCardsViewData(
      list: null == list
          ? _value._list
          : list // ignore: cast_nullable_to_non_nullable
              as List<ListCardViewData>,
    ));
  }
}

/// @nodoc

class _$_ListCardsViewData extends _ListCardsViewData {
  const _$_ListCardsViewData({required final List<ListCardViewData> list})
      : _list = list,
        super._();

  final List<ListCardViewData> _list;
  @override
  List<ListCardViewData> get list {
    if (_list is EqualUnmodifiableListView) return _list;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_list);
  }

  @override
  String toString() {
    return 'ListCardsViewData(list: $list)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ListCardsViewData &&
            const DeepCollectionEquality().equals(other._list, _list));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_list));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ListCardsViewDataCopyWith<_$_ListCardsViewData> get copyWith =>
      __$$_ListCardsViewDataCopyWithImpl<_$_ListCardsViewData>(
          this, _$identity);
}

abstract class _ListCardsViewData extends ListCardsViewData {
  const factory _ListCardsViewData(
      {required final List<ListCardViewData> list}) = _$_ListCardsViewData;
  const _ListCardsViewData._() : super._();

  @override
  List<ListCardViewData> get list;
  @override
  @JsonKey(ignore: true)
  _$$_ListCardsViewDataCopyWith<_$_ListCardsViewData> get copyWith =>
      throw _privateConstructorUsedError;
}
