// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'firestore_prefecture_dao.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FirestorePrefectureDAO {

 String get id; String get name;
/// Create a copy of FirestorePrefectureDAO
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FirestorePrefectureDAOCopyWith<FirestorePrefectureDAO> get copyWith => _$FirestorePrefectureDAOCopyWithImpl<FirestorePrefectureDAO>(this as FirestorePrefectureDAO, _$identity);

  /// Serializes this FirestorePrefectureDAO to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FirestorePrefectureDAO&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'FirestorePrefectureDAO(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $FirestorePrefectureDAOCopyWith<$Res>  {
  factory $FirestorePrefectureDAOCopyWith(FirestorePrefectureDAO value, $Res Function(FirestorePrefectureDAO) _then) = _$FirestorePrefectureDAOCopyWithImpl;
@useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class _$FirestorePrefectureDAOCopyWithImpl<$Res>
    implements $FirestorePrefectureDAOCopyWith<$Res> {
  _$FirestorePrefectureDAOCopyWithImpl(this._self, this._then);

  final FirestorePrefectureDAO _self;
  final $Res Function(FirestorePrefectureDAO) _then;

/// Create a copy of FirestorePrefectureDAO
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _FirestorePrefectureDAO extends FirestorePrefectureDAO {
  const _FirestorePrefectureDAO({required this.id, required this.name}): super._();
  factory _FirestorePrefectureDAO.fromJson(Map<String, dynamic> json) => _$FirestorePrefectureDAOFromJson(json);

@override final  String id;
@override final  String name;

/// Create a copy of FirestorePrefectureDAO
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FirestorePrefectureDAOCopyWith<_FirestorePrefectureDAO> get copyWith => __$FirestorePrefectureDAOCopyWithImpl<_FirestorePrefectureDAO>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FirestorePrefectureDAOToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FirestorePrefectureDAO&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'FirestorePrefectureDAO(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$FirestorePrefectureDAOCopyWith<$Res> implements $FirestorePrefectureDAOCopyWith<$Res> {
  factory _$FirestorePrefectureDAOCopyWith(_FirestorePrefectureDAO value, $Res Function(_FirestorePrefectureDAO) _then) = __$FirestorePrefectureDAOCopyWithImpl;
@override @useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class __$FirestorePrefectureDAOCopyWithImpl<$Res>
    implements _$FirestorePrefectureDAOCopyWith<$Res> {
  __$FirestorePrefectureDAOCopyWithImpl(this._self, this._then);

  final _FirestorePrefectureDAO _self;
  final $Res Function(_FirestorePrefectureDAO) _then;

/// Create a copy of FirestorePrefectureDAO
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_FirestorePrefectureDAO(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
