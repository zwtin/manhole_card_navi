// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'manhole_card_contacts.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ManholeCardContacts {

 List<ManholeCardContact> get list;
/// Create a copy of ManholeCardContacts
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ManholeCardContactsCopyWith<ManholeCardContacts> get copyWith => _$ManholeCardContactsCopyWithImpl<ManholeCardContacts>(this as ManholeCardContacts, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ManholeCardContacts&&const DeepCollectionEquality().equals(other.list, list));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(list));

@override
String toString() {
  return 'ManholeCardContacts(list: $list)';
}


}

/// @nodoc
abstract mixin class $ManholeCardContactsCopyWith<$Res>  {
  factory $ManholeCardContactsCopyWith(ManholeCardContacts value, $Res Function(ManholeCardContacts) _then) = _$ManholeCardContactsCopyWithImpl;
@useResult
$Res call({
 List<ManholeCardContact> list
});




}
/// @nodoc
class _$ManholeCardContactsCopyWithImpl<$Res>
    implements $ManholeCardContactsCopyWith<$Res> {
  _$ManholeCardContactsCopyWithImpl(this._self, this._then);

  final ManholeCardContacts _self;
  final $Res Function(ManholeCardContacts) _then;

/// Create a copy of ManholeCardContacts
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? list = null,}) {
  return _then(_self.copyWith(
list: null == list ? _self.list : list // ignore: cast_nullable_to_non_nullable
as List<ManholeCardContact>,
  ));
}

}


/// @nodoc


class _ManholeCardContacts extends ManholeCardContacts {
  const _ManholeCardContacts({required final  List<ManholeCardContact> list}): _list = list,super._();
  

 final  List<ManholeCardContact> _list;
@override List<ManholeCardContact> get list {
  if (_list is EqualUnmodifiableListView) return _list;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_list);
}


/// Create a copy of ManholeCardContacts
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ManholeCardContactsCopyWith<_ManholeCardContacts> get copyWith => __$ManholeCardContactsCopyWithImpl<_ManholeCardContacts>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ManholeCardContacts&&const DeepCollectionEquality().equals(other._list, _list));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_list));

@override
String toString() {
  return 'ManholeCardContacts(list: $list)';
}


}

/// @nodoc
abstract mixin class _$ManholeCardContactsCopyWith<$Res> implements $ManholeCardContactsCopyWith<$Res> {
  factory _$ManholeCardContactsCopyWith(_ManholeCardContacts value, $Res Function(_ManholeCardContacts) _then) = __$ManholeCardContactsCopyWithImpl;
@override @useResult
$Res call({
 List<ManholeCardContact> list
});




}
/// @nodoc
class __$ManholeCardContactsCopyWithImpl<$Res>
    implements _$ManholeCardContactsCopyWith<$Res> {
  __$ManholeCardContactsCopyWithImpl(this._self, this._then);

  final _ManholeCardContacts _self;
  final $Res Function(_ManholeCardContacts) _then;

/// Create a copy of ManholeCardContacts
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? list = null,}) {
  return _then(_ManholeCardContacts(
list: null == list ? _self._list : list // ignore: cast_nullable_to_non_nullable
as List<ManholeCardContact>,
  ));
}


}

// dart format on
