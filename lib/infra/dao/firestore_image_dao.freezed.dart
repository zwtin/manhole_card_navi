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

 String get id; String get colorOriginal; String get colorResized; String get colorFrameGreen; String get colorFrameRed; String get colorFrameYellow; String get grayOriginal; String get grayResized; String get grayFrameGreen; String get grayFrameRed; String get grayFrameYellow;
/// Create a copy of FirestoreImageDAO
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FirestoreImageDAOCopyWith<FirestoreImageDAO> get copyWith => _$FirestoreImageDAOCopyWithImpl<FirestoreImageDAO>(this as FirestoreImageDAO, _$identity);

  /// Serializes this FirestoreImageDAO to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FirestoreImageDAO&&(identical(other.id, id) || other.id == id)&&(identical(other.colorOriginal, colorOriginal) || other.colorOriginal == colorOriginal)&&(identical(other.colorResized, colorResized) || other.colorResized == colorResized)&&(identical(other.colorFrameGreen, colorFrameGreen) || other.colorFrameGreen == colorFrameGreen)&&(identical(other.colorFrameRed, colorFrameRed) || other.colorFrameRed == colorFrameRed)&&(identical(other.colorFrameYellow, colorFrameYellow) || other.colorFrameYellow == colorFrameYellow)&&(identical(other.grayOriginal, grayOriginal) || other.grayOriginal == grayOriginal)&&(identical(other.grayResized, grayResized) || other.grayResized == grayResized)&&(identical(other.grayFrameGreen, grayFrameGreen) || other.grayFrameGreen == grayFrameGreen)&&(identical(other.grayFrameRed, grayFrameRed) || other.grayFrameRed == grayFrameRed)&&(identical(other.grayFrameYellow, grayFrameYellow) || other.grayFrameYellow == grayFrameYellow));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,colorOriginal,colorResized,colorFrameGreen,colorFrameRed,colorFrameYellow,grayOriginal,grayResized,grayFrameGreen,grayFrameRed,grayFrameYellow);

@override
String toString() {
  return 'FirestoreImageDAO(id: $id, colorOriginal: $colorOriginal, colorResized: $colorResized, colorFrameGreen: $colorFrameGreen, colorFrameRed: $colorFrameRed, colorFrameYellow: $colorFrameYellow, grayOriginal: $grayOriginal, grayResized: $grayResized, grayFrameGreen: $grayFrameGreen, grayFrameRed: $grayFrameRed, grayFrameYellow: $grayFrameYellow)';
}


}

