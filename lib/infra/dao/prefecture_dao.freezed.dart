// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'prefecture_dao.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

PrefectureDAO _$PrefectureDAOFromJson(Map<String, dynamic> json) {
  return _PrefectureDAO.fromJson(json);
}

/// @nodoc
mixin _$PrefectureDAO {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PrefectureDAOCopyWith<PrefectureDAO> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrefectureDAOCopyWith<$Res> {
  factory $PrefectureDAOCopyWith(
          PrefectureDAO value, $Res Function(PrefectureDAO) then) =
      _$PrefectureDAOCopyWithImpl<$Res, PrefectureDAO>;
  @useResult
  $Res call({String id, String name});
}

/// @nodoc
class _$PrefectureDAOCopyWithImpl<$Res, $Val extends PrefectureDAO>
    implements $PrefectureDAOCopyWith<$Res> {
  _$PrefectureDAOCopyWithImpl(this._value, this._then);

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
abstract class _$$_PrefectureDAOCopyWith<$Res>
    implements $PrefectureDAOCopyWith<$Res> {
  factory _$$_PrefectureDAOCopyWith(
          _$_PrefectureDAO value, $Res Function(_$_PrefectureDAO) then) =
      __$$_PrefectureDAOCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name});
}

/// @nodoc
class __$$_PrefectureDAOCopyWithImpl<$Res>
    extends _$PrefectureDAOCopyWithImpl<$Res, _$_PrefectureDAO>
    implements _$$_PrefectureDAOCopyWith<$Res> {
  __$$_PrefectureDAOCopyWithImpl(
      _$_PrefectureDAO _value, $Res Function(_$_PrefectureDAO) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
  }) {
    return _then(_$_PrefectureDAO(
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
class _$_PrefectureDAO extends _PrefectureDAO {
  const _$_PrefectureDAO({required this.id, required this.name}) : super._();

  factory _$_PrefectureDAO.fromJson(Map<String, dynamic> json) =>
      _$$_PrefectureDAOFromJson(json);

  @override
  final String id;
  @override
  final String name;

  @override
  String toString() {
    return 'PrefectureDAO(id: $id, name: $name)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PrefectureDAO &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PrefectureDAOCopyWith<_$_PrefectureDAO> get copyWith =>
      __$$_PrefectureDAOCopyWithImpl<_$_PrefectureDAO>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PrefectureDAOToJson(
      this,
    );
  }
}

abstract class _PrefectureDAO extends PrefectureDAO {
  const factory _PrefectureDAO(
      {required final String id,
      required final String name}) = _$_PrefectureDAO;
  const _PrefectureDAO._() : super._();

  factory _PrefectureDAO.fromJson(Map<String, dynamic> json) =
      _$_PrefectureDAO.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  @JsonKey(ignore: true)
  _$$_PrefectureDAOCopyWith<_$_PrefectureDAO> get copyWith =>
      throw _privateConstructorUsedError;
}
