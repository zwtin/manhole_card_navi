// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'realm_card_dao.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class RealmCardDAO extends _RealmCardDAO
    with RealmEntity, RealmObjectBase, RealmObject {
  RealmCardDAO(
    String id,
    String name, {
    Iterable<RealmPrefectureDAO> prefectures = const [],
    Iterable<RealmVolumeDAO> volumes = const [],
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set<RealmList<RealmPrefectureDAO>>(
        this, 'prefectures', RealmList<RealmPrefectureDAO>(prefectures));
    RealmObjectBase.set<RealmList<RealmVolumeDAO>>(
        this, 'volumes', RealmList<RealmVolumeDAO>(volumes));
  }

  RealmCardDAO._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  RealmList<RealmPrefectureDAO> get prefectures =>
      RealmObjectBase.get<RealmPrefectureDAO>(this, 'prefectures')
          as RealmList<RealmPrefectureDAO>;
  @override
  set prefectures(covariant RealmList<RealmPrefectureDAO> value) =>
      throw RealmUnsupportedSetError();

  @override
  RealmList<RealmVolumeDAO> get volumes =>
      RealmObjectBase.get<RealmVolumeDAO>(this, 'volumes')
          as RealmList<RealmVolumeDAO>;
  @override
  set volumes(covariant RealmList<RealmVolumeDAO> value) =>
      throw RealmUnsupportedSetError();

  @override
  Stream<RealmObjectChanges<RealmCardDAO>> get changes =>
      RealmObjectBase.getChanges<RealmCardDAO>(this);

  @override
  RealmCardDAO freeze() => RealmObjectBase.freezeObject<RealmCardDAO>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(RealmCardDAO._);
    return const SchemaObject(
        ObjectType.realmObject, RealmCardDAO, 'RealmCardDAO', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('prefectures', RealmPropertyType.object,
          linkTarget: 'RealmPrefectureDAO',
          collectionType: RealmCollectionType.list),
      SchemaProperty('volumes', RealmPropertyType.object,
          linkTarget: 'RealmVolumeDAO',
          collectionType: RealmCollectionType.list),
    ]);
  }
}
