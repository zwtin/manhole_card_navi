// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'manhole_card.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ManholeCard {

 String get id; double get latitude; double get longitude; String get name; DateTime get publicationDate; ManholeCardDistributionState get distributionState; String get distributionLinkText; String get distributionLinkUrl; String get distributionText; String get distributionOther; ManholeCardContacts get contacts; ManholeCardImage get image; ManholeCardPrefecture get prefecture; ManholeCardVolume get volume;
/// Create a copy of ManholeCard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ManholeCardCopyWith<ManholeCard> get copyWith => _$ManholeCardCopyWithImpl<ManholeCard>(this as ManholeCard, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ManholeCard&&(identical(other.id, id) || other.id == id)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.name, name) || other.name == name)&&(identical(other.publicationDate, publicationDate) || other.publicationDate == publicationDate)&&(identical(other.distributionState, distributionState) || other.distributionState == distributionState)&&(identical(other.distributionLinkText, distributionLinkText) || other.distributionLinkText == distributionLinkText)&&(identical(other.distributionLinkUrl, distributionLinkUrl) || other.distributionLinkUrl == distributionLinkUrl)&&(identical(other.distributionText, distributionText) || other.distributionText == distributionText)&&(identical(other.distributionOther, distributionOther) || other.distributionOther == distributionOther)&&(identical(other.contacts, contacts) || other.contacts == contacts)&&(identical(other.image, image) || other.image == image)&&(identical(other.prefecture, prefecture) || other.prefecture == prefecture)&&(identical(other.volume, volume) || other.volume == volume));
}


@override
int get hashCode => Object.hash(runtimeType,id,latitude,longitude,name,publicationDate,distributionState,distributionLinkText,distributionLinkUrl,distributionText,distributionOther,contacts,image,prefecture,volume);

@override
String toString() {
  return 'ManholeCard(id: $id, latitude: $latitude, longitude: $longitude, name: $name, publicationDate: $publicationDate, distributionState: $distributionState, distributionLinkText: $distributionLinkText, distributionLinkUrl: $distributionLinkUrl, distributionText: $distributionText, distributionOther: $distributionOther, contacts: $contacts, image: $image, prefecture: $prefecture, volume: $volume)';
}


}

/// @nodoc
abstract mixin class $ManholeCardCopyWith<$Res>  {
  factory $ManholeCardCopyWith(ManholeCard value, $Res Function(ManholeCard) _then) = _$ManholeCardCopyWithImpl;
@useResult
$Res call({
 String id, double latitude, double longitude, String name, DateTime publicationDate, ManholeCardDistributionState distributionState, String distributionLinkText, String distributionLinkUrl, String distributionText, String distributionOther, ManholeCardContacts contacts, ManholeCardImage image, ManholeCardPrefecture prefecture, ManholeCardVolume volume
});


$ManholeCardContactsCopyWith<$Res> get contacts;$ManholeCardImageCopyWith<$Res> get image;$ManholeCardPrefectureCopyWith<$Res> get prefecture;$ManholeCardVolumeCopyWith<$Res> get volume;

}
/// @nodoc
class _$ManholeCardCopyWithImpl<$Res>
    implements $ManholeCardCopyWith<$Res> {
  _$ManholeCardCopyWithImpl(this._self, this._then);

  final ManholeCard _self;
  final $Res Function(ManholeCard) _then;

/// Create a copy of ManholeCard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? latitude = null,Object? longitude = null,Object? name = null,Object? publicationDate = null,Object? distributionState = null,Object? distributionLinkText = null,Object? distributionLinkUrl = null,Object? distributionText = null,Object? distributionOther = null,Object? contacts = null,Object? image = null,Object? prefecture = null,Object? volume = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,publicationDate: null == publicationDate ? _self.publicationDate : publicationDate // ignore: cast_nullable_to_non_nullable
as DateTime,distributionState: null == distributionState ? _self.distributionState : distributionState // ignore: cast_nullable_to_non_nullable
as ManholeCardDistributionState,distributionLinkText: null == distributionLinkText ? _self.distributionLinkText : distributionLinkText // ignore: cast_nullable_to_non_nullable
as String,distributionLinkUrl: null == distributionLinkUrl ? _self.distributionLinkUrl : distributionLinkUrl // ignore: cast_nullable_to_non_nullable
as String,distributionText: null == distributionText ? _self.distributionText : distributionText // ignore: cast_nullable_to_non_nullable
as String,distributionOther: null == distributionOther ? _self.distributionOther : distributionOther // ignore: cast_nullable_to_non_nullable
as String,contacts: null == contacts ? _self.contacts : contacts // ignore: cast_nullable_to_non_nullable
as ManholeCardContacts,image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as ManholeCardImage,prefecture: null == prefecture ? _self.prefecture : prefecture // ignore: cast_nullable_to_non_nullable
as ManholeCardPrefecture,volume: null == volume ? _self.volume : volume // ignore: cast_nullable_to_non_nullable
as ManholeCardVolume,
  ));
}
/// Create a copy of ManholeCard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ManholeCardContactsCopyWith<$Res> get contacts {
  
  return $ManholeCardContactsCopyWith<$Res>(_self.contacts, (value) {
    return _then(_self.copyWith(contacts: value));
  });
}/// Create a copy of ManholeCard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ManholeCardImageCopyWith<$Res> get image {
  
  return $ManholeCardImageCopyWith<$Res>(_self.image, (value) {
    return _then(_self.copyWith(image: value));
  });
}/// Create a copy of ManholeCard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ManholeCardPrefectureCopyWith<$Res> get prefecture {
  
  return $ManholeCardPrefectureCopyWith<$Res>(_self.prefecture, (value) {
    return _then(_self.copyWith(prefecture: value));
  });
}/// Create a copy of ManholeCard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ManholeCardVolumeCopyWith<$Res> get volume {
  
  return $ManholeCardVolumeCopyWith<$Res>(_self.volume, (value) {
    return _then(_self.copyWith(volume: value));
  });
}
}