/// @nodoc
abstract mixin class $FirestoreImageDAOCopyWith<$Res>  {
  factory $FirestoreImageDAOCopyWith(FirestoreImageDAO value, $Res Function(FirestoreImageDAO) _then) = _$FirestoreImageDAOCopyWithImpl;
@useResult
$Res call({
 String id, String colorOriginal, String colorResized, String colorFrameGreen, String colorFrameRed, String colorFrameYellow, String grayOriginal, String grayResized, String grayFrameGreen, String grayFrameRed, String grayFrameYellow
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? colorOriginal = null,Object? colorResized = null,Object? colorFrameGreen = null,Object? colorFrameRed = null,Object? colorFrameYellow = null,Object? grayOriginal = null,Object? grayResized = null,Object? grayFrameGreen = null,Object? grayFrameRed = null,Object? grayFrameYellow = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,colorOriginal: null == colorOriginal ? _self.colorOriginal : colorOriginal // ignore: cast_nullable_to_non_nullable
as String,colorResized: null == colorResized ? _self.colorResized : colorResized // ignore: cast_nullable_to_non_nullable
as String,colorFrameGreen: null == colorFrameGreen ? _self.colorFrameGreen : colorFrameGreen // ignore: cast_nullable_to_non_nullable
as String,colorFrameRed: null == colorFrameRed ? _self.colorFrameRed : colorFrameRed // ignore: cast_nullable_to_non_nullable
as String,colorFrameYellow: null == colorFrameYellow ? _self.colorFrameYellow : colorFrameYellow // ignore: cast_nullable_to_non_nullable
as String,grayOriginal: null == grayOriginal ? _self.grayOriginal : grayOriginal // ignore: cast_nullable_to_non_nullable
as String,grayResized: null == grayResized ? _self.grayResized : grayResized // ignore: cast_nullable_to_non_nullable
as String,grayFrameGreen: null == grayFrameGreen ? _self.grayFrameGreen : grayFrameGreen // ignore: cast_nullable_to_non_nullable
as String,grayFrameRed: null == grayFrameRed ? _self.grayFrameRed : grayFrameRed // ignore: cast_nullable_to_non_nullable
as String,grayFrameYellow: null == grayFrameYellow ? _self.grayFrameYellow : grayFrameYellow // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _FirestoreImageDAO extends FirestoreImageDAO {
  const _FirestoreImageDAO({required this.id, required this.colorOriginal, required this.colorResized, required this.colorFrameGreen, required this.colorFrameRed, required this.colorFrameYellow, required this.grayOriginal, required this.grayResized, required this.grayFrameGreen, required this.grayFrameRed, required this.grayFrameYellow}): super._();
  factory _FirestoreImageDAO.fromJson(Map<String, dynamic> json) => _$FirestoreImageDAOFromJson(json);

@override final  String id;
@override final  String colorOriginal;
@override final  String colorResized;
@override final  String colorFrameGreen;
@override final  String colorFrameRed;
@override final  String colorFrameYellow;
@override final  String grayOriginal;
@override final  String grayResized;
@override final  String grayFrameGreen;
@override final  String grayFrameRed;
@override final  String grayFrameYellow;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FirestoreImageDAO&&(identical(other.id, id) || other.id == id)&&(identical(other.colorOriginal, colorOriginal) || other.colorOriginal == colorOriginal)&&(identical(other.colorResized, colorResized) || other.colorResized == colorResized)&&(identical(other.colorFrameGreen, colorFrameGreen) || other.colorFrameGreen == colorFrameGreen)&&(identical(other.colorFrameRed, colorFrameRed) || other.colorFrameRed == colorFrameRed)&&(identical(other.colorFrameYellow, colorFrameYellow) || other.colorFrameYellow == colorFrameYellow)&&(identical(other.grayOriginal, grayOriginal) || other.grayOriginal == grayOriginal)&&(identical(other.grayResized, grayResized) || other.grayResized == grayResized)&&(identical(other.grayFrameGreen, grayFrameGreen) || other.grayFrameGreen == grayFrameGreen)&&(identical(other.grayFrameRed, grayFrameRed) || other.grayFrameRed == grayFrameRed)&&(identical(other.grayFrameYellow, grayFrameYellow) || other.grayFrameYellow == grayFrameYellow));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,colorOriginal,colorResized,colorFrameGreen,colorFrameRed,colorFrameYellow,grayOriginal,grayResized,grayFrameGreen,grayFrameRed,grayFrameYellow);

@override
String toString() {
  return 'FirestoreImageDAO(id: $id, colorOriginal: $colorOriginal, colorResized: $colorResized, colorFrameGreen: $colorFrameGreen, colorFrameRed: $colorFrameRed, colorFrameYellow: $colorFrameYellow, grayOriginal: $grayOriginal, grayResized: $grayResized, grayFrameGreen: $grayFrameGreen, grayFrameRed: $grayFrameRed, grayFrameYellow: $grayFrameYellow)';
}


}

/// @nodoc
abstract mixin class _$FirestoreImageDAOCopyWith<$Res> implements $FirestoreImageDAOCopyWith<$Res> {
  factory _$FirestoreImageDAOCopyWith(_FirestoreImageDAO value, $Res Function(_FirestoreImageDAO) _then) = __$FirestoreImageDAOCopyWithImpl;
@override @useResult
$Res call({
 String id, String colorOriginal, String colorResized, String colorFrameGreen, String colorFrameRed, String colorFrameYellow, String grayOriginal, String grayResized, String grayFrameGreen, String grayFrameRed, String grayFrameYellow
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? colorOriginal = null,Object? colorResized = null,Object? colorFrameGreen = null,Object? colorFrameRed = null,Object? colorFrameYellow = null,Object? grayOriginal = null,Object? grayResized = null,Object? grayFrameGreen = null,Object? grayFrameRed = null,Object? grayFrameYellow = null,}) {
  return _then(_FirestoreImageDAO(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,colorOriginal: null == colorOriginal ? _self.colorOriginal : colorOriginal // ignore: cast_nullable_to_non_nullable
as String,colorResized: null == colorResized ? _self.colorResized : colorResized // ignore: cast_nullable_to_non_nullable
as String,colorFrameGreen: null == colorFrameGreen ? _self.colorFrameGreen : colorFrameGreen // ignore: cast_nullable_to_non_nullable
as String,colorFrameRed: null == colorFrameRed ? _self.colorFrameRed : colorFrameRed // ignore: cast_nullable_to_non_nullable
as String,colorFrameYellow: null == colorFrameYellow ? _self.colorFrameYellow : colorFrameYellow // ignore: cast_nullable_to_non_nullable
as String,grayOriginal: null == grayOriginal ? _self.grayOriginal : grayOriginal // ignore: cast_nullable_to_non_nullable
as String,grayResized: null == grayResized ? _self.grayResized : grayResized // ignore: cast_nullable_to_non_nullable
as String,grayFrameGreen: null == grayFrameGreen ? _self.grayFrameGreen : grayFrameGreen // ignore: cast_nullable_to_non_nullable
as String,grayFrameRed: null == grayFrameRed ? _self.grayFrameRed : grayFrameRed // ignore: cast_nullable_to_non_nullable
as String,grayFrameYellow: null == grayFrameYellow ? _self.grayFrameYellow : grayFrameYellow // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
