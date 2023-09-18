// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'realm_prefecture_dao.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class RealmPrefectureDAO extends _RealmPrefectureDAO
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

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(RealmPrefectureDAO._);
    return const SchemaObject(
        ObjectType.realmObject, RealmPrefectureDAO, 'RealmPrefectureDAO', [
      SchemaProperty('id', RealmPropertyType.string),
      SchemaProperty('name', RealmPropertyType.string),
    ]);
  }
}
