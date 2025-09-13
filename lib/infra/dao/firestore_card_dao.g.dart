// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firestore_card_dao.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FirestoreCardDAO _$FirestoreCardDAOFromJson(Map<String, dynamic> json) =>
    _FirestoreCardDAO(
      id: json['id'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      name: json['name'] as String,
      publicationDate: json['publicationDate'] as String,
      imageId: json['imageId'] as String,
      prefectureId: json['prefectureId'] as String,
      volumeId: json['volumeId'] as String,
      distributionState: json['distributionState'] as String,
      distributionLinkText: json['distributionLinkText'] as String,
      distributionLinkUrl: json['distributionLinkUrl'] as String,
      distributionText: json['distributionText'] as String,
      distributionOther: json['distributionOther'] as String,
    );

Map<String, dynamic> _$FirestoreCardDAOToJson(_FirestoreCardDAO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'name': instance.name,
      'publicationDate': instance.publicationDate,
      'imageId': instance.imageId,
      'prefectureId': instance.prefectureId,
      'volumeId': instance.volumeId,
      'distributionState': instance.distributionState,
      'distributionLinkText': instance.distributionLinkText,
      'distributionLinkUrl': instance.distributionLinkUrl,
      'distributionText': instance.distributionText,
      'distributionOther': instance.distributionOther,
    };
