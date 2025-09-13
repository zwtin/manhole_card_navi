// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'list_prefecture_view_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ListPrefectureViewData {

 String get id; String get name; ListCardsViewData get cards; bool get initiallyExpanded; int get totalCount; int get alreadyGetCount;
/// Create a copy of ListPrefectureViewData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ListPrefectureViewDataCopyWith<ListPrefectureViewData> get copyWith => _$ListPrefectureViewDataCopyWithImpl<ListPrefectureViewData>(this as ListPrefectureViewData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ListPrefectureViewData&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.cards, cards) || other.cards == cards)&&(identical(other.initiallyExpanded, initiallyExpanded) || other.initiallyExpanded == initiallyExpanded)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.alreadyGetCount, alreadyGetCount) || other.alreadyGetCount == alreadyGetCount));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,cards,initiallyExpanded,totalCount,alreadyGetCount);

@override
String toString() {
  return 'ListPrefectureViewData(id: $id, name: $name, cards: $cards, initiallyExpanded: $initiallyExpanded, totalCount: $totalCount, alreadyGetCount: $alreadyGetCount)';
}


}

/// @nodoc
abstract mixin class $ListPrefectureViewDataCopyWith<$Res>  {
  factory $ListPrefectureViewDataCopyWith(ListPrefectureViewData value, $Res Function(ListPrefectureViewData) _then) = _$ListPrefectureViewDataCopyWithImpl;
@useResult
$Res call({
 String id, String name, ListCardsViewData cards, bool initiallyExpanded, int totalCount, int alreadyGetCount
});


$ListCardsViewDataCopyWith<$Res> get cards;

}
/// @nodoc
class _$ListPrefectureViewDataCopyWithImpl<$Res>
    implements $ListPrefectureViewDataCopyWith<$Res> {
  _$ListPrefectureViewDataCopyWithImpl(this._self, this._then);

  final ListPrefectureViewData _self;
  final $Res Function(ListPrefectureViewData) _then;

/// Create a copy of ListPrefectureViewData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? cards = null,Object? initiallyExpanded = null,Object? totalCount = null,Object? alreadyGetCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,cards: null == cards ? _self.cards : cards // ignore: cast_nullable_to_non_nullable
as ListCardsViewData,initiallyExpanded: null == initiallyExpanded ? _self.initiallyExpanded : initiallyExpanded // ignore: cast_nullable_to_non_nullable
as bool,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,alreadyGetCount: null == alreadyGetCount ? _self.alreadyGetCount : alreadyGetCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of ListPrefectureViewData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ListCardsViewDataCopyWith<$Res> get cards {
  
  return $ListCardsViewDataCopyWith<$Res>(_self.cards, (value) {
    return _then(_self.copyWith(cards: value));
  });
}
}


/// @nodoc


class _ListPrefectureViewData extends ListPrefectureViewData {
  const _ListPrefectureViewData({required this.id, required this.name, required this.cards, required this.initiallyExpanded, required this.totalCount, required this.alreadyGetCount}): super._();
  

@override final  String id;
@override final  String name;
@override final  ListCardsViewData cards;
@override final  bool initiallyExpanded;
@override final  int totalCount;
@override final  int alreadyGetCount;

/// Create a copy of ListPrefectureViewData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ListPrefectureViewDataCopyWith<_ListPrefectureViewData> get copyWith => __$ListPrefectureViewDataCopyWithImpl<_ListPrefectureViewData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ListPrefectureViewData&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.cards, cards) || other.cards == cards)&&(identical(other.initiallyExpanded, initiallyExpanded) || other.initiallyExpanded == initiallyExpanded)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.alreadyGetCount, alreadyGetCount) || other.alreadyGetCount == alreadyGetCount));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,cards,initiallyExpanded,totalCount,alreadyGetCount);

@override
String toString() {
  return 'ListPrefectureViewData(id: $id, name: $name, cards: $cards, initiallyExpanded: $initiallyExpanded, totalCount: $totalCount, alreadyGetCount: $alreadyGetCount)';
}


}

/// @nodoc
abstract mixin class _$ListPrefectureViewDataCopyWith<$Res> implements $ListPrefectureViewDataCopyWith<$Res> {
  factory _$ListPrefectureViewDataCopyWith(_ListPrefectureViewData value, $Res Function(_ListPrefectureViewData) _then) = __$ListPrefectureViewDataCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, ListCardsViewData cards, bool initiallyExpanded, int totalCount, int alreadyGetCount
});


@override $ListCardsViewDataCopyWith<$Res> get cards;

}
/// @nodoc
class __$ListPrefectureViewDataCopyWithImpl<$Res>
    implements _$ListPrefectureViewDataCopyWith<$Res> {
  __$ListPrefectureViewDataCopyWithImpl(this._self, this._then);

  final _ListPrefectureViewData _self;
  final $Res Function(_ListPrefectureViewData) _then;

/// Create a copy of ListPrefectureViewData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? cards = null,Object? initiallyExpanded = null,Object? totalCount = null,Object? alreadyGetCount = null,}) {
  return _then(_ListPrefectureViewData(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,cards: null == cards ? _self.cards : cards // ignore: cast_nullable_to_non_nullable
as ListCardsViewData,initiallyExpanded: null == initiallyExpanded ? _self.initiallyExpanded : initiallyExpanded // ignore: cast_nullable_to_non_nullable
as bool,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,alreadyGetCount: null == alreadyGetCount ? _self.alreadyGetCount : alreadyGetCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of ListPrefectureViewData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ListCardsViewDataCopyWith<$Res> get cards {
  
  return $ListCardsViewDataCopyWith<$Res>(_self.cards, (value) {
    return _then(_self.copyWith(cards: value));
  });
}
}

// dart format on
