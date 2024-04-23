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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

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
abstract class _$$ListCardsViewDataImplCopyWith<$Res>
    implements $ListCardsViewDataCopyWith<$Res> {
  factory _$$ListCardsViewDataImplCopyWith(_$ListCardsViewDataImpl value,
          $Res Function(_$ListCardsViewDataImpl) then) =
      __$$ListCardsViewDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<ListCardViewData> list});
}

/// @nodoc
class __$$ListCardsViewDataImplCopyWithImpl<$Res>
    extends _$ListCardsViewDataCopyWithImpl<$Res, _$ListCardsViewDataImpl>
    implements _$$ListCardsViewDataImplCopyWith<$Res> {
  __$$ListCardsViewDataImplCopyWithImpl(_$ListCardsViewDataImpl _value,
      $Res Function(_$ListCardsViewDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? list = null,
  }) {
    return _then(_$ListCardsViewDataImpl(
      list: null == list
          ? _value._list
          : list // ignore: cast_nullable_to_non_nullable
              as List<ListCardViewData>,
    ));
  }
}

/// @nodoc

class _$ListCardsViewDataImpl extends _ListCardsViewData {
  const _$ListCardsViewDataImpl({required final List<ListCardViewData> list})
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
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ListCardsViewDataImpl &&
            const DeepCollectionEquality().equals(other._list, _list));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_list));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ListCardsViewDataImplCopyWith<_$ListCardsViewDataImpl> get copyWith =>
      __$$ListCardsViewDataImplCopyWithImpl<_$ListCardsViewDataImpl>(
          this, _$identity);
}

abstract class _ListCardsViewData extends ListCardsViewData {
  const factory _ListCardsViewData(
      {required final List<ListCardViewData> list}) = _$ListCardsViewDataImpl;
  const _ListCardsViewData._() : super._();

  @override
  List<ListCardViewData> get list;
  @override
  @JsonKey(ignore: true)
  _$$ListCardsViewDataImplCopyWith<_$ListCardsViewDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
