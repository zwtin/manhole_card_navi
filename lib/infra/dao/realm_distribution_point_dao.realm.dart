// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'realm_distribution_point_dao.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
class RealmDistributionPointDAO extends $RealmDistributionPointDAO
    with RealmEntity, RealmObjectBase, EmbeddedObject {
  RealmDistributionPointDAO(double latitude, double longitude) {
    RealmObjectBase.set(this, 'latitude', latitude);
    RealmObjectBase.set(this, 'longitude', longitude);
  }

  RealmDistributionPointDAO._();

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
  Stream<RealmObjectChanges<RealmDistributionPointDAO>> get changes =>
      RealmObjectBase.getChanges<RealmDistributionPointDAO>(this);

  @override
  Stream<RealmObjectChanges<RealmDistributionPointDAO>> changesFor([
    List<String>? keyPaths,
  ]) =>
      RealmObjectBase.getChangesFor<RealmDistributionPointDAO>(this, keyPaths);

  @override
  RealmDistributionPointDAO freeze() =>
      RealmObjectBase.freezeObject<RealmDistributionPointDAO>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'latitude': latitude.toEJson(),
      'longitude': longitude.toEJson(),
    };
  }

  static EJsonValue _toEJson(RealmDistributionPointDAO value) =>
      value.toEJson();
  static RealmDistributionPointDAO _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {'latitude': EJsonValue latitude, 'longitude': EJsonValue longitude} =>
        RealmDistributionPointDAO(fromEJson(latitude), fromEJson(longitude)),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(RealmDistributionPointDAO._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
      ObjectType.embeddedObject,
      RealmDistributionPointDAO,
      'RealmDistributionPointDAO',
      [
        SchemaProperty('latitude', RealmPropertyType.double),
        SchemaProperty('longitude', RealmPropertyType.double),
      ],
    );
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
