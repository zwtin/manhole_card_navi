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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MapMarkerDTO {
  String get cardId => throw _privateConstructorUsedError;
  String get colorImageUrl => throw _privateConstructorUsedError;
  String get grayImageUrl => throw _privateConstructorUsedError;
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
      String colorImageUrl,
      String grayImageUrl,
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
    Object? colorImageUrl = null,
    Object? grayImageUrl = null,
    Object? latitude = null,
    Object? longitude = null,
  }) {
    return _then(_value.copyWith(
      cardId: null == cardId
          ? _value.cardId
          : cardId // ignore: cast_nullable_to_non_nullable
              as String,
      colorImageUrl: null == colorImageUrl
          ? _value.colorImageUrl
          : colorImageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      grayImageUrl: null == grayImageUrl
          ? _value.grayImageUrl
          : grayImageUrl // ignore: cast_nullable_to_non_nullable
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
abstract class _$$MapMarkerDTOImplCopyWith<$Res>
    implements $MapMarkerDTOCopyWith<$Res> {
  factory _$$MapMarkerDTOImplCopyWith(
          _$MapMarkerDTOImpl value, $Res Function(_$MapMarkerDTOImpl) then) =
      __$$MapMarkerDTOImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String cardId,
      String colorImageUrl,
      String grayImageUrl,
      double latitude,
      double longitude});
}

/// @nodoc
class __$$MapMarkerDTOImplCopyWithImpl<$Res>
    extends _$MapMarkerDTOCopyWithImpl<$Res, _$MapMarkerDTOImpl>
    implements _$$MapMarkerDTOImplCopyWith<$Res> {
  __$$MapMarkerDTOImplCopyWithImpl(
      _$MapMarkerDTOImpl _value, $Res Function(_$MapMarkerDTOImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cardId = null,
    Object? colorImageUrl = null,
    Object? grayImageUrl = null,
    Object? latitude = null,
    Object? longitude = null,
  }) {
    return _then(_$MapMarkerDTOImpl(
      cardId: null == cardId
          ? _value.cardId
          : cardId // ignore: cast_nullable_to_non_nullable
              as String,
      colorImageUrl: null == colorImageUrl
          ? _value.colorImageUrl
          : colorImageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      grayImageUrl: null == grayImageUrl
          ? _value.grayImageUrl
          : grayImageUrl // ignore: cast_nullable_to_non_nullable
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

class _$MapMarkerDTOImpl extends _MapMarkerDTO {
  const _$MapMarkerDTOImpl(
      {required this.cardId,
      required this.colorImageUrl,
      required this.grayImageUrl,
      required this.latitude,
      required this.longitude})
      : super._();

  @override
  final String cardId;
  @override
  final String colorImageUrl;
  @override
  final String grayImageUrl;
  @override
  final double latitude;
  @override
  final double longitude;

  @override
  String toString() {
    return 'MapMarkerDTO(cardId: $cardId, colorImageUrl: $colorImageUrl, grayImageUrl: $grayImageUrl, latitude: $latitude, longitude: $longitude)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MapMarkerDTOImpl &&
            (identical(other.cardId, cardId) || other.cardId == cardId) &&
            (identical(other.colorImageUrl, colorImageUrl) ||
                other.colorImageUrl == colorImageUrl) &&
            (identical(other.grayImageUrl, grayImageUrl) ||
                other.grayImageUrl == grayImageUrl) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, cardId, colorImageUrl, grayImageUrl, latitude, longitude);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MapMarkerDTOImplCopyWith<_$MapMarkerDTOImpl> get copyWith =>
      __$$MapMarkerDTOImplCopyWithImpl<_$MapMarkerDTOImpl>(this, _$identity);
}

abstract class _MapMarkerDTO extends MapMarkerDTO {
  const factory _MapMarkerDTO(
      {required final String cardId,
      required final String colorImageUrl,
      required final String grayImageUrl,
      required final double latitude,
      required final double longitude}) = _$MapMarkerDTOImpl;
  const _MapMarkerDTO._() : super._();

  @override
  String get cardId;
  @override
  String get colorImageUrl;
  @override
  String get grayImageUrl;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  @JsonKey(ignore: true)
  _$$MapMarkerDTOImplCopyWith<_$MapMarkerDTOImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
