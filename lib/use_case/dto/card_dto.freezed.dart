// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'card_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$CardDTO {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get imagePath => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CardDTOCopyWith<CardDTO> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CardDTOCopyWith<$Res> {
  factory $CardDTOCopyWith(CardDTO value, $Res Function(CardDTO) then) =
      _$CardDTOCopyWithImpl<$Res, CardDTO>;
  @useResult
  $Res call(
      {String id,
      String name,
      String imagePath,
      double latitude,
      double longitude});
}

/// @nodoc
class _$CardDTOCopyWithImpl<$Res, $Val extends CardDTO>
    implements $CardDTOCopyWith<$Res> {
  _$CardDTOCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? imagePath = null,
    Object? latitude = null,
    Object? longitude = null,
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
      imagePath: null == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_CardDTOCopyWith<$Res> implements $CardDTOCopyWith<$Res> {
  factory _$$_CardDTOCopyWith(
          _$_CardDTO value, $Res Function(_$_CardDTO) then) =
      __$$_CardDTOCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String imagePath,
      double latitude,
      double longitude});
}

/// @nodoc
class __$$_CardDTOCopyWithImpl<$Res>
    extends _$CardDTOCopyWithImpl<$Res, _$_CardDTO>
    implements _$$_CardDTOCopyWith<$Res> {
  __$$_CardDTOCopyWithImpl(_$_CardDTO _value, $Res Function(_$_CardDTO) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? imagePath = null,
    Object? latitude = null,
    Object? longitude = null,
  }) {
    return _then(_$_CardDTO(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      imagePath: null == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$_CardDTO extends _CardDTO {
  const _$_CardDTO(
      {required this.id,
      required this.name,
      required this.imagePath,
      required this.latitude,
      required this.longitude})
      : super._();

  @override
  final String id;
  @override
  final String name;
  @override
  final String imagePath;
  @override
  final double latitude;
  @override
  final double longitude;

  @override
  String toString() {
    return 'CardDTO(id: $id, name: $name, imagePath: $imagePath, latitude: $latitude, longitude: $longitude)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CardDTO &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.imagePath, imagePath) ||
                other.imagePath == imagePath) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, imagePath, latitude, longitude);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_CardDTOCopyWith<_$_CardDTO> get copyWith =>
      __$$_CardDTOCopyWithImpl<_$_CardDTO>(this, _$identity);
}

abstract class _CardDTO extends CardDTO {
  const factory _CardDTO(
      {required final String id,
      required final String name,
      required final String imagePath,
      required final double latitude,
      required final double longitude}) = _$_CardDTO;
  const _CardDTO._() : super._();

  @override
  String get id;
  @override
  String get name;
  @override
  String get imagePath;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  @JsonKey(ignore: true)
  _$$_CardDTOCopyWith<_$_CardDTO> get copyWith =>
      throw _privateConstructorUsedError;
}
