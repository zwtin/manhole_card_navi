// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'realm_image_dao.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
class RealmImageDAO extends $RealmImageDAO
    with RealmEntity, RealmObjectBase, RealmObject {
  RealmImageDAO(String id, String colorOriginal) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'colorOriginal', colorOriginal);
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
  Stream<RealmObjectChanges<RealmImageDAO>> get changes =>
      RealmObjectBase.getChanges<RealmImageDAO>(this);

  @override
  Stream<RealmObjectChanges<RealmImageDAO>> changesFor([
    List<String>? keyPaths,
  ]) => RealmObjectBase.getChangesFor<RealmImageDAO>(this, keyPaths);

  @override
  RealmImageDAO freeze() => RealmObjectBase.freezeObject<RealmImageDAO>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'colorOriginal': colorOriginal.toEJson(),
    };
  }

  static EJsonValue _toEJson(RealmImageDAO value) => value.toEJson();
  static RealmImageDAO _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {'id': EJsonValue id, 'colorOriginal': EJsonValue colorOriginal} =>
        RealmImageDAO(fromEJson(id), fromEJson(colorOriginal)),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(RealmImageDAO._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
      ObjectType.realmObject,
      RealmImageDAO,
      'RealmImageDAO',
      [
        SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
        SchemaProperty('colorOriginal', RealmPropertyType.string),
      ],
    );
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
