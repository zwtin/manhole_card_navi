// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'realm_volume_dao.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class RealmVolumeDAO extends $RealmVolumeDAO
    with RealmEntity, RealmObjectBase, RealmObject {
  RealmVolumeDAO(
    String id,
    String name,
  ) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
  }

  RealmVolumeDAO._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  Stream<RealmObjectChanges<RealmVolumeDAO>> get changes =>
      RealmObjectBase.getChanges<RealmVolumeDAO>(this);

  @override
  RealmVolumeDAO freeze() => RealmObjectBase.freezeObject<RealmVolumeDAO>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(RealmVolumeDAO._);
    return const SchemaObject(
        ObjectType.realmObject, RealmVolumeDAO, 'RealmVolumeDAO', [
      SchemaProperty('id', RealmPropertyType.string),
      SchemaProperty('name', RealmPropertyType.string),
    ]);
  }
}