/// @nodoc


class _ManholeCard extends ManholeCard {
  const _ManholeCard({required this.id, required this.latitude, required this.longitude, required this.name, required this.publicationDate, required this.distributionState, required this.distributionLinkText, required this.distributionLinkUrl, required this.distributionText, required this.distributionOther, required this.contacts, required this.image, required this.prefecture, required this.volume}): super._();
  

@override final  String id;
@override final  double latitude;
@override final  double longitude;
@override final  String name;
@override final  DateTime publicationDate;
@override final  ManholeCardDistributionState distributionState;
@override final  String distributionLinkText;
@override final  String distributionLinkUrl;
@override final  String distributionText;
@override final  String distributionOther;
@override final  ManholeCardContacts contacts;
@override final  ManholeCardImage image;
@override final  ManholeCardPrefecture prefecture;
@override final  ManholeCardVolume volume;

/// Create a copy of ManholeCard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ManholeCardCopyWith<_ManholeCard> get copyWith => __$ManholeCardCopyWithImpl<_ManholeCard>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ManholeCard&&(identical(other.id, id) || other.id == id)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.name, name) || other.name == name)&&(identical(other.publicationDate, publicationDate) || other.publicationDate == publicationDate)&&(identical(other.distributionState, distributionState) || other.distributionState == distributionState)&&(identical(other.distributionLinkText, distributionLinkText) || other.distributionLinkText == distributionLinkText)&&(identical(other.distributionLinkUrl, distributionLinkUrl) || other.distributionLinkUrl == distributionLinkUrl)&&(identical(other.distributionText, distributionText) || other.distributionText == distributionText)&&(identical(other.distributionOther, distributionOther) || other.distributionOther == distributionOther)&&(identical(other.contacts, contacts) || other.contacts == contacts)&&(identical(other.image, image) || other.image == image)&&(identical(other.prefecture, prefecture) || other.prefecture == prefecture)&&(identical(other.volume, volume) || other.volume == volume));
}


@override
int get hashCode => Object.hash(runtimeType,id,latitude,longitude,name,publicationDate,distributionState,distributionLinkText,distributionLinkUrl,distributionText,distributionOther,contacts,image,prefecture,volume);

