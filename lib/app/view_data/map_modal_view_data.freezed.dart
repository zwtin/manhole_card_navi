// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'map_modal_view_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$MapModalViewData {
  String get id => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MapModalViewDataCopyWith<MapModalViewData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MapModalViewDataCopyWith<$Res> {
  factory $MapModalViewDataCopyWith(
          MapModalViewData value, $Res Function(MapModalViewData) then) =
      _$MapModalViewDataCopyWithImpl<$Res, MapModalViewData>;
  @useResult
  $Res call({String id, double latitude, double longitude});
}

/// @nodoc
class _$MapModalViewDataCopyWithImpl<$Res, $Val extends MapModalViewData>
    implements $MapModalViewDataCopyWith<$Res> {
  _$MapModalViewDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? latitude = null,
    Object? longitude = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
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
abstract class _$$_MapModalViewDataCopyWith<$Res>
    implements $MapModalViewDataCopyWith<$Res> {
  factory _$$_MapModalViewDataCopyWith(
          _$_MapModalViewData value, $Res Function(_$_MapModalViewData) then) =
      __$$_MapModalViewDataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, double latitude, double longitude});
}

/// @nodoc
class __$$_MapModalViewDataCopyWithImpl<$Res>
    extends _$MapModalViewDataCopyWithImpl<$Res, _$_MapModalViewData>
    implements _$$_MapModalViewDataCopyWith<$Res> {
  __$$_MapModalViewDataCopyWithImpl(
      _$_MapModalViewData _value, $Res Function(_$_MapModalViewData) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? latitude = null,
    Object? longitude = null,
  }) {
    return _then(_$_MapModalViewData(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
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

class _$_MapModalViewData extends _MapModalViewData {
  const _$_MapModalViewData(
      {required this.id, required this.latitude, required this.longitude})
      : super._();

  @override
  final String id;
  @override
  final double latitude;
  @override
  final double longitude;

  @override
  String toString() {
    return 'MapModalViewData(id: $id, latitude: $latitude, longitude: $longitude)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_MapModalViewData &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, latitude, longitude);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_MapModalViewDataCopyWith<_$_MapModalViewData> get copyWith =>
      __$$_MapModalViewDataCopyWithImpl<_$_MapModalViewData>(this, _$identity);
}

abstract class _MapModalViewData extends MapModalViewData {
  const factory _MapModalViewData(
      {required final String id,
      required final double latitude,
      required final double longitude}) = _$_MapModalViewData;
  const _MapModalViewData._() : super._();

  @override
  String get id;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  @JsonKey(ignore: true)
  _$$_MapModalViewDataCopyWith<_$_MapModalViewData> get copyWith =>
      throw _privateConstructorUsedError;
}
