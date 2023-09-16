// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'firestore_prefecture_dao.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

FirestorePrefectureDAO _$FirestorePrefectureDAOFromJson(
    Map<String, dynamic> json) {
  return _FirestorePrefectureDAO.fromJson(json);
}

/// @nodoc
mixin _$FirestorePrefectureDAO {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FirestorePrefectureDAOCopyWith<FirestorePrefectureDAO> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FirestorePrefectureDAOCopyWith<$Res> {
  factory $FirestorePrefectureDAOCopyWith(FirestorePrefectureDAO value,
          $Res Function(FirestorePrefectureDAO) then) =
      _$FirestorePrefectureDAOCopyWithImpl<$Res, FirestorePrefectureDAO>;
  @useResult
  $Res call({String id, String name});
}

/// @nodoc
class _$FirestorePrefectureDAOCopyWithImpl<$Res,
        $Val extends FirestorePrefectureDAO>
    implements $FirestorePrefectureDAOCopyWith<$Res> {
  _$FirestorePrefectureDAOCopyWithImpl(this._value, this._then);

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
abstract class _$$_FirestorePrefectureDAOCopyWith<$Res>
    implements $FirestorePrefectureDAOCopyWith<$Res> {
  factory _$$_FirestorePrefectureDAOCopyWith(_$_FirestorePrefectureDAO value,
          $Res Function(_$_FirestorePrefectureDAO) then) =
      __$$_FirestorePrefectureDAOCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name});
}

/// @nodoc
class __$$_FirestorePrefectureDAOCopyWithImpl<$Res>
    extends _$FirestorePrefectureDAOCopyWithImpl<$Res,
        _$_FirestorePrefectureDAO>
    implements _$$_FirestorePrefectureDAOCopyWith<$Res> {
  __$$_FirestorePrefectureDAOCopyWithImpl(_$_FirestorePrefectureDAO _value,
      $Res Function(_$_FirestorePrefectureDAO) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
  }) {
    return _then(_$_FirestorePrefectureDAO(
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
class _$_FirestorePrefectureDAO extends _FirestorePrefectureDAO {
  const _$_FirestorePrefectureDAO({required this.id, required this.name})
      : super._();

  factory _$_FirestorePrefectureDAO.fromJson(Map<String, dynamic> json) =>
      _$$_FirestorePrefectureDAOFromJson(json);

  @override
  final String id;
  @override
  final String name;

  @override
  String toString() {
    return 'FirestorePrefectureDAO(id: $id, name: $name)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_FirestorePrefectureDAO &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_FirestorePrefectureDAOCopyWith<_$_FirestorePrefectureDAO> get copyWith =>
      __$$_FirestorePrefectureDAOCopyWithImpl<_$_FirestorePrefectureDAO>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_FirestorePrefectureDAOToJson(
      this,
    );
  }
}

abstract class _FirestorePrefectureDAO extends FirestorePrefectureDAO {
  const factory _FirestorePrefectureDAO(
      {required final String id,
      required final String name}) = _$_FirestorePrefectureDAO;
  const _FirestorePrefectureDAO._() : super._();

  factory _FirestorePrefectureDAO.fromJson(Map<String, dynamic> json) =
      _$_FirestorePrefectureDAO.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  @JsonKey(ignore: true)
  _$$_FirestorePrefectureDAOCopyWith<_$_FirestorePrefectureDAO> get copyWith =>
      throw _privateConstructorUsedError;
}
