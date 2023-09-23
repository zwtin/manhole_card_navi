// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'realm_contact_dao.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class RealmContactDAO extends $RealmContactDAO
    with RealmEntity, RealmObjectBase, RealmObject {
  RealmContactDAO(
    String id,
    String address,
    double latitude,
    double longitude,
    String name,
    String other,
    String phoneNumber,
  ) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'address', address);
    RealmObjectBase.set(this, 'latitude', latitude);
    RealmObjectBase.set(this, 'longitude', longitude);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'other', other);
    RealmObjectBase.set(this, 'phoneNumber', phoneNumber);
  }

  RealmContactDAO._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get address => RealmObjectBase.get<String>(this, 'address') as String;
  @override
  set address(String value) => RealmObjectBase.set(this, 'address', value);

  @override
  double get latitude =>
      RealmObjectBase.get<double>(this, 'latitude') as double;
  @override
  set latitude(double value) => RealmObjectBase.set(this, 'latitude', value);

  @override
  double get longitude =>
      RealmObjectBase.get<double>(this, 'longitude') as double;
  @override
  set longitude(double value) => RealmObjectBase.set(this, 'longitude', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  String get other => RealmObjectBase.get<String>(this, 'other') as String;
  @override
  set other(String value) => RealmObjectBase.set(this, 'other', value);

  @override
  String get phoneNumber =>
      RealmObjectBase.get<String>(this, 'phoneNumber') as String;
  @override
  set phoneNumber(String value) =>
      RealmObjectBase.set(this, 'phoneNumber', value);

  @override
  Stream<RealmObjectChanges<RealmContactDAO>> get changes =>
      RealmObjectBase.getChanges<RealmContactDAO>(this);

  @override
  RealmContactDAO freeze() =>
      RealmObjectBase.freezeObject<RealmContactDAO>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(RealmContactDAO._);
    return const SchemaObject(
        ObjectType.realmObject, RealmContactDAO, 'RealmContactDAO', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('address', RealmPropertyType.string),
      SchemaProperty('latitude', RealmPropertyType.double),
      SchemaProperty('longitude', RealmPropertyType.double),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('other', RealmPropertyType.string),
      SchemaProperty('phoneNumber', RealmPropertyType.string),
    ]);
  }
}
