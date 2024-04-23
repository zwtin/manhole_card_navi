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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ListPrefectureViewData {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  ListCardsViewData get cards => throw _privateConstructorUsedError;
  bool get initiallyExpanded => throw _privateConstructorUsedError;

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
  $Res call(
      {String id,
      String name,
      ListCardsViewData cards,
      bool initiallyExpanded});

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
    Object? initiallyExpanded = null,
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
      initiallyExpanded: null == initiallyExpanded
          ? _value.initiallyExpanded
          : initiallyExpanded // ignore: cast_nullable_to_non_nullable
              as bool,
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
abstract class _$$ListPrefectureViewDataImplCopyWith<$Res>
    implements $ListPrefectureViewDataCopyWith<$Res> {
  factory _$$ListPrefectureViewDataImplCopyWith(
          _$ListPrefectureViewDataImpl value,
          $Res Function(_$ListPrefectureViewDataImpl) then) =
      __$$ListPrefectureViewDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      ListCardsViewData cards,
      bool initiallyExpanded});

  @override
  $ListCardsViewDataCopyWith<$Res> get cards;
}

/// @nodoc
class __$$ListPrefectureViewDataImplCopyWithImpl<$Res>
    extends _$ListPrefectureViewDataCopyWithImpl<$Res,
        _$ListPrefectureViewDataImpl>
    implements _$$ListPrefectureViewDataImplCopyWith<$Res> {
  __$$ListPrefectureViewDataImplCopyWithImpl(
      _$ListPrefectureViewDataImpl _value,
      $Res Function(_$ListPrefectureViewDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? cards = null,
    Object? initiallyExpanded = null,
  }) {
    return _then(_$ListPrefectureViewDataImpl(
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
      initiallyExpanded: null == initiallyExpanded
          ? _value.initiallyExpanded
          : initiallyExpanded // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$ListPrefectureViewDataImpl extends _ListPrefectureViewData {
  const _$ListPrefectureViewDataImpl(
      {required this.id,
      required this.name,
      required this.cards,
      required this.initiallyExpanded})
      : super._();

  @override
  final String id;
  @override
  final String name;
  @override
  final ListCardsViewData cards;
  @override
  final bool initiallyExpanded;

  @override
  String toString() {
    return 'ListPrefectureViewData(id: $id, name: $name, cards: $cards, initiallyExpanded: $initiallyExpanded)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ListPrefectureViewDataImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.cards, cards) || other.cards == cards) &&
            (identical(other.initiallyExpanded, initiallyExpanded) ||
                other.initiallyExpanded == initiallyExpanded));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, cards, initiallyExpanded);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ListPrefectureViewDataImplCopyWith<_$ListPrefectureViewDataImpl>
      get copyWith => __$$ListPrefectureViewDataImplCopyWithImpl<
          _$ListPrefectureViewDataImpl>(this, _$identity);
}

abstract class _ListPrefectureViewData extends ListPrefectureViewData {
  const factory _ListPrefectureViewData(
      {required final String id,
      required final String name,
      required final ListCardsViewData cards,
      required final bool initiallyExpanded}) = _$ListPrefectureViewDataImpl;
  const _ListPrefectureViewData._() : super._();

  @override
  String get id;
  @override
  String get name;
  @override
  ListCardsViewData get cards;
  @override
  bool get initiallyExpanded;
  @override
  @JsonKey(ignore: true)
  _$$ListPrefectureViewDataImplCopyWith<_$ListPrefectureViewDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}
