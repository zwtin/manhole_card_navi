// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'firestore_distribution_dao.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

FirestoreDistributionDAO _$FirestoreDistributionDAOFromJson(
    Map<String, dynamic> json) {
  return _FirestoreDistributionDAO.fromJson(json);
}

/// @nodoc
mixin _$FirestoreDistributionDAO {
  String get id => throw _privateConstructorUsedError;
  String get other => throw _privateConstructorUsedError;
  String get state => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FirestoreDistributionDAOCopyWith<FirestoreDistributionDAO> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FirestoreDistributionDAOCopyWith<$Res> {
  factory $FirestoreDistributionDAOCopyWith(FirestoreDistributionDAO value,
          $Res Function(FirestoreDistributionDAO) then) =
      _$FirestoreDistributionDAOCopyWithImpl<$Res, FirestoreDistributionDAO>;
  @useResult
  $Res call({String id, String other, String state});
}

/// @nodoc
class _$FirestoreDistributionDAOCopyWithImpl<$Res,
        $Val extends FirestoreDistributionDAO>
    implements $FirestoreDistributionDAOCopyWith<$Res> {
  _$FirestoreDistributionDAOCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? other = null,
    Object? state = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      other: null == other
          ? _value.other
          : other // ignore: cast_nullable_to_non_nullable
              as String,
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_FirestoreDistributionDAOCopyWith<$Res>
    implements $FirestoreDistributionDAOCopyWith<$Res> {
  factory _$$_FirestoreDistributionDAOCopyWith(
          _$_FirestoreDistributionDAO value,
          $Res Function(_$_FirestoreDistributionDAO) then) =
      __$$_FirestoreDistributionDAOCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String other, String state});
}

/// @nodoc
class __$$_FirestoreDistributionDAOCopyWithImpl<$Res>
    extends _$FirestoreDistributionDAOCopyWithImpl<$Res,
        _$_FirestoreDistributionDAO>
    implements _$$_FirestoreDistributionDAOCopyWith<$Res> {
  __$$_FirestoreDistributionDAOCopyWithImpl(_$_FirestoreDistributionDAO _value,
      $Res Function(_$_FirestoreDistributionDAO) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? other = null,
    Object? state = null,
  }) {
    return _then(_$_FirestoreDistributionDAO(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      other: null == other
          ? _value.other
          : other // ignore: cast_nullable_to_non_nullable
              as String,
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_FirestoreDistributionDAO extends _FirestoreDistributionDAO {
  const _$_FirestoreDistributionDAO(
      {required this.id, required this.other, required this.state})
      : super._();

  factory _$_FirestoreDistributionDAO.fromJson(Map<String, dynamic> json) =>
      _$$_FirestoreDistributionDAOFromJson(json);

  @override
  final String id;
  @override
  final String other;
  @override
  final String state;

  @override
  String toString() {
    return 'FirestoreDistributionDAO(id: $id, other: $other, state: $state)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_FirestoreDistributionDAO &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.other, this.other) || other.other == this.other) &&
            (identical(other.state, state) || other.state == state));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, other, state);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_FirestoreDistributionDAOCopyWith<_$_FirestoreDistributionDAO>
      get copyWith => __$$_FirestoreDistributionDAOCopyWithImpl<
          _$_FirestoreDistributionDAO>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_FirestoreDistributionDAOToJson(
      this,
    );
  }
}

abstract class _FirestoreDistributionDAO extends FirestoreDistributionDAO {
  const factory _FirestoreDistributionDAO(
      {required final String id,
      required final String other,
      required final String state}) = _$_FirestoreDistributionDAO;
  const _FirestoreDistributionDAO._() : super._();

  factory _FirestoreDistributionDAO.fromJson(Map<String, dynamic> json) =
      _$_FirestoreDistributionDAO.fromJson;

  @override
  String get id;
  @override
  String get other;
  @override
  String get state;
  @override
  @JsonKey(ignore: true)
  _$$_FirestoreDistributionDAOCopyWith<_$_FirestoreDistributionDAO>
      get copyWith => throw _privateConstructorUsedError;
}
