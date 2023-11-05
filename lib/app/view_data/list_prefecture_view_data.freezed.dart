// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'list_prefecture_view_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ListPrefectureViewData {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  ListCardsViewData get cards => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ListPrefectureViewDataCopyWith<ListPrefectureViewData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ListPrefectureViewDataCopyWith<$Res> {
  factory $ListPrefectureViewDataCopyWith(ListPrefectureViewData value,
          $Res Function(ListPrefectureViewData) then) =
      _$ListPrefectureViewDataCopyWithImpl<$Res, ListPrefectureViewData>;
  @useResult
  $Res call({String id, String name, ListCardsViewData cards});

  $ListCardsViewDataCopyWith<$Res> get cards;
}

/// @nodoc
class _$ListPrefectureViewDataCopyWithImpl<$Res,
        $Val extends ListPrefectureViewData>
    implements $ListPrefectureViewDataCopyWith<$Res> {
  _$ListPrefectureViewDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? cards = null,
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
      cards: null == cards
          ? _value.cards
          : cards // ignore: cast_nullable_to_non_nullable
              as ListCardsViewData,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ListCardsViewDataCopyWith<$Res> get cards {
    return $ListCardsViewDataCopyWith<$Res>(_value.cards, (value) {
      return _then(_value.copyWith(cards: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_ListPrefectureViewDataCopyWith<$Res>
    implements $ListPrefectureViewDataCopyWith<$Res> {
  factory _$$_ListPrefectureViewDataCopyWith(_$_ListPrefectureViewData value,
          $Res Function(_$_ListPrefectureViewData) then) =
      __$$_ListPrefectureViewDataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, ListCardsViewData cards});

  @override
  $ListCardsViewDataCopyWith<$Res> get cards;
}

/// @nodoc
class __$$_ListPrefectureViewDataCopyWithImpl<$Res>
    extends _$ListPrefectureViewDataCopyWithImpl<$Res,
        _$_ListPrefectureViewData>
    implements _$$_ListPrefectureViewDataCopyWith<$Res> {
  __$$_ListPrefectureViewDataCopyWithImpl(_$_ListPrefectureViewData _value,
      $Res Function(_$_ListPrefectureViewData) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? cards = null,
  }) {
    return _then(_$_ListPrefectureViewData(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      cards: null == cards
          ? _value.cards
          : cards // ignore: cast_nullable_to_non_nullable
              as ListCardsViewData,
    ));
  }
}

/// @nodoc

class _$_ListPrefectureViewData extends _ListPrefectureViewData {
  const _$_ListPrefectureViewData(
      {required this.id, required this.name, required this.cards})
      : super._();

  @override
  final String id;
  @override
  final String name;
  @override
  final ListCardsViewData cards;

  @override
  String toString() {
    return 'ListPrefectureViewData(id: $id, name: $name, cards: $cards)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ListPrefectureViewData &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.cards, cards) || other.cards == cards));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, name, cards);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ListPrefectureViewDataCopyWith<_$_ListPrefectureViewData> get copyWith =>
      __$$_ListPrefectureViewDataCopyWithImpl<_$_ListPrefectureViewData>(
          this, _$identity);
}

abstract class _ListPrefectureViewData extends ListPrefectureViewData {
  const factory _ListPrefectureViewData(
      {required final String id,
      required final String name,
      required final ListCardsViewData cards}) = _$_ListPrefectureViewData;
  const _ListPrefectureViewData._() : super._();

  @override
  String get id;
  @override
  String get name;
  @override
  ListCardsViewData get cards;
  @override
  @JsonKey(ignore: true)
  _$$_ListPrefectureViewDataCopyWith<_$_ListPrefectureViewData> get copyWith =>
      throw _privateConstructorUsedError;
}
