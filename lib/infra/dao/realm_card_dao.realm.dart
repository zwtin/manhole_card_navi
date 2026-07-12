// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'realm_card_dao.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
class RealmCardDAO extends $RealmCardDAO
    with RealmEntity, RealmObjectBase, RealmObject {
  RealmCardDAO(
    String id,
    double latitude,
    double longitude,
    String name,
    DateTime publicationDate,
    String distributionState,
    String image,
    String distributionPlaceHtml,
    String distributionTimeHtml,
    String stockHtml, {
    Iterable<RealmDistributionPointDAO> distributionPoints = const [],
    RealmPrefectureDAO? prefecture,
    RealmVolumeDAO? volume,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'latitude', latitude);
    RealmObjectBase.set(this, 'longitude', longitude);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'publicationDate', publicationDate);
    RealmObjectBase.set(this, 'distributionState', distributionState);
    RealmObjectBase.set(this, 'image', image);
    RealmObjectBase.set(this, 'distributionPlaceHtml', distributionPlaceHtml);
    RealmObjectBase.set(this, 'distributionTimeHtml', distributionTimeHtml);
    RealmObjectBase.set(this, 'stockHtml', stockHtml);
    RealmObjectBase.set<RealmList<RealmDistributionPointDAO>>(
      this,
      'distributionPoints',
      RealmList<RealmDistributionPointDAO>(distributionPoints),
    );
    RealmObjectBase.set(this, 'prefecture', prefecture);
    RealmObjectBase.set(this, 'volume', volume);
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
  String get distributionState =>
      RealmObjectBase.get<String>(this, 'distributionState') as String;
  @override
  set distributionState(String value) =>
      RealmObjectBase.set(this, 'distributionState', value);

  @override
  String get image => RealmObjectBase.get<String>(this, 'image') as String;
  @override
  set image(String value) => RealmObjectBase.set(this, 'image', value);

  @override
  String get distributionPlaceHtml =>
      RealmObjectBase.get<String>(this, 'distributionPlaceHtml') as String;
  @override
  set distributionPlaceHtml(String value) =>
      RealmObjectBase.set(this, 'distributionPlaceHtml', value);

  @override
  String get distributionTimeHtml =>
      RealmObjectBase.get<String>(this, 'distributionTimeHtml') as String;
  @override
  set distributionTimeHtml(String value) =>
      RealmObjectBase.set(this, 'distributionTimeHtml', value);

  @override
  String get stockHtml =>
      RealmObjectBase.get<String>(this, 'stockHtml') as String;
  @override
  set stockHtml(String value) => RealmObjectBase.set(this, 'stockHtml', value);

  @override
  RealmList<RealmDistributionPointDAO> get distributionPoints =>
      RealmObjectBase.get<RealmDistributionPointDAO>(this, 'distributionPoints')
          as RealmList<RealmDistributionPointDAO>;
  @override
  set distributionPoints(
    covariant RealmList<RealmDistributionPointDAO> value,
  ) => throw RealmUnsupportedSetError();

  @override
  RealmPrefectureDAO? get prefecture =>
      RealmObjectBase.get<RealmPrefectureDAO>(this, 'prefecture')
          as RealmPrefectureDAO?;
  @override
  set prefecture(covariant RealmPrefectureDAO? value) =>
      RealmObjectBase.set(this, 'prefecture', value);

  @override
  RealmVolumeDAO? get volume =>
      RealmObjectBase.get<RealmVolumeDAO>(this, 'volume') as RealmVolumeDAO?;
  @override
  set volume(covariant RealmVolumeDAO? value) =>
      RealmObjectBase.set(this, 'volume', value);

  @override
  Stream<RealmObjectChanges<RealmCardDAO>> get changes =>
      RealmObjectBase.getChanges<RealmCardDAO>(this);

  @override
  Stream<RealmObjectChanges<RealmCardDAO>> changesFor([
    List<String>? keyPaths,
  ]) => RealmObjectBase.getChangesFor<RealmCardDAO>(this, keyPaths);

  @override
  RealmCardDAO freeze() => RealmObjectBase.freezeObject<RealmCardDAO>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'latitude': latitude.toEJson(),
      'longitude': longitude.toEJson(),
      'name': name.toEJson(),
      'publicationDate': publicationDate.toEJson(),
      'distributionState': distributionState.toEJson(),
      'image': image.toEJson(),
      'distributionPlaceHtml': distributionPlaceHtml.toEJson(),
      'distributionTimeHtml': distributionTimeHtml.toEJson(),
      'stockHtml': stockHtml.toEJson(),
      'distributionPoints': distributionPoints.toEJson(),
      'prefecture': prefecture.toEJson(),
      'volume': volume.toEJson(),
    };
  }

  static EJsonValue _toEJson(RealmCardDAO value) => value.toEJson();
  static RealmCardDAO _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'latitude': EJsonValue latitude,
        'longitude': EJsonValue longitude,
        'name': EJsonValue name,
        'publicationDate': EJsonValue publicationDate,
        'distributionState': EJsonValue distributionState,
        'image': EJsonValue image,
        'distributionPlaceHtml': EJsonValue distributionPlaceHtml,
        'distributionTimeHtml': EJsonValue distributionTimeHtml,
        'stockHtml': EJsonValue stockHtml,
      } =>
        RealmCardDAO(
          fromEJson(id),
          fromEJson(latitude),
          fromEJson(longitude),
          fromEJson(name),
          fromEJson(publicationDate),
          fromEJson(distributionState),
          fromEJson(image),
          fromEJson(distributionPlaceHtml),
          fromEJson(distributionTimeHtml),
          fromEJson(stockHtml),
          distributionPoints: fromEJson(ejson['distributionPoints']),
          prefecture: fromEJson(ejson['prefecture']),
          volume: fromEJson(ejson['volume']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(RealmCardDAO._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
      ObjectType.realmObject,
      RealmCardDAO,
      'RealmCardDAO',
      [
        SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
        SchemaProperty('latitude', RealmPropertyType.double),
        SchemaProperty('longitude', RealmPropertyType.double),
        SchemaProperty('name', RealmPropertyType.string),
        SchemaProperty('publicationDate', RealmPropertyType.timestamp),
        SchemaProperty('distributionState', RealmPropertyType.string),
        SchemaProperty('image', RealmPropertyType.string),
        SchemaProperty('distributionPlaceHtml', RealmPropertyType.string),
        SchemaProperty('distributionTimeHtml', RealmPropertyType.string),
        SchemaProperty('stockHtml', RealmPropertyType.string),
        SchemaProperty(
          'distributionPoints',
          RealmPropertyType.object,
          linkTarget: 'RealmDistributionPointDAO',
          collectionType: RealmCollectionType.list,
        ),
        SchemaProperty(
          'prefecture',
          RealmPropertyType.object,
          optional: true,
          linkTarget: 'RealmPrefectureDAO',
        ),
        SchemaProperty(
          'volume',
          RealmPropertyType.object,
          optional: true,
          linkTarget: 'RealmVolumeDAO',
        ),
      ],
    );
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
