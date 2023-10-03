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
  String get title => throw _privateConstructorUsedError;
  String get cardImagePath => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  MapCardState get state => throw _privateConstructorUsedError;

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
      String title,
      String cardImagePath,
      double latitude,
      double longitude,
      MapCardState state});
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
    Object? title = null,
    Object? cardImagePath = null,
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
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as MapCardState,
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
      String title,
      String cardImagePath,
      double latitude,
      double longitude,
      MapCardState state});
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
    Object? title = null,
    Object? cardImagePath = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? state = null,
  }) {
    return _then(_$_MapCardDTO(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
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
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as MapCardState,
    ));
  }
}

/// @nodoc

class _$_MapCardDTO extends _MapCardDTO {
  const _$_MapCardDTO(
      {required this.id,
      required this.title,
      required this.cardImagePath,
      required this.latitude,
      required this.longitude,
      required this.state})
      : super._();

  @override
  final String id;
  @override
  final String title;
  @override
  final String cardImagePath;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final MapCardState state;

  @override
  String toString() {
    return 'MapCardDTO(id: $id, title: $title, cardImagePath: $cardImagePath, latitude: $latitude, longitude: $longitude, state: $state)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_MapCardDTO &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.cardImagePath, cardImagePath) ||
                other.cardImagePath == cardImagePath) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.state, state) || other.state == state));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, id, title, cardImagePath, latitude, longitude, state);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_MapCardDTOCopyWith<_$_MapCardDTO> get copyWith =>
      __$$_MapCardDTOCopyWithImpl<_$_MapCardDTO>(this, _$identity);
}

abstract class _MapCardDTO extends MapCardDTO {
  const factory _MapCardDTO(
      {required final String id,
      required final String title,
      required final String cardImagePath,
      required final double latitude,
      required final double longitude,
      required final MapCardState state}) = _$_MapCardDTO;
  const _MapCardDTO._() : super._();

  @override
  String get id;
  @override
  String get title;
  @override
  String get cardImagePath;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  MapCardState get state;
  @override
  @JsonKey(ignore: true)
  _$$_MapCardDTOCopyWith<_$_MapCardDTO> get copyWith =>
      throw _privateConstructorUsedError;
}
