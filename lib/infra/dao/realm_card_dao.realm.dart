// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'realm_card_dao.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

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
    String distributionLinkText,
    String distributionLinkUrl,
    String distributionText,
    String distributionOther, {
    RealmImageDAO? image,
    RealmPrefectureDAO? prefecture,
    RealmVolumeDAO? volume,
    Iterable<RealmContactDAO> contacts = const [],
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'latitude', latitude);
    RealmObjectBase.set(this, 'longitude', longitude);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'publicationDate', publicationDate);
    RealmObjectBase.set(this, 'distributionState', distributionState);
    RealmObjectBase.set(this, 'distributionLinkText', distributionLinkText);
    RealmObjectBase.set(this, 'distributionLinkUrl', distributionLinkUrl);
    RealmObjectBase.set(this, 'distributionText', distributionText);
    RealmObjectBase.set(this, 'distributionOther', distributionOther);
    RealmObjectBase.set(this, 'image', image);
    RealmObjectBase.set(this, 'prefecture', prefecture);
    RealmObjectBase.set(this, 'volume', volume);
    RealmObjectBase.set<RealmList<RealmContactDAO>>(
        this, 'contacts', RealmList<RealmContactDAO>(contacts));
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
  String get distributionLinkText =>
      RealmObjectBase.get<String>(this, 'distributionLinkText') as String;
  @override
  set distributionLinkText(String value) =>
      RealmObjectBase.set(this, 'distributionLinkText', value);

  @override
  String get distributionLinkUrl =>
      RealmObjectBase.get<String>(this, 'distributionLinkUrl') as String;
  @override
  set distributionLinkUrl(String value) =>
      RealmObjectBase.set(this, 'distributionLinkUrl', value);

  @override
  String get distributionText =>
      RealmObjectBase.get<String>(this, 'distributionText') as String;
  @override
  set distributionText(String value) =>
      RealmObjectBase.set(this, 'distributionText', value);

  @override
  String get distributionOther =>
      RealmObjectBase.get<String>(this, 'distributionOther') as String;
  @override
  set distributionOther(String value) =>
      RealmObjectBase.set(this, 'distributionOther', value);

  @override
  RealmImageDAO? get image =>
      RealmObjectBase.get<RealmImageDAO>(this, 'image') as RealmImageDAO?;
  @override
  set image(covariant RealmImageDAO? value) =>
      RealmObjectBase.set(this, 'image', value);

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
  RealmList<RealmContactDAO> get contacts =>
      RealmObjectBase.get<RealmContactDAO>(this, 'contacts')
          as RealmList<RealmContactDAO>;
  @override
  set contacts(covariant RealmList<RealmContactDAO> value) =>
      throw RealmUnsupportedSetError();

  @override
  Stream<RealmObjectChanges<RealmCardDAO>> get changes =>
      RealmObjectBase.getChanges<RealmCardDAO>(this);

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
      'distributionLinkText': distributionLinkText.toEJson(),
      'distributionLinkUrl': distributionLinkUrl.toEJson(),
      'distributionText': distributionText.toEJson(),
      'distributionOther': distributionOther.toEJson(),
      'image': image.toEJson(),
      'prefecture': prefecture.toEJson(),
      'volume': volume.toEJson(),
      'contacts': contacts.toEJson(),
    };
  }

  static EJsonValue _toEJson(RealmCardDAO value) => value.toEJson();
  static RealmCardDAO _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'latitude': EJsonValue latitude,
        'longitude': EJsonValue longitude,
        'name': EJsonValue name,
        'publicationDate': EJsonValue publicationDate,
        'distributionState': EJsonValue distributionState,
        'distributionLinkText': EJsonValue distributionLinkText,
        'distributionLinkUrl': EJsonValue distributionLinkUrl,
        'distributionText': EJsonValue distributionText,
        'distributionOther': EJsonValue distributionOther,
        'image': EJsonValue image,
        'prefecture': EJsonValue prefecture,
        'volume': EJsonValue volume,
        'contacts': EJsonValue contacts,
      } =>
        RealmCardDAO(
          fromEJson(id),
          fromEJson(latitude),
          fromEJson(longitude),
          fromEJson(name),
          fromEJson(publicationDate),
          fromEJson(distributionState),
          fromEJson(distributionLinkText),
          fromEJson(distributionLinkUrl),
          fromEJson(distributionText),
          fromEJson(distributionOther),
          image: fromEJson(image),
          prefecture: fromEJson(prefecture),
          volume: fromEJson(volume),
          contacts: fromEJson(contacts),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(RealmCardDAO._);
    register(_toEJson, _fromEJson);
    return SchemaObject(ObjectType.realmObject, RealmCardDAO, 'RealmCardDAO', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('latitude', RealmPropertyType.double),
      SchemaProperty('longitude', RealmPropertyType.double),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('publicationDate', RealmPropertyType.timestamp),
      SchemaProperty('distributionState', RealmPropertyType.string),
      SchemaProperty('distributionLinkText', RealmPropertyType.string),
      SchemaProperty('distributionLinkUrl', RealmPropertyType.string),
      SchemaProperty('distributionText', RealmPropertyType.string),
      SchemaProperty('distributionOther', RealmPropertyType.string),
      SchemaProperty('image', RealmPropertyType.object,
          optional: true, linkTarget: 'RealmImageDAO'),
      SchemaProperty('prefecture', RealmPropertyType.object,
          optional: true, linkTarget: 'RealmPrefectureDAO'),
      SchemaProperty('volume', RealmPropertyType.object,
          optional: true, linkTarget: 'RealmVolumeDAO'),
      SchemaProperty('contacts', RealmPropertyType.object,
          linkTarget: 'RealmContactDAO',
          collectionType: RealmCollectionType.list),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
