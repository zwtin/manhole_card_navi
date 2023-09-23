// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firestore_card_dao.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_FirestoreCardDAO _$$_FirestoreCardDAOFromJson(Map<String, dynamic> json) =>
    _$_FirestoreCardDAO(
      id: json['id'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: json['longitude'] as String,
      name: json['name'] as String,
      publicationDate: json['publicationDate'] as String,
    );

Map<String, dynamic> _$$_FirestoreCardDAOToJson(_$_FirestoreCardDAO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'name': instance.name,
      'publicationDate': instance.publicationDate,
    };
