// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'firestore_volume_dao.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

FirestoreVolumeDAO _$FirestoreVolumeDAOFromJson(Map<String, dynamic> json) {
  return _FirestoreVolumeDAO.fromJson(json);
}

/// @nodoc
mixin _$FirestoreVolumeDAO {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FirestoreVolumeDAOCopyWith<FirestoreVolumeDAO> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FirestoreVolumeDAOCopyWith<$Res> {
  factory $FirestoreVolumeDAOCopyWith(
          FirestoreVolumeDAO value, $Res Function(FirestoreVolumeDAO) then) =
      _$FirestoreVolumeDAOCopyWithImpl<$Res, FirestoreVolumeDAO>;
  @useResult
  $Res call({String id, String name});
}

/// @nodoc
class _$FirestoreVolumeDAOCopyWithImpl<$Res, $Val extends FirestoreVolumeDAO>
    implements $FirestoreVolumeDAOCopyWith<$Res> {
  _$FirestoreVolumeDAOCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_FirestoreVolumeDAOCopyWith<$Res>
    implements $FirestoreVolumeDAOCopyWith<$Res> {
  factory _$$_FirestoreVolumeDAOCopyWith(_$_FirestoreVolumeDAO value,
          $Res Function(_$_FirestoreVolumeDAO) then) =
      __$$_FirestoreVolumeDAOCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name});
}

/// @nodoc
class __$$_FirestoreVolumeDAOCopyWithImpl<$Res>
    extends _$FirestoreVolumeDAOCopyWithImpl<$Res, _$_FirestoreVolumeDAO>
    implements _$$_FirestoreVolumeDAOCopyWith<$Res> {
  __$$_FirestoreVolumeDAOCopyWithImpl(
      _$_FirestoreVolumeDAO _value, $Res Function(_$_FirestoreVolumeDAO) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
  }) {
    return _then(_$_FirestoreVolumeDAO(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_FirestoreVolumeDAO extends _FirestoreVolumeDAO {
  const _$_FirestoreVolumeDAO({required this.id, required this.name})
      : super._();

  factory _$_FirestoreVolumeDAO.fromJson(Map<String, dynamic> json) =>
      _$$_FirestoreVolumeDAOFromJson(json);

  @override
  final String id;
  @override
  final String name;

  @override
  String toString() {
    return 'FirestoreVolumeDAO(id: $id, name: $name)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_FirestoreVolumeDAO &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_FirestoreVolumeDAOCopyWith<_$_FirestoreVolumeDAO> get copyWith =>
      __$$_FirestoreVolumeDAOCopyWithImpl<_$_FirestoreVolumeDAO>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_FirestoreVolumeDAOToJson(
      this,
    );
  }
}

abstract class _FirestoreVolumeDAO extends FirestoreVolumeDAO {
  const factory _FirestoreVolumeDAO(
      {required final String id,
      required final String name}) = _$_FirestoreVolumeDAO;
  const _FirestoreVolumeDAO._() : super._();

  factory _FirestoreVolumeDAO.fromJson(Map<String, dynamic> json) =
      _$_FirestoreVolumeDAO.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  @JsonKey(ignore: true)
  _$$_FirestoreVolumeDAOCopyWith<_$_FirestoreVolumeDAO> get copyWith =>
      throw _privateConstructorUsedError;
}