@override
String toString() {
  return 'ManholeCard(id: $id, latitude: $latitude, longitude: $longitude, name: $name, publicationDate: $publicationDate, distributionState: $distributionState, distributionLinkText: $distributionLinkText, distributionLinkUrl: $distributionLinkUrl, distributionText: $distributionText, distributionOther: $distributionOther, contacts: $contacts, image: $image, prefecture: $prefecture, volume: $volume)';
}


}

/// @nodoc
abstract mixin class _$ManholeCardCopyWith<$Res> implements $ManholeCardCopyWith<$Res> {
  factory _$ManholeCardCopyWith(_ManholeCard value, $Res Function(_ManholeCard) _then) = __$ManholeCardCopyWithImpl;
@override @useResult
$Res call({
 String id, double latitude, double longitude, String name, DateTime publicationDate, ManholeCardDistributionState distributionState, String distributionLinkText, String distributionLinkUrl, String distributionText, String distributionOther, ManholeCardContacts contacts, ManholeCardImage image, ManholeCardPrefecture prefecture, ManholeCardVolume volume
});


@override $ManholeCardContactsCopyWith<$Res> get contacts;@override $ManholeCardImageCopyWith<$Res> get image;@override $ManholeCardPrefectureCopyWith<$Res> get prefecture;@override $ManholeCardVolumeCopyWith<$Res> get volume;

}
/// @nodoc
class __$ManholeCardCopyWithImpl<$Res>
    implements _$ManholeCardCopyWith<$Res> {
  __$ManholeCardCopyWithImpl(this._self, this._then);

  final _ManholeCard _self;
  final $Res Function(_ManholeCard) _then;

/// Create a copy of ManholeCard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? latitude = null,Object? longitude = null,Object? name = null,Object? publicationDate = null,Object? distributionState = null,Object? distributionLinkText = null,Object? distributionLinkUrl = null,Object? distributionText = null,Object? distributionOther = null,Object? contacts = null,Object? image = null,Object? prefecture = null,Object? volume = null,}) {
  return _then(_ManholeCard(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,publicationDate: null == publicationDate ? _self.publicationDate : publicationDate // ignore: cast_nullable_to_non_nullable
as DateTime,distributionState: null == distributionState ? _self.distributionState : distributionState // ignore: cast_nullable_to_non_nullable
as ManholeCardDistributionState,distributionLinkText: null == distributionLinkText ? _self.distributionLinkText : distributionLinkText // ignore: cast_nullable_to_non_nullable
as String,distributionLinkUrl: null == distributionLinkUrl ? _self.distributionLinkUrl : distributionLinkUrl // ignore: cast_nullable_to_non_nullable
as String,distributionText: null == distributionText ? _self.distributionText : distributionText // ignore: cast_nullable_to_non_nullable
as String,distributionOther: null == distributionOther ? _self.distributionOther : distributionOther // ignore: cast_nullable_to_non_nullable
as String,contacts: null == contacts ? _self.contacts : contacts // ignore: cast_nullable_to_non_nullable
as ManholeCardContacts,image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as ManholeCardImage,prefecture: null == prefecture ? _self.prefecture : prefecture // ignore: cast_nullable_to_non_nullable
as ManholeCardPrefecture,volume: null == volume ? _self.volume : volume // ignore: cast_nullable_to_non_nullable
as ManholeCardVolume,
  ));
}

/// Create a copy of ManholeCard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ManholeCardContactsCopyWith<$Res> get contacts {
  
  return $ManholeCardContactsCopyWith<$Res>(_self.contacts, (value) {
    return _then(_self.copyWith(contacts: value));
  });
}/// Create a copy of ManholeCard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ManholeCardImageCopyWith<$Res> get image {
  
  return $ManholeCardImageCopyWith<$Res>(_self.image, (value) {
    return _then(_self.copyWith(image: value));
  });
}/// Create a copy of ManholeCard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ManholeCardPrefectureCopyWith<$Res> get prefecture {
  
  return $ManholeCardPrefectureCopyWith<$Res>(_self.prefecture, (value) {
    return _then(_self.copyWith(prefecture: value));
  });
}/// Create a copy of ManholeCard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ManholeCardVolumeCopyWith<$Res> get volume {
  
  return $ManholeCardVolumeCopyWith<$Res>(_self.volume, (value) {
    return _then(_self.copyWith(volume: value));
  });
}
}

// dart format on
