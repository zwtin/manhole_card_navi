// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'realm_image_dao.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class RealmImageDAO extends $RealmImageDAO
    with RealmEntity, RealmObjectBase, RealmObject {
  RealmImageDAO(
    String id,
    String colorOriginal,
    String colorResized,
    String colorFrameGreen,
    String colorFrameRed,
    String colorFrameYellow,
    String grayOriginal,
    String grayResized,
    String grayFrameGreen,
    String grayFrameRed,
    String grayFrameYellow,
  ) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'colorOriginal', colorOriginal);
    RealmObjectBase.set(this, 'colorResized', colorResized);
    RealmObjectBase.set(this, 'colorFrameGreen', colorFrameGreen);
    RealmObjectBase.set(this, 'colorFrameRed', colorFrameRed);
    RealmObjectBase.set(this, 'colorFrameYellow', colorFrameYellow);
    RealmObjectBase.set(this, 'grayOriginal', grayOriginal);
    RealmObjectBase.set(this, 'grayResized', grayResized);
    RealmObjectBase.set(this, 'grayFrameGreen', grayFrameGreen);
    RealmObjectBase.set(this, 'grayFrameRed', grayFrameRed);
    RealmObjectBase.set(this, 'grayFrameYellow', grayFrameYellow);
  }

  RealmImageDAO._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get colorOriginal =>
      RealmObjectBase.get<String>(this, 'colorOriginal') as String;
  @override
  set colorOriginal(String value) =>
      RealmObjectBase.set(this, 'colorOriginal', value);

  @override
  String get colorResized =>
      RealmObjectBase.get<String>(this, 'colorResized') as String;
  @override
  set colorResized(String value) =>
      RealmObjectBase.set(this, 'colorResized', value);

  @override
  String get colorFrameGreen =>
      RealmObjectBase.get<String>(this, 'colorFrameGreen') as String;
  @override
  set colorFrameGreen(String value) =>
      RealmObjectBase.set(this, 'colorFrameGreen', value);

  @override
  String get colorFrameRed =>
      RealmObjectBase.get<String>(this, 'colorFrameRed') as String;
  @override
  set colorFrameRed(String value) =>
      RealmObjectBase.set(this, 'colorFrameRed', value);

  @override
  String get colorFrameYellow =>
      RealmObjectBase.get<String>(this, 'colorFrameYellow') as String;
  @override
  set colorFrameYellow(String value) =>
      RealmObjectBase.set(this, 'colorFrameYellow', value);

  @override
  String get grayOriginal =>
      RealmObjectBase.get<String>(this, 'grayOriginal') as String;
  @override
  set grayOriginal(String value) =>
      RealmObjectBase.set(this, 'grayOriginal', value);

  @override
  String get grayResized =>
      RealmObjectBase.get<String>(this, 'grayResized') as String;
  @override
  set grayResized(String value) =>
      RealmObjectBase.set(this, 'grayResized', value);

  @override
  String get grayFrameGreen =>
      RealmObjectBase.get<String>(this, 'grayFrameGreen') as String;
  @override
  set grayFrameGreen(String value) =>
      RealmObjectBase.set(this, 'grayFrameGreen', value);

  @override
  String get grayFrameRed =>
      RealmObjectBase.get<String>(this, 'grayFrameRed') as String;
  @override
  set grayFrameRed(String value) =>
      RealmObjectBase.set(this, 'grayFrameRed', value);

  @override
  String get grayFrameYellow =>
      RealmObjectBase.get<String>(this, 'grayFrameYellow') as String;
  @override
  set grayFrameYellow(String value) =>
      RealmObjectBase.set(this, 'grayFrameYellow', value);

  @override
  Stream<RealmObjectChanges<RealmImageDAO>> get changes =>
      RealmObjectBase.getChanges<RealmImageDAO>(this);

  @override
  RealmImageDAO freeze() => RealmObjectBase.freezeObject<RealmImageDAO>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'colorOriginal': colorOriginal.toEJson(),
      'colorResized': colorResized.toEJson(),
      'colorFrameGreen': colorFrameGreen.toEJson(),
      'colorFrameRed': colorFrameRed.toEJson(),
      'colorFrameYellow': colorFrameYellow.toEJson(),
      'grayOriginal': grayOriginal.toEJson(),
      'grayResized': grayResized.toEJson(),
      'grayFrameGreen': grayFrameGreen.toEJson(),
      'grayFrameRed': grayFrameRed.toEJson(),
      'grayFrameYellow': grayFrameYellow.toEJson(),
    };
  }

  static EJsonValue _toEJson(RealmImageDAO value) => value.toEJson();
  static RealmImageDAO _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'colorOriginal': EJsonValue colorOriginal,
        'colorResized': EJsonValue colorResized,
        'colorFrameGreen': EJsonValue colorFrameGreen,
        'colorFrameRed': EJsonValue colorFrameRed,
        'colorFrameYellow': EJsonValue colorFrameYellow,
        'grayOriginal': EJsonValue grayOriginal,
        'grayResized': EJsonValue grayResized,
        'grayFrameGreen': EJsonValue grayFrameGreen,
        'grayFrameRed': EJsonValue grayFrameRed,
        'grayFrameYellow': EJsonValue grayFrameYellow,
      } =>
        RealmImageDAO(
          fromEJson(id),
          fromEJson(colorOriginal),
          fromEJson(colorResized),
          fromEJson(colorFrameGreen),
          fromEJson(colorFrameRed),
          fromEJson(colorFrameYellow),
          fromEJson(grayOriginal),
          fromEJson(grayResized),
          fromEJson(grayFrameGreen),
          fromEJson(grayFrameRed),
          fromEJson(grayFrameYellow),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(RealmImageDAO._);
    register(_toEJson, _fromEJson);
    return SchemaObject(
        ObjectType.realmObject, RealmImageDAO, 'RealmImageDAO', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('colorOriginal', RealmPropertyType.string),
      SchemaProperty('colorResized', RealmPropertyType.string),
      SchemaProperty('colorFrameGreen', RealmPropertyType.string),
      SchemaProperty('colorFrameRed', RealmPropertyType.string),
      SchemaProperty('colorFrameYellow', RealmPropertyType.string),
      SchemaProperty('grayOriginal', RealmPropertyType.string),
      SchemaProperty('grayResized', RealmPropertyType.string),
      SchemaProperty('grayFrameGreen', RealmPropertyType.string),
      SchemaProperty('grayFrameRed', RealmPropertyType.string),
      SchemaProperty('grayFrameYellow', RealmPropertyType.string),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
