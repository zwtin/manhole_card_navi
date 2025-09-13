// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'list_cards_view_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ListCardsViewData {

 List<ListCardViewData> get list;
/// Create a copy of ListCardsViewData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ListCardsViewDataCopyWith<ListCardsViewData> get copyWith => _$ListCardsViewDataCopyWithImpl<ListCardsViewData>(this as ListCardsViewData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ListCardsViewData&&const DeepCollectionEquality().equals(other.list, list));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(list));

@override
String toString() {
  return 'ListCardsViewData(list: $list)';
}


}

/// @nodoc
abstract mixin class $ListCardsViewDataCopyWith<$Res>  {
  factory $ListCardsViewDataCopyWith(ListCardsViewData value, $Res Function(ListCardsViewData) _then) = _$ListCardsViewDataCopyWithImpl;
@useResult
$Res call({
 List<ListCardViewData> list
});




}
/// @nodoc
class _$ListCardsViewDataCopyWithImpl<$Res>
    implements $ListCardsViewDataCopyWith<$Res> {
  _$ListCardsViewDataCopyWithImpl(this._self, this._then);

  final ListCardsViewData _self;
  final $Res Function(ListCardsViewData) _then;

/// Create a copy of ListCardsViewData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? list = null,}) {
  return _then(_self.copyWith(
list: null == list ? _self.list : list // ignore: cast_nullable_to_non_nullable
as List<ListCardViewData>,
  ));
}

}


/// @nodoc


class _ListCardsViewData extends ListCardsViewData {
  const _ListCardsViewData({required final  List<ListCardViewData> list}): _list = list,super._();
  

 final  List<ListCardViewData> _list;
@override List<ListCardViewData> get list {
  if (_list is EqualUnmodifiableListView) return _list;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_list);
}


/// Create a copy of ListCardsViewData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ListCardsViewDataCopyWith<_ListCardsViewData> get copyWith => __$ListCardsViewDataCopyWithImpl<_ListCardsViewData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ListCardsViewData&&const DeepCollectionEquality().equals(other._list, _list));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_list));

@override
String toString() {
  return 'ListCardsViewData(list: $list)';
}


}

/// @nodoc
abstract mixin class _$ListCardsViewDataCopyWith<$Res> implements $ListCardsViewDataCopyWith<$Res> {
  factory _$ListCardsViewDataCopyWith(_ListCardsViewData value, $Res Function(_ListCardsViewData) _then) = __$ListCardsViewDataCopyWithImpl;
@override @useResult
$Res call({
 List<ListCardViewData> list
});




}
/// @nodoc
class __$ListCardsViewDataCopyWithImpl<$Res>
    implements _$ListCardsViewDataCopyWith<$Res> {
  __$ListCardsViewDataCopyWithImpl(this._self, this._then);

  final _ListCardsViewData _self;
  final $Res Function(_ListCardsViewData) _then;

/// Create a copy of ListCardsViewData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? list = null,}) {
  return _then(_ListCardsViewData(
list: null == list ? _self._list : list // ignore: cast_nullable_to_non_nullable
as List<ListCardViewData>,
  ));
}


}

// dart format on
