// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'realm_image_dao.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class RealmImageDAO extends $RealmImageDAO
    with RealmEntity, RealmObjectBase, RealmObject {
  RealmImageDAO(
    String id,
    String name,
  ) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
  }

  RealmImageDAO._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  Stream<RealmObjectChanges<RealmImageDAO>> get changes =>
      RealmObjectBase.getChanges<RealmImageDAO>(this);

  @override
  RealmImageDAO freeze() => RealmObjectBase.freezeObject<RealmImageDAO>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(RealmImageDAO._);
    return const SchemaObject(
        ObjectType.realmObject, RealmImageDAO, 'RealmImageDAO', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
    ]);
  }
}
