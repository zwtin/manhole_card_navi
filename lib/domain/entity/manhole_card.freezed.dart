// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'manhole_card.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ManholeCard {
  String get id => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  DateTime get publicationDate => throw _privateConstructorUsedError;
  ManholeCardDistributionState get distributionState =>
      throw _privateConstructorUsedError;
  String get distributionLinkText => throw _privateConstructorUsedError;
  String get distributionLinkUrl => throw _privateConstructorUsedError;
  String get distributionText => throw _privateConstructorUsedError;
  String get distributionOther => throw _privateConstructorUsedError;
  ManholeCardContacts get contacts => throw _privateConstructorUsedError;
  ManholeCardImage get image => throw _privateConstructorUsedError;
  ManholeCardPrefecture get prefecture => throw _privateConstructorUsedError;
  ManholeCardVolume get volume => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ManholeCardCopyWith<ManholeCard> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ManholeCardCopyWith<$Res> {
  factory $ManholeCardCopyWith(
          ManholeCard value, $Res Function(ManholeCard) then) =
      _$ManholeCardCopyWithImpl<$Res, ManholeCard>;
  @useResult
  $Res call(
      {String id,
      double latitude,
      double longitude,
      String name,
      DateTime publicationDate,
      ManholeCardDistributionState distributionState,
      String distributionLinkText,
      String distributionLinkUrl,
      String distributionText,
      String distributionOther,
      ManholeCardContacts contacts,
      ManholeCardImage image,
      ManholeCardPrefecture prefecture,
      ManholeCardVolume volume});

  $ManholeCardContactsCopyWith<$Res> get contacts;
  $ManholeCardImageCopyWith<$Res> get image;
  $ManholeCardPrefectureCopyWith<$Res> get prefecture;
  $ManholeCardVolumeCopyWith<$Res> get volume;
}

