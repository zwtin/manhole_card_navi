// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'realm_card_dao.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class RealmCardDAO extends _RealmCardDAO
    with RealmEntity, RealmObjectBase, RealmObject {
  RealmCardDAO(
    String id,
    double latitude,
    double longitude,
    String name,
    DateTime publicationDate, {
    Iterable<RealmContactDAO> contacts = const [],
    Iterable<RealmDistributionDAO> distributions = const [],
    Iterable<RealmImageDAO> images = const [],
    Iterable<RealmPrefectureDAO> prefectures = const [],
    Iterable<RealmVolumeDAO> volumes = const [],
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'latitude', latitude);
    RealmObjectBase.set(this, 'longitude', longitude);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'publicationDate', publicationDate);
    RealmObjectBase.set<RealmList<RealmContactDAO>>(
        this, 'contacts', RealmList<RealmContactDAO>(contacts));
    RealmObjectBase.set<RealmList<RealmDistributionDAO>>(
        this, 'distributions', RealmList<RealmDistributionDAO>(distributions));
    RealmObjectBase.set<RealmList<RealmImageDAO>>(
        this, 'images', RealmList<RealmImageDAO>(images));
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
  DateTime get publicationDate =>
      RealmObjectBase.get<DateTime>(this, 'publicationDate') as DateTime;
  @override
  set publicationDate(DateTime value) =>
      RealmObjectBase.set(this, 'publicationDate', value);

  @override
  RealmList<RealmContactDAO> get contacts =>
      RealmObjectBase.get<RealmContactDAO>(this, 'contacts')
          as RealmList<RealmContactDAO>;
  @override
  set contacts(covariant RealmList<RealmContactDAO> value) =>
      throw RealmUnsupportedSetError();

  @override
  RealmList<RealmDistributionDAO> get distributions =>
      RealmObjectBase.get<RealmDistributionDAO>(this, 'distributions')
          as RealmList<RealmDistributionDAO>;
  @override
  set distributions(covariant RealmList<RealmDistributionDAO> value) =>
      throw RealmUnsupportedSetError();

  @override
  RealmList<RealmImageDAO> get images =>
      RealmObjectBase.get<RealmImageDAO>(this, 'images')
          as RealmList<RealmImageDAO>;
  @override
  set images(covariant RealmList<RealmImageDAO> value) =>
      throw RealmUnsupportedSetError();

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
      SchemaProperty('latitude', RealmPropertyType.double),
      SchemaProperty('longitude', RealmPropertyType.double),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('publicationDate', RealmPropertyType.timestamp),
      SchemaProperty('contacts', RealmPropertyType.object,
          linkTarget: 'RealmContactDAO',
          collectionType: RealmCollectionType.list),
      SchemaProperty('distributions', RealmPropertyType.object,
          linkTarget: 'RealmDistributionDAO',
          collectionType: RealmCollectionType.list),
      SchemaProperty('images', RealmPropertyType.object,
          linkTarget: 'RealmImageDAO',
          collectionType: RealmCollectionType.list),
      SchemaProperty('prefectures', RealmPropertyType.object,
          linkTarget: 'RealmPrefectureDAO',
          collectionType: RealmCollectionType.list),
      SchemaProperty('volumes', RealmPropertyType.object,
          linkTarget: 'RealmVolumeDAO',
          collectionType: RealmCollectionType.list),
    ]);
  }
}
