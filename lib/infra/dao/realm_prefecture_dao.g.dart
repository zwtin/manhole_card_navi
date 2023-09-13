// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'realm_prefecture_dao.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class RealmPrefectureDao extends _RealmPrefectureDao
    with RealmEntity, RealmObjectBase, RealmObject {
  RealmPrefectureDao(
    String id,
    String name,
  ) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
  }

  RealmPrefectureDao._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  Stream<RealmObjectChanges<RealmPrefectureDao>> get changes =>
      RealmObjectBase.getChanges<RealmPrefectureDao>(this);

  @override
  RealmPrefectureDao freeze() =>
      RealmObjectBase.freezeObject<RealmPrefectureDao>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(RealmPrefectureDao._);
    return const SchemaObject(
        ObjectType.realmObject, RealmPrefectureDao, 'RealmPrefectureDao', [
      SchemaProperty('id', RealmPropertyType.string),
      SchemaProperty('name', RealmPropertyType.string),
    ]);
  }
}
