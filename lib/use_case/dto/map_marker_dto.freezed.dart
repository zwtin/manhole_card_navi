// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'map_marker_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$MapMarkerDTO {
  String get cardId => throw _privateConstructorUsedError;
  String get imagePath => throw _privateConstructorUsedError;
  DistributionStateDTO get distributionState =>
      throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MapMarkerDTOCopyWith<MapMarkerDTO> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MapMarkerDTOCopyWith<$Res> {
  factory $MapMarkerDTOCopyWith(
          MapMarkerDTO value, $Res Function(MapMarkerDTO) then) =
      _$MapMarkerDTOCopyWithImpl<$Res, MapMarkerDTO>;
  @useResult
  $Res call(
      {String cardId,
      String imagePath,
      DistributionStateDTO distributionState,
      double latitude,
      double longitude});
}

/// @nodoc
class _$MapMarkerDTOCopyWithImpl<$Res, $Val extends MapMarkerDTO>
    implements $MapMarkerDTOCopyWith<$Res> {
  _$MapMarkerDTOCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cardId = null,
    Object? imagePath = null,
    Object? distributionState = null,
    Object? latitude = null,
    Object? longitude = null,
  }) {
    return _then(_value.copyWith(
      cardId: null == cardId
          ? _value.cardId
          : cardId // ignore: cast_nullable_to_non_nullable
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
abstract class _$$_MapMarkerDTOCopyWith<$Res>
    implements $MapMarkerDTOCopyWith<$Res> {
  factory _$$_MapMarkerDTOCopyWith(
          _$_MapMarkerDTO value, $Res Function(_$_MapMarkerDTO) then) =
      __$$_MapMarkerDTOCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String cardId,
      String imagePath,
      DistributionStateDTO distributionState,
      double latitude,
      double longitude});
}

/// @nodoc
class __$$_MapMarkerDTOCopyWithImpl<$Res>
    extends _$MapMarkerDTOCopyWithImpl<$Res, _$_MapMarkerDTO>
    implements _$$_MapMarkerDTOCopyWith<$Res> {
  __$$_MapMarkerDTOCopyWithImpl(
      _$_MapMarkerDTO _value, $Res Function(_$_MapMarkerDTO) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cardId = null,
    Object? imagePath = null,
    Object? distributionState = null,
    Object? latitude = null,
    Object? longitude = null,
  }) {
    return _then(_$_MapMarkerDTO(
      cardId: null == cardId
          ? _value.cardId
          : cardId // ignore: cast_nullable_to_non_nullable
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

class _$_MapMarkerDTO extends _MapMarkerDTO {
  const _$_MapMarkerDTO(
      {required this.cardId,
      required this.imagePath,
      required this.distributionState,
      required this.latitude,
      required this.longitude})
      : super._();

  @override
  final String cardId;
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
    return 'MapMarkerDTO(cardId: $cardId, imagePath: $imagePath, distributionState: $distributionState, latitude: $latitude, longitude: $longitude)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_MapMarkerDTO &&
            (identical(other.cardId, cardId) || other.cardId == cardId) &&
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
      runtimeType, cardId, imagePath, distributionState, latitude, longitude);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_MapMarkerDTOCopyWith<_$_MapMarkerDTO> get copyWith =>
      __$$_MapMarkerDTOCopyWithImpl<_$_MapMarkerDTO>(this, _$identity);
}

abstract class _MapMarkerDTO extends MapMarkerDTO {
  const factory _MapMarkerDTO(
      {required final String cardId,
      required final String imagePath,
      required final DistributionStateDTO distributionState,
      required final double latitude,
      required final double longitude}) = _$_MapMarkerDTO;
  const _MapMarkerDTO._() : super._();

  @override
  String get cardId;
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
  _$$_MapMarkerDTOCopyWith<_$_MapMarkerDTO> get copyWith =>
      throw _privateConstructorUsedError;
}
