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
  String get title => throw _privateConstructorUsedError;
  String get imagePath => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  MapMarkerFrameState get state => throw _privateConstructorUsedError;

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
      String title,
      String imagePath,
      double latitude,
      double longitude,
      MapMarkerFrameState state});
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
    Object? title = null,
    Object? imagePath = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? state = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
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
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as MapMarkerFrameState,
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
      String title,
      String imagePath,
      double latitude,
      double longitude,
      MapMarkerFrameState state});
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
    Object? title = null,
    Object? imagePath = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? state = null,
  }) {
    return _then(_$_MapMarkerViewData(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
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
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as MapMarkerFrameState,
    ));
  }
}

/// @nodoc

class _$_MapMarkerViewData extends _MapMarkerViewData {
  const _$_MapMarkerViewData(
      {required this.id,
      required this.title,
      required this.imagePath,
      required this.latitude,
      required this.longitude,
      required this.state})
      : super._();

  @override
  final String id;
  @override
  final String title;
  @override
  final String imagePath;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final MapMarkerFrameState state;

  @override
  String toString() {
    return 'MapMarkerViewData(id: $id, title: $title, imagePath: $imagePath, latitude: $latitude, longitude: $longitude, state: $state)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_MapMarkerViewData &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.imagePath, imagePath) ||
                other.imagePath == imagePath) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.state, state) || other.state == state));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, id, title, imagePath, latitude, longitude, state);

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
      required final String title,
      required final String imagePath,
      required final double latitude,
      required final double longitude,
      required final MapMarkerFrameState state}) = _$_MapMarkerViewData;
  const _MapMarkerViewData._() : super._();

  @override
  String get id;
  @override
  String get title;
  @override
  String get imagePath;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  MapMarkerFrameState get state;
  @override
  @JsonKey(ignore: true)
  _$$_MapMarkerViewDataCopyWith<_$_MapMarkerViewData> get copyWith =>
      throw _privateConstructorUsedError;
}
