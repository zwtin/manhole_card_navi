// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'map_marker_view_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$MapMarkerViewData {
  String get id => throw _privateConstructorUsedError;
  String get pinImagePath => throw _privateConstructorUsedError;
  String get cardImagePath => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MapMarkerViewDataCopyWith<MapMarkerViewData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MapMarkerViewDataCopyWith<$Res> {
  factory $MapMarkerViewDataCopyWith(
          MapMarkerViewData value, $Res Function(MapMarkerViewData) then) =
      _$MapMarkerViewDataCopyWithImpl<$Res, MapMarkerViewData>;
  @useResult
  $Res call(
      {String id,
      String pinImagePath,
      String cardImagePath,
      double latitude,
      double longitude});
}

/// @nodoc
class _$MapMarkerViewDataCopyWithImpl<$Res, $Val extends MapMarkerViewData>
    implements $MapMarkerViewDataCopyWith<$Res> {
  _$MapMarkerViewDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? pinImagePath = null,
    Object? cardImagePath = null,
    Object? latitude = null,
    Object? longitude = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      pinImagePath: null == pinImagePath
          ? _value.pinImagePath
          : pinImagePath // ignore: cast_nullable_to_non_nullable
              as String,
      cardImagePath: null == cardImagePath
          ? _value.cardImagePath
          : cardImagePath // ignore: cast_nullable_to_non_nullable
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
abstract class _$$_MapMarkerViewDataCopyWith<$Res>
    implements $MapMarkerViewDataCopyWith<$Res> {
  factory _$$_MapMarkerViewDataCopyWith(_$_MapMarkerViewData value,
          $Res Function(_$_MapMarkerViewData) then) =
      __$$_MapMarkerViewDataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String pinImagePath,
      String cardImagePath,
      double latitude,
      double longitude});
}

/// @nodoc
class __$$_MapMarkerViewDataCopyWithImpl<$Res>
    extends _$MapMarkerViewDataCopyWithImpl<$Res, _$_MapMarkerViewData>
    implements _$$_MapMarkerViewDataCopyWith<$Res> {
  __$$_MapMarkerViewDataCopyWithImpl(
      _$_MapMarkerViewData _value, $Res Function(_$_MapMarkerViewData) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? pinImagePath = null,
    Object? cardImagePath = null,
    Object? latitude = null,
    Object? longitude = null,
  }) {
    return _then(_$_MapMarkerViewData(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      pinImagePath: null == pinImagePath
          ? _value.pinImagePath
          : pinImagePath // ignore: cast_nullable_to_non_nullable
              as String,
      cardImagePath: null == cardImagePath
          ? _value.cardImagePath
          : cardImagePath // ignore: cast_nullable_to_non_nullable
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

class _$_MapMarkerViewData extends _MapMarkerViewData {
  const _$_MapMarkerViewData(
      {required this.id,
      required this.pinImagePath,
      required this.cardImagePath,
      required this.latitude,
      required this.longitude})
      : super._();

  @override
  final String id;
  @override
  final String pinImagePath;
  @override
  final String cardImagePath;
  @override
  final double latitude;
  @override
  final double longitude;

  @override
  String toString() {
    return 'MapMarkerViewData(id: $id, pinImagePath: $pinImagePath, cardImagePath: $cardImagePath, latitude: $latitude, longitude: $longitude)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_MapMarkerViewData &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.pinImagePath, pinImagePath) ||
                other.pinImagePath == pinImagePath) &&
            (identical(other.cardImagePath, cardImagePath) ||
                other.cardImagePath == cardImagePath) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, id, pinImagePath, cardImagePath, latitude, longitude);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_MapMarkerViewDataCopyWith<_$_MapMarkerViewData> get copyWith =>
      __$$_MapMarkerViewDataCopyWithImpl<_$_MapMarkerViewData>(
          this, _$identity);
}

abstract class _MapMarkerViewData extends MapMarkerViewData {
  const factory _MapMarkerViewData(
      {required final String id,
      required final String pinImagePath,
      required final String cardImagePath,
      required final double latitude,
      required final double longitude}) = _$_MapMarkerViewData;
  const _MapMarkerViewData._() : super._();

  @override
  String get id;
  @override
  String get pinImagePath;
  @override
  String get cardImagePath;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  @JsonKey(ignore: true)
  _$$_MapMarkerViewDataCopyWith<_$_MapMarkerViewData> get copyWith =>
      throw _privateConstructorUsedError;
}
