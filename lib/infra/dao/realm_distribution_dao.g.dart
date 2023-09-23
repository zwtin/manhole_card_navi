// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'realm_distribution_dao.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class RealmDistributionDAO extends $RealmDistributionDAO
    with RealmEntity, RealmObjectBase, RealmObject {
  RealmDistributionDAO(
    String id,
    String other,
    String state,
  ) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'other', other);
    RealmObjectBase.set(this, 'state', state);
  }

  RealmDistributionDAO._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get other => RealmObjectBase.get<String>(this, 'other') as String;
  @override
  set other(String value) => RealmObjectBase.set(this, 'other', value);

  @override
  String get state => RealmObjectBase.get<String>(this, 'state') as String;
  @override
  set state(String value) => RealmObjectBase.set(this, 'state', value);

  @override
  Stream<RealmObjectChanges<RealmDistributionDAO>> get changes =>
      RealmObjectBase.getChanges<RealmDistributionDAO>(this);

  @override
  RealmDistributionDAO freeze() =>
      RealmObjectBase.freezeObject<RealmDistributionDAO>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(RealmDistributionDAO._);
    return const SchemaObject(
        ObjectType.realmObject, RealmDistributionDAO, 'RealmDistributionDAO', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('other', RealmPropertyType.string),
      SchemaProperty('state', RealmPropertyType.string),
    ]);
  }
}