/// @nodoc
class _$ManholeCardCopyWithImpl<$Res, $Val extends ManholeCard>
    implements $ManholeCardCopyWith<$Res> {
  _$ManholeCardCopyWithImpl(this._value, this._then);

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
    Object? name = null,
    Object? publicationDate = null,
    Object? distributionState = null,
    Object? distributionLinkText = null,
    Object? distributionLinkUrl = null,
    Object? distributionText = null,
    Object? distributionOther = null,
    Object? contacts = null,
    Object? image = null,
    Object? prefecture = null,
    Object? volume = null,
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
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      publicationDate: null == publicationDate
          ? _value.publicationDate
          : publicationDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      distributionState: null == distributionState
          ? _value.distributionState
          : distributionState // ignore: cast_nullable_to_non_nullable
              as ManholeCardDistributionState,
      distributionLinkText: null == distributionLinkText
          ? _value.distributionLinkText
          : distributionLinkText // ignore: cast_nullable_to_non_nullable
              as String,
      distributionLinkUrl: null == distributionLinkUrl
          ? _value.distributionLinkUrl
          : distributionLinkUrl // ignore: cast_nullable_to_non_nullable
              as String,
      distributionText: null == distributionText
          ? _value.distributionText
          : distributionText // ignore: cast_nullable_to_non_nullable
              as String,
      distributionOther: null == distributionOther
          ? _value.distributionOther
          : distributionOther // ignore: cast_nullable_to_non_nullable
              as String,
      contacts: null == contacts
          ? _value.contacts
          : contacts // ignore: cast_nullable_to_non_nullable
              as ManholeCardContacts,
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as ManholeCardImage,
      prefecture: null == prefecture
          ? _value.prefecture
          : prefecture // ignore: cast_nullable_to_non_nullable
              as ManholeCardPrefecture,
      volume: null == volume
          ? _value.volume
          : volume // ignore: cast_nullable_to_non_nullable
              as ManholeCardVolume,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ManholeCardContactsCopyWith<$Res> get contacts {
    return $ManholeCardContactsCopyWith<$Res>(_value.contacts, (value) {
      return _then(_value.copyWith(contacts: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ManholeCardImageCopyWith<$Res> get image {
    return $ManholeCardImageCopyWith<$Res>(_value.image, (value) {
      return _then(_value.copyWith(image: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ManholeCardPrefectureCopyWith<$Res> get prefecture {
    return $ManholeCardPrefectureCopyWith<$Res>(_value.prefecture, (value) {
      return _then(_value.copyWith(prefecture: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ManholeCardVolumeCopyWith<$Res> get volume {
    return $ManholeCardVolumeCopyWith<$Res>(_value.volume, (value) {
      return _then(_value.copyWith(volume: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ManholeCardImplCopyWith<$Res>
    implements $ManholeCardCopyWith<$Res> {
  factory _$$ManholeCardImplCopyWith(
          _$ManholeCardImpl value, $Res Function(_$ManholeCardImpl) then) =
      __$$ManholeCardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      double latitude,
      double longitude,
      String name,
      DateTime publicationDate,
      ManholeCardDistributionState distributionState,
      String distributionLinkText,
      String distributionLinkUrl,
      String distributionText,
      String distributionOther,
      ManholeCardContacts contacts,
      ManholeCardImage image,
      ManholeCardPrefecture prefecture,
      ManholeCardVolume volume});

  @override
  $ManholeCardContactsCopyWith<$Res> get contacts;
  @override
  $ManholeCardImageCopyWith<$Res> get image;
  @override
  $ManholeCardPrefectureCopyWith<$Res> get prefecture;
  @override
  $ManholeCardVolumeCopyWith<$Res> get volume;
}

/// @nodoc
class __$$ManholeCardImplCopyWithImpl<$Res>
    extends _$ManholeCardCopyWithImpl<$Res, _$ManholeCardImpl>
    implements _$$ManholeCardImplCopyWith<$Res> {
  __$$ManholeCardImplCopyWithImpl(
      _$ManholeCardImpl _value, $Res Function(_$ManholeCardImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? name = null,
    Object? publicationDate = null,
    Object? distributionState = null,
    Object? distributionLinkText = null,
    Object? distributionLinkUrl = null,
    Object? distributionText = null,
    Object? distributionOther = null,
    Object? contacts = null,
    Object? image = null,
    Object? prefecture = null,
    Object? volume = null,
  }) {
    return _then(_$ManholeCardImpl(
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
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      publicationDate: null == publicationDate
          ? _value.publicationDate
          : publicationDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      distributionState: null == distributionState
          ? _value.distributionState
          : distributionState // ignore: cast_nullable_to_non_nullable
              as ManholeCardDistributionState,
      distributionLinkText: null == distributionLinkText
          ? _value.distributionLinkText
          : distributionLinkText // ignore: cast_nullable_to_non_nullable
              as String,
      distributionLinkUrl: null == distributionLinkUrl
          ? _value.distributionLinkUrl
          : distributionLinkUrl // ignore: cast_nullable_to_non_nullable
              as String,
      distributionText: null == distributionText
          ? _value.distributionText
          : distributionText // ignore: cast_nullable_to_non_nullable
              as String,
      distributionOther: null == distributionOther
          ? _value.distributionOther
          : distributionOther // ignore: cast_nullable_to_non_nullable
              as String,
      contacts: null == contacts
          ? _value.contacts
          : contacts // ignore: cast_nullable_to_non_nullable
              as ManholeCardContacts,
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as ManholeCardImage,
      prefecture: null == prefecture
          ? _value.prefecture
          : prefecture // ignore: cast_nullable_to_non_nullable
              as ManholeCardPrefecture,
      volume: null == volume
          ? _value.volume
          : volume // ignore: cast_nullable_to_non_nullable
              as ManholeCardVolume,
    ));
  }
}

/// @nodoc

class _$ManholeCardImpl extends _ManholeCard {
  const _$ManholeCardImpl(
      {required this.id,
      required this.latitude,
      required this.longitude,
      required this.name,
      required this.publicationDate,
      required this.distributionState,
      required this.distributionLinkText,
      required this.distributionLinkUrl,
      required this.distributionText,
      required this.distributionOther,
      required this.contacts,
      required this.image,
      required this.prefecture,
      required this.volume})
      : super._();

  @override
  final String id;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final String name;
  @override
  final DateTime publicationDate;
  @override
  final ManholeCardDistributionState distributionState;
  @override
  final String distributionLinkText;
  @override
  final String distributionLinkUrl;
  @override
  final String distributionText;
  @override
  final String distributionOther;
  @override
  final ManholeCardContacts contacts;
  @override
  final ManholeCardImage image;
  @override
  final ManholeCardPrefecture prefecture;
  @override
  final ManholeCardVolume volume;

  @override
  String toString() {
    return 'ManholeCard(id: $id, latitude: $latitude, longitude: $longitude, name: $name, publicationDate: $publicationDate, distributionState: $distributionState, distributionLinkText: $distributionLinkText, distributionLinkUrl: $distributionLinkUrl, distributionText: $distributionText, distributionOther: $distributionOther, contacts: $contacts, image: $image, prefecture: $prefecture, volume: $volume)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ManholeCardImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.publicationDate, publicationDate) ||
                other.publicationDate == publicationDate) &&
            (identical(other.distributionState, distributionState) ||
                other.distributionState == distributionState) &&
            (identical(other.distributionLinkText, distributionLinkText) ||
                other.distributionLinkText == distributionLinkText) &&
            (identical(other.distributionLinkUrl, distributionLinkUrl) ||
                other.distributionLinkUrl == distributionLinkUrl) &&
            (identical(other.distributionText, distributionText) ||
                other.distributionText == distributionText) &&
            (identical(other.distributionOther, distributionOther) ||
                other.distributionOther == distributionOther) &&
            (identical(other.contacts, contacts) ||
                other.contacts == contacts) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.prefecture, prefecture) ||
                other.prefecture == prefecture) &&
            (identical(other.volume, volume) || other.volume == volume));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      latitude,
      longitude,
      name,
      publicationDate,
      distributionState,
      distributionLinkText,
      distributionLinkUrl,
      distributionText,
      distributionOther,
      contacts,
      image,
      prefecture,
      volume);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ManholeCardImplCopyWith<_$ManholeCardImpl> get copyWith =>
      __$$ManholeCardImplCopyWithImpl<_$ManholeCardImpl>(this, _$identity);
}

abstract class _ManholeCard extends ManholeCard {
  const factory _ManholeCard(
      {required final String id,
      required final double latitude,
      required final double longitude,
      required final String name,
      required final DateTime publicationDate,
      required final ManholeCardDistributionState distributionState,
      required final String distributionLinkText,
      required final String distributionLinkUrl,
      required final String distributionText,
      required final String distributionOther,
      required final ManholeCardContacts contacts,
      required final ManholeCardImage image,
      required final ManholeCardPrefecture prefecture,
      required final ManholeCardVolume volume}) = _$ManholeCardImpl;
  const _ManholeCard._() : super._();

  @override
  String get id;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  String get name;
  @override
  DateTime get publicationDate;
  @override
  ManholeCardDistributionState get distributionState;
  @override
  String get distributionLinkText;
  @override
  String get distributionLinkUrl;
  @override
  String get distributionText;
  @override
  String get distributionOther;
  @override
  ManholeCardContacts get contacts;
  @override
  ManholeCardImage get image;
  @override
  ManholeCardPrefecture get prefecture;
  @override
  ManholeCardVolume get volume;
  @override
  @JsonKey(ignore: true)
  _$$ManholeCardImplCopyWith<_$ManholeCardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
