// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'firestore_card_dao.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

FirestoreCardDAO _$FirestoreCardDAOFromJson(Map<String, dynamic> json) {
  return _FirestoreCardDAO.fromJson(json);
}

/// @nodoc
mixin _$FirestoreCardDAO {
  String get id => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  String get longitude => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get publicationDate => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FirestoreCardDAOCopyWith<FirestoreCardDAO> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FirestoreCardDAOCopyWith<$Res> {
  factory $FirestoreCardDAOCopyWith(
          FirestoreCardDAO value, $Res Function(FirestoreCardDAO) then) =
      _$FirestoreCardDAOCopyWithImpl<$Res, FirestoreCardDAO>;
  @useResult
  $Res call(
      {String id,
      double latitude,
      String longitude,
      String name,
      String publicationDate});
}

/// @nodoc
class _$FirestoreCardDAOCopyWithImpl<$Res, $Val extends FirestoreCardDAO>
    implements $FirestoreCardDAOCopyWith<$Res> {
  _$FirestoreCardDAOCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? name = null,
    Object? publicationDate = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      publicationDate: null == publicationDate
          ? _value.publicationDate
          : publicationDate // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_FirestoreCardDAOCopyWith<$Res>
    implements $FirestoreCardDAOCopyWith<$Res> {
  factory _$$_FirestoreCardDAOCopyWith(
          _$_FirestoreCardDAO value, $Res Function(_$_FirestoreCardDAO) then) =
      __$$_FirestoreCardDAOCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      double latitude,
      String longitude,
      String name,
      String publicationDate});
}

/// @nodoc
class __$$_FirestoreCardDAOCopyWithImpl<$Res>
    extends _$FirestoreCardDAOCopyWithImpl<$Res, _$_FirestoreCardDAO>
    implements _$$_FirestoreCardDAOCopyWith<$Res> {
  __$$_FirestoreCardDAOCopyWithImpl(
      _$_FirestoreCardDAO _value, $Res Function(_$_FirestoreCardDAO) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? name = null,
    Object? publicationDate = null,
  }) {
    return _then(_$_FirestoreCardDAO(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      publicationDate: null == publicationDate
          ? _value.publicationDate
          : publicationDate // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_FirestoreCardDAO extends _FirestoreCardDAO {
  const _$_FirestoreCardDAO(
      {required this.id,
      required this.latitude,
      required this.longitude,
      required this.name,
      required this.publicationDate})
      : super._();

  factory _$_FirestoreCardDAO.fromJson(Map<String, dynamic> json) =>
      _$$_FirestoreCardDAOFromJson(json);

  @override
  final String id;
  @override
  final double latitude;
  @override
  final String longitude;
  @override
  final String name;
  @override
  final String publicationDate;

  @override
  String toString() {
    return 'FirestoreCardDAO(id: $id, latitude: $latitude, longitude: $longitude, name: $name, publicationDate: $publicationDate)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_FirestoreCardDAO &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.publicationDate, publicationDate) ||
                other.publicationDate == publicationDate));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, latitude, longitude, name, publicationDate);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_FirestoreCardDAOCopyWith<_$_FirestoreCardDAO> get copyWith =>
      __$$_FirestoreCardDAOCopyWithImpl<_$_FirestoreCardDAO>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_FirestoreCardDAOToJson(
      this,
    );
  }
}

abstract class _FirestoreCardDAO extends FirestoreCardDAO {
  const factory _FirestoreCardDAO(
      {required final String id,
      required final double latitude,
      required final String longitude,
      required final String name,
      required final String publicationDate}) = _$_FirestoreCardDAO;
  const _FirestoreCardDAO._() : super._();

  factory _FirestoreCardDAO.fromJson(Map<String, dynamic> json) =
      _$_FirestoreCardDAO.fromJson;

  @override
  String get id;
  @override
  double get latitude;
  @override
  String get longitude;
  @override
  String get name;
  @override
  String get publicationDate;
  @override
  @JsonKey(ignore: true)
  _$$_FirestoreCardDAOCopyWith<_$_FirestoreCardDAO> get copyWith =>
      throw _privateConstructorUsedError;
}
