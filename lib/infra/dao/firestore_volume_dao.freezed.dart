// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'firestore_volume_dao.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FirestoreVolumeDAO {

 String get id; String get name;
/// Create a copy of FirestoreVolumeDAO
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FirestoreVolumeDAOCopyWith<FirestoreVolumeDAO> get copyWith => _$FirestoreVolumeDAOCopyWithImpl<FirestoreVolumeDAO>(this as FirestoreVolumeDAO, _$identity);

  /// Serializes this FirestoreVolumeDAO to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FirestoreVolumeDAO&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'FirestoreVolumeDAO(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $FirestoreVolumeDAOCopyWith<$Res>  {
  factory $FirestoreVolumeDAOCopyWith(FirestoreVolumeDAO value, $Res Function(FirestoreVolumeDAO) _then) = _$FirestoreVolumeDAOCopyWithImpl;
@useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class _$FirestoreVolumeDAOCopyWithImpl<$Res>
    implements $FirestoreVolumeDAOCopyWith<$Res> {
  _$FirestoreVolumeDAOCopyWithImpl(this._self, this._then);

  final FirestoreVolumeDAO _self;
  final $Res Function(FirestoreVolumeDAO) _then;

/// Create a copy of FirestoreVolumeDAO
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

class _FirestoreVolumeDAO extends FirestoreVolumeDAO {
  const _FirestoreVolumeDAO({required this.id, required this.name}): super._();
  factory _FirestoreVolumeDAO.fromJson(Map<String, dynamic> json) => _$FirestoreVolumeDAOFromJson(json);

@override final  String id;
@override final  String name;

/// Create a copy of FirestoreVolumeDAO
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FirestoreVolumeDAOCopyWith<_FirestoreVolumeDAO> get copyWith => __$FirestoreVolumeDAOCopyWithImpl<_FirestoreVolumeDAO>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FirestoreVolumeDAOToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FirestoreVolumeDAO&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'FirestoreVolumeDAO(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$FirestoreVolumeDAOCopyWith<$Res> implements $FirestoreVolumeDAOCopyWith<$Res> {
  factory _$FirestoreVolumeDAOCopyWith(_FirestoreVolumeDAO value, $Res Function(_FirestoreVolumeDAO) _then) = __$FirestoreVolumeDAOCopyWithImpl;
@override @useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class __$FirestoreVolumeDAOCopyWithImpl<$Res>
    implements _$FirestoreVolumeDAOCopyWith<$Res> {
  __$FirestoreVolumeDAOCopyWithImpl(this._self, this._then);

  final _FirestoreVolumeDAO _self;
  final $Res Function(_FirestoreVolumeDAO) _then;

/// Create a copy of FirestoreVolumeDAO
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_FirestoreVolumeDAO(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
