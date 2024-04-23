// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'realm_prefecture_dao.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class RealmPrefectureDAO extends $RealmPrefectureDAO
    with RealmEntity, RealmObjectBase, RealmObject {
  RealmPrefectureDAO(
    String id,
    String name,
  ) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
  }

  RealmPrefectureDAO._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  Stream<RealmObjectChanges<RealmPrefectureDAO>> get changes =>
      RealmObjectBase.getChanges<RealmPrefectureDAO>(this);

  @override
  RealmPrefectureDAO freeze() =>
      RealmObjectBase.freezeObject<RealmPrefectureDAO>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'name': name.toEJson(),
    };
  }

  static EJsonValue _toEJson(RealmPrefectureDAO value) => value.toEJson();
  static RealmPrefectureDAO _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'name': EJsonValue name,
      } =>
        RealmPrefectureDAO(
          fromEJson(id),
          fromEJson(name),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(RealmPrefectureDAO._);
    register(_toEJson, _fromEJson);
    return SchemaObject(
        ObjectType.realmObject, RealmPrefectureDAO, 'RealmPrefectureDAO', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
