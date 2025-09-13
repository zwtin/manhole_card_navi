// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'realm_volume_dao.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
class RealmVolumeDAO extends $RealmVolumeDAO
    with RealmEntity, RealmObjectBase, RealmObject {
  RealmVolumeDAO(String id, String name) {
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
  Stream<RealmObjectChanges<RealmVolumeDAO>> changesFor([
    List<String>? keyPaths,
  ]) => RealmObjectBase.getChangesFor<RealmVolumeDAO>(this, keyPaths);

  @override
  RealmVolumeDAO freeze() => RealmObjectBase.freezeObject<RealmVolumeDAO>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{'id': id.toEJson(), 'name': name.toEJson()};
  }

  static EJsonValue _toEJson(RealmVolumeDAO value) => value.toEJson();
  static RealmVolumeDAO _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {'id': EJsonValue id, 'name': EJsonValue name} => RealmVolumeDAO(
        fromEJson(id),
        fromEJson(name),
      ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(RealmVolumeDAO._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
      ObjectType.realmObject,
      RealmVolumeDAO,
      'RealmVolumeDAO',
      [
        SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
        SchemaProperty('name', RealmPropertyType.string),
      ],
    );
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
