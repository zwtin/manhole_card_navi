// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firestore_image_dao.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FirestoreImageDAOImpl _$$FirestoreImageDAOImplFromJson(
        Map<String, dynamic> json) =>
    _$FirestoreImageDAOImpl(
      id: json['id'] as String,
      colorOriginal: json['colorOriginal'] as String,
      colorResized: json['colorResized'] as String,
      colorFrameGreen: json['colorFrameGreen'] as String,
      colorFrameRed: json['colorFrameRed'] as String,
      colorFrameYellow: json['colorFrameYellow'] as String,
      grayOriginal: json['grayOriginal'] as String,
      grayResized: json['grayResized'] as String,
      grayFrameGreen: json['grayFrameGreen'] as String,
      grayFrameRed: json['grayFrameRed'] as String,
      grayFrameYellow: json['grayFrameYellow'] as String,
    );

Map<String, dynamic> _$$FirestoreImageDAOImplToJson(
        _$FirestoreImageDAOImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'colorOriginal': instance.colorOriginal,
      'colorResized': instance.colorResized,
      'colorFrameGreen': instance.colorFrameGreen,
      'colorFrameRed': instance.colorFrameRed,
      'colorFrameYellow': instance.colorFrameYellow,
      'grayOriginal': instance.grayOriginal,
      'grayResized': instance.grayResized,
      'grayFrameGreen': instance.grayFrameGreen,
      'grayFrameRed': instance.grayFrameRed,
      'grayFrameYellow': instance.grayFrameYellow,
    };
