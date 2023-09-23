// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'firestore_image_dao.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

FirestoreImageDAO _$FirestoreImageDAOFromJson(Map<String, dynamic> json) {
  return _FirestoreImageDAO.fromJson(json);
}

/// @nodoc
mixin _$FirestoreImageDAO {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FirestoreImageDAOCopyWith<FirestoreImageDAO> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FirestoreImageDAOCopyWith<$Res> {
  factory $FirestoreImageDAOCopyWith(
          FirestoreImageDAO value, $Res Function(FirestoreImageDAO) then) =
      _$FirestoreImageDAOCopyWithImpl<$Res, FirestoreImageDAO>;
  @useResult
  $Res call({String id, String name});
}

/// @nodoc
class _$FirestoreImageDAOCopyWithImpl<$Res, $Val extends FirestoreImageDAO>
    implements $FirestoreImageDAOCopyWith<$Res> {
  _$FirestoreImageDAOCopyWithImpl(this._value, this._then);

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
abstract class _$$_FirestoreImageDAOCopyWith<$Res>
    implements $FirestoreImageDAOCopyWith<$Res> {
  factory _$$_FirestoreImageDAOCopyWith(_$_FirestoreImageDAO value,
          $Res Function(_$_FirestoreImageDAO) then) =
      __$$_FirestoreImageDAOCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name});
}

/// @nodoc
class __$$_FirestoreImageDAOCopyWithImpl<$Res>
    extends _$FirestoreImageDAOCopyWithImpl<$Res, _$_FirestoreImageDAO>
    implements _$$_FirestoreImageDAOCopyWith<$Res> {
  __$$_FirestoreImageDAOCopyWithImpl(
      _$_FirestoreImageDAO _value, $Res Function(_$_FirestoreImageDAO) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
  }) {
    return _then(_$_FirestoreImageDAO(
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
class _$_FirestoreImageDAO extends _FirestoreImageDAO {
  const _$_FirestoreImageDAO({required this.id, required this.name})
      : super._();

  factory _$_FirestoreImageDAO.fromJson(Map<String, dynamic> json) =>
      _$$_FirestoreImageDAOFromJson(json);

  @override
  final String id;
  @override
  final String name;

  @override
  String toString() {
    return 'FirestoreImageDAO(id: $id, name: $name)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_FirestoreImageDAO &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_FirestoreImageDAOCopyWith<_$_FirestoreImageDAO> get copyWith =>
      __$$_FirestoreImageDAOCopyWithImpl<_$_FirestoreImageDAO>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_FirestoreImageDAOToJson(
      this,
    );
  }
}

abstract class _FirestoreImageDAO extends FirestoreImageDAO {
  const factory _FirestoreImageDAO(
      {required final String id,
      required final String name}) = _$_FirestoreImageDAO;
  const _FirestoreImageDAO._() : super._();

  factory _FirestoreImageDAO.fromJson(Map<String, dynamic> json) =
      _$_FirestoreImageDAO.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  @JsonKey(ignore: true)
  _$$_FirestoreImageDAOCopyWith<_$_FirestoreImageDAO> get copyWith =>
      throw _privateConstructorUsedError;
}
