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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MapMarkerViewData {
  String get id => throw _privateConstructorUsedError;
  String get cardId => throw _privateConstructorUsedError;
  Uint8List get icon => throw _privateConstructorUsedError;
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
      String cardId,
      Uint8List icon,
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
    Object? cardId = null,
    Object? icon = null,
    Object? latitude = null,
    Object? longitude = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      cardId: null == cardId
          ? _value.cardId
          : cardId // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as Uint8List,
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
abstract class _$$MapMarkerViewDataImplCopyWith<$Res>
    implements $MapMarkerViewDataCopyWith<$Res> {
  factory _$$MapMarkerViewDataImplCopyWith(_$MapMarkerViewDataImpl value,
          $Res Function(_$MapMarkerViewDataImpl) then) =
      __$$MapMarkerViewDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String cardId,
      Uint8List icon,
      double latitude,
      double longitude});
}

/// @nodoc
class __$$MapMarkerViewDataImplCopyWithImpl<$Res>
    extends _$MapMarkerViewDataCopyWithImpl<$Res, _$MapMarkerViewDataImpl>
    implements _$$MapMarkerViewDataImplCopyWith<$Res> {
  __$$MapMarkerViewDataImplCopyWithImpl(_$MapMarkerViewDataImpl _value,
      $Res Function(_$MapMarkerViewDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? cardId = null,
    Object? icon = null,
    Object? latitude = null,
    Object? longitude = null,
  }) {
    return _then(_$MapMarkerViewDataImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      cardId: null == cardId
          ? _value.cardId
          : cardId // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as Uint8List,
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

class _$MapMarkerViewDataImpl extends _MapMarkerViewData {
  const _$MapMarkerViewDataImpl(
      {required this.id,
      required this.cardId,
      required this.icon,
      required this.latitude,
      required this.longitude})
      : super._();

  @override
  final String id;
  @override
  final String cardId;
  @override
  final Uint8List icon;
  @override
  final double latitude;
  @override
  final double longitude;

  @override
  String toString() {
    return 'MapMarkerViewData(id: $id, cardId: $cardId, icon: $icon, latitude: $latitude, longitude: $longitude)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MapMarkerViewDataImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.cardId, cardId) || other.cardId == cardId) &&
            const DeepCollectionEquality().equals(other.icon, icon) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, cardId,
      const DeepCollectionEquality().hash(icon), latitude, longitude);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MapMarkerViewDataImplCopyWith<_$MapMarkerViewDataImpl> get copyWith =>
      __$$MapMarkerViewDataImplCopyWithImpl<_$MapMarkerViewDataImpl>(
          this, _$identity);
}

abstract class _MapMarkerViewData extends MapMarkerViewData {
  const factory _MapMarkerViewData(
      {required final String id,
      required final String cardId,
      required final Uint8List icon,
      required final double latitude,
      required final double longitude}) = _$MapMarkerViewDataImpl;
  const _MapMarkerViewData._() : super._();

  @override
  String get id;
  @override
  String get cardId;
  @override
  Uint8List get icon;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  @JsonKey(ignore: true)
  _$$MapMarkerViewDataImplCopyWith<_$MapMarkerViewDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
