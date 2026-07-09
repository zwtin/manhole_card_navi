// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'firestore_image_dao.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FirestoreImageDAO {

 String get id; String get colorOriginal;
/// Create a copy of FirestoreImageDAO
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FirestoreImageDAOCopyWith<FirestoreImageDAO> get copyWith => _$FirestoreImageDAOCopyWithImpl<FirestoreImageDAO>(this as FirestoreImageDAO, _$identity);

  /// Serializes this FirestoreImageDAO to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FirestoreImageDAO&&(identical(other.id, id) || other.id == id)&&(identical(other.colorOriginal, colorOriginal) || other.colorOriginal == colorOriginal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,colorOriginal);

@override
String toString() {
  return 'FirestoreImageDAO(id: $id, colorOriginal: $colorOriginal)';
}


}

/// @nodoc
abstract mixin class $FirestoreImageDAOCopyWith<$Res>  {
  factory $FirestoreImageDAOCopyWith(FirestoreImageDAO value, $Res Function(FirestoreImageDAO) _then) = _$FirestoreImageDAOCopyWithImpl;
@useResult
$Res call({
 String id, String colorOriginal
});




}
/// @nodoc
class _$FirestoreImageDAOCopyWithImpl<$Res>
    implements $FirestoreImageDAOCopyWith<$Res> {
  _$FirestoreImageDAOCopyWithImpl(this._self, this._then);

  final FirestoreImageDAO _self;
  final $Res Function(FirestoreImageDAO) _then;

/// Create a copy of FirestoreImageDAO
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? colorOriginal = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,colorOriginal: null == colorOriginal ? _self.colorOriginal : colorOriginal // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _FirestoreImageDAO extends FirestoreImageDAO {
  const _FirestoreImageDAO({required this.id, required this.colorOriginal}): super._();
  factory _FirestoreImageDAO.fromJson(Map<String, dynamic> json) => _$FirestoreImageDAOFromJson(json);

@override final  String id;
@override final  String colorOriginal;

/// Create a copy of FirestoreImageDAO
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FirestoreImageDAOCopyWith<_FirestoreImageDAO> get copyWith => __$FirestoreImageDAOCopyWithImpl<_FirestoreImageDAO>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FirestoreImageDAOToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FirestoreImageDAO&&(identical(other.id, id) || other.id == id)&&(identical(other.colorOriginal, colorOriginal) || other.colorOriginal == colorOriginal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,colorOriginal);

@override
String toString() {
  return 'FirestoreImageDAO(id: $id, colorOriginal: $colorOriginal)';
}


}

/// @nodoc
abstract mixin class _$FirestoreImageDAOCopyWith<$Res> implements $FirestoreImageDAOCopyWith<$Res> {
  factory _$FirestoreImageDAOCopyWith(_FirestoreImageDAO value, $Res Function(_FirestoreImageDAO) _then) = __$FirestoreImageDAOCopyWithImpl;
@override @useResult
$Res call({
 String id, String colorOriginal
});




}
/// @nodoc
class __$FirestoreImageDAOCopyWithImpl<$Res>
    implements _$FirestoreImageDAOCopyWith<$Res> {
  __$FirestoreImageDAOCopyWithImpl(this._self, this._then);

  final _FirestoreImageDAO _self;
  final $Res Function(_FirestoreImageDAO) _then;

/// Create a copy of FirestoreImageDAO
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? colorOriginal = null,}) {
  return _then(_FirestoreImageDAO(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,colorOriginal: null == colorOriginal ? _self.colorOriginal : colorOriginal // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
