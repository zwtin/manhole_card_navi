// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'manhole_cards.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ManholeCards {

 List<ManholeCard> get list;
/// Create a copy of ManholeCards
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ManholeCardsCopyWith<ManholeCards> get copyWith => _$ManholeCardsCopyWithImpl<ManholeCards>(this as ManholeCards, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ManholeCards&&const DeepCollectionEquality().equals(other.list, list));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(list));

@override
String toString() {
  return 'ManholeCards(list: $list)';
}


}

/// @nodoc
abstract mixin class $ManholeCardsCopyWith<$Res>  {
  factory $ManholeCardsCopyWith(ManholeCards value, $Res Function(ManholeCards) _then) = _$ManholeCardsCopyWithImpl;
@useResult
$Res call({
 List<ManholeCard> list
});




}
/// @nodoc
class _$ManholeCardsCopyWithImpl<$Res>
    implements $ManholeCardsCopyWith<$Res> {
  _$ManholeCardsCopyWithImpl(this._self, this._then);

  final ManholeCards _self;
  final $Res Function(ManholeCards) _then;

/// Create a copy of ManholeCards
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? list = null,}) {
  return _then(_self.copyWith(
list: null == list ? _self.list : list // ignore: cast_nullable_to_non_nullable
as List<ManholeCard>,
  ));
}

}


/// @nodoc


class _ManholeCards extends ManholeCards {
  const _ManholeCards({required final  List<ManholeCard> list}): _list = list,super._();
  

 final  List<ManholeCard> _list;
@override List<ManholeCard> get list {
  if (_list is EqualUnmodifiableListView) return _list;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_list);
}


/// Create a copy of ManholeCards
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ManholeCardsCopyWith<_ManholeCards> get copyWith => __$ManholeCardsCopyWithImpl<_ManholeCards>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ManholeCards&&const DeepCollectionEquality().equals(other._list, _list));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_list));

@override
String toString() {
  return 'ManholeCards(list: $list)';
}


}

/// @nodoc
abstract mixin class _$ManholeCardsCopyWith<$Res> implements $ManholeCardsCopyWith<$Res> {
  factory _$ManholeCardsCopyWith(_ManholeCards value, $Res Function(_ManholeCards) _then) = __$ManholeCardsCopyWithImpl;
@override @useResult
$Res call({
 List<ManholeCard> list
});




}
/// @nodoc
class __$ManholeCardsCopyWithImpl<$Res>
    implements _$ManholeCardsCopyWith<$Res> {
  __$ManholeCardsCopyWithImpl(this._self, this._then);

  final _ManholeCards _self;
  final $Res Function(_ManholeCards) _then;

/// Create a copy of ManholeCards
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? list = null,}) {
  return _then(_ManholeCards(
list: null == list ? _self._list : list // ignore: cast_nullable_to_non_nullable
as List<ManholeCard>,
  ));
}


}

// dart format on
