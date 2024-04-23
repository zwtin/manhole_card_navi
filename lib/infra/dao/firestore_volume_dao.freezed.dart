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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

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
abstract class _$$FirestoreVolumeDAOImplCopyWith<$Res>
    implements $FirestoreVolumeDAOCopyWith<$Res> {
  factory _$$FirestoreVolumeDAOImplCopyWith(_$FirestoreVolumeDAOImpl value,
          $Res Function(_$FirestoreVolumeDAOImpl) then) =
      __$$FirestoreVolumeDAOImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name});
}

/// @nodoc
class __$$FirestoreVolumeDAOImplCopyWithImpl<$Res>
    extends _$FirestoreVolumeDAOCopyWithImpl<$Res, _$FirestoreVolumeDAOImpl>
    implements _$$FirestoreVolumeDAOImplCopyWith<$Res> {
  __$$FirestoreVolumeDAOImplCopyWithImpl(_$FirestoreVolumeDAOImpl _value,
      $Res Function(_$FirestoreVolumeDAOImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
  }) {
    return _then(_$FirestoreVolumeDAOImpl(
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
class _$FirestoreVolumeDAOImpl extends _FirestoreVolumeDAO {
  const _$FirestoreVolumeDAOImpl({required this.id, required this.name})
      : super._();

  factory _$FirestoreVolumeDAOImpl.fromJson(Map<String, dynamic> json) =>
      _$$FirestoreVolumeDAOImplFromJson(json);

  @override
  final String id;
  @override
  final String name;

  @override
  String toString() {
    return 'FirestoreVolumeDAO(id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FirestoreVolumeDAOImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FirestoreVolumeDAOImplCopyWith<_$FirestoreVolumeDAOImpl> get copyWith =>
      __$$FirestoreVolumeDAOImplCopyWithImpl<_$FirestoreVolumeDAOImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FirestoreVolumeDAOImplToJson(
      this,
    );
  }
}

abstract class _FirestoreVolumeDAO extends FirestoreVolumeDAO {
  const factory _FirestoreVolumeDAO(
      {required final String id,
      required final String name}) = _$FirestoreVolumeDAOImpl;
  const _FirestoreVolumeDAO._() : super._();

  factory _FirestoreVolumeDAO.fromJson(Map<String, dynamic> json) =
      _$FirestoreVolumeDAOImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  @JsonKey(ignore: true)
  _$$FirestoreVolumeDAOImplCopyWith<_$FirestoreVolumeDAOImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
