// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firestore_contact_dao.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FirestoreContactDAO _$FirestoreContactDAOFromJson(Map<String, dynamic> json) =>
    _FirestoreContactDAO(
      address: json['address'] as String,
      id: json['id'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      name: json['name'] as String,
      nameUrl: json['nameUrl'] as String,
      other: json['other'] as String,
      phoneNumber: json['phoneNumber'] as String,
      time: json['time'] as String,
      timeOther: json['timeOther'] as String,
    );

Map<String, dynamic> _$FirestoreContactDAOToJson(
  _FirestoreContactDAO instance,
) => <String, dynamic>{
  'address': instance.address,
  'id': instance.id,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'name': instance.name,
  'nameUrl': instance.nameUrl,
  'other': instance.other,
  'phoneNumber': instance.phoneNumber,
  'time': instance.time,
  'timeOther': instance.timeOther,
};
