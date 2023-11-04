// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'map_card_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$MapCardDTO {
  String get id => throw _privateConstructorUsedError;
  String get imagePath => throw _privateConstructorUsedError;
  DistributionStateDTO get distributionState =>
      throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MapCardDTOCopyWith<MapCardDTO> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MapCardDTOCopyWith<$Res> {
  factory $MapCardDTOCopyWith(
          MapCardDTO value, $Res Function(MapCardDTO) then) =
      _$MapCardDTOCopyWithImpl<$Res, MapCardDTO>;
  @useResult
  $Res call(
      {String id,
      String imagePath,
      DistributionStateDTO distributionState,
      double latitude,
      double longitude});
}

/// @nodoc
class _$MapCardDTOCopyWithImpl<$Res, $Val extends MapCardDTO>
    implements $MapCardDTOCopyWith<$Res> {
  _$MapCardDTOCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? imagePath = null,
    Object? distributionState = null,
    Object? latitude = null,
    Object? longitude = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      imagePath: null == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String,
      distributionState: null == distributionState
          ? _value.distributionState
          : distributionState // ignore: cast_nullable_to_non_nullable
              as DistributionStateDTO,
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
abstract class _$$_MapCardDTOCopyWith<$Res>
    implements $MapCardDTOCopyWith<$Res> {
  factory _$$_MapCardDTOCopyWith(
          _$_MapCardDTO value, $Res Function(_$_MapCardDTO) then) =
      __$$_MapCardDTOCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String imagePath,
      DistributionStateDTO distributionState,
      double latitude,
      double longitude});
}

/// @nodoc
class __$$_MapCardDTOCopyWithImpl<$Res>
    extends _$MapCardDTOCopyWithImpl<$Res, _$_MapCardDTO>
    implements _$$_MapCardDTOCopyWith<$Res> {
  __$$_MapCardDTOCopyWithImpl(
      _$_MapCardDTO _value, $Res Function(_$_MapCardDTO) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? imagePath = null,
    Object? distributionState = null,
    Object? latitude = null,
    Object? longitude = null,
  }) {
    return _then(_$_MapCardDTO(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      imagePath: null == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String,
      distributionState: null == distributionState
          ? _value.distributionState
          : distributionState // ignore: cast_nullable_to_non_nullable
              as DistributionStateDTO,
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

class _$_MapCardDTO extends _MapCardDTO {
  const _$_MapCardDTO(
      {required this.id,
      required this.imagePath,
      required this.distributionState,
      required this.latitude,
      required this.longitude})
      : super._();

  @override
  final String id;
  @override
  final String imagePath;
  @override
  final DistributionStateDTO distributionState;
  @override
  final double latitude;
  @override
  final double longitude;

  @override
  String toString() {
    return 'MapCardDTO(id: $id, imagePath: $imagePath, distributionState: $distributionState, latitude: $latitude, longitude: $longitude)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_MapCardDTO &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.imagePath, imagePath) ||
                other.imagePath == imagePath) &&
            (identical(other.distributionState, distributionState) ||
                other.distributionState == distributionState) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, id, imagePath, distributionState, latitude, longitude);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_MapCardDTOCopyWith<_$_MapCardDTO> get copyWith =>
      __$$_MapCardDTOCopyWithImpl<_$_MapCardDTO>(this, _$identity);
}

abstract class _MapCardDTO extends MapCardDTO {
  const factory _MapCardDTO(
      {required final String id,
      required final String imagePath,
      required final DistributionStateDTO distributionState,
      required final double latitude,
      required final double longitude}) = _$_MapCardDTO;
  const _MapCardDTO._() : super._();

  @override
  String get id;
  @override
  String get imagePath;
  @override
  DistributionStateDTO get distributionState;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  @JsonKey(ignore: true)
  _$$_MapCardDTOCopyWith<_$_MapCardDTO> get copyWith =>
      throw _privateConstructorUsedError;
}
