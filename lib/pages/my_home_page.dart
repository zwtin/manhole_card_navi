import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:manhole_card_navi/infra/dao/realm_prefecture_dao.dart';
import 'package:path_provider/path_provider.dart';
import 'package:realm/realm.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Uint8List? bytes;
  File? propertyFile;

  @override
  void initState() {
    super.initState();

    var config = Configuration.local([RealmPrefectureDao.schema]);
    var realm = Realm(config);

    var prefecture = RealmPrefectureDao('aaa', '北海道');
    realm.write(() {
      realm.add(prefecture);
    });

    var prefectures = realm.all<RealmPrefectureDao>();
    var hokkaido = prefectures[0];
    print("hokkaido id is ${hokkaido.id} name ${hokkaido.name}");

    final firebaseStorageRef = FirebaseStorage.instance.ref();
    final firebaseStoragePath =
        firebaseStorageRef.child('images/cards/00-101-A01.jpg');
    try {
      const oneMegabyte = 1024 * 1024;
      Future(() async {
        final Uint8List? data = await firebaseStoragePath.getData(oneMegabyte);
        if (data == null) {
          return;
        }
        final appDirectory = await getApplicationDocumentsDirectory();
        final imageDirectory = Directory('${appDirectory.path}/images');
        var imagePath = '';
        if (!imageDirectory.existsSync()) {
          imageDirectory.createSync(recursive: true);
          imageDirectory.createSync();
          imagePath = '${imageDirectory.path}/00-101-A01.jpg';
          final imageFile = File(imagePath);
          await imageFile.writeAsBytes(data);
        } else {
          imageDirectory.deleteSync(recursive: true);
          imagePath = '${imageDirectory.path}/00-101-A01.jpg';
        }
        final readFile = File(imagePath);
        setState(() {
          bytes = data;
          propertyFile = readFile;
        });
      });
    } on FirebaseException catch (e) {}

    // cars = realm.all<Car>().query("make == 'Tesla'");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Center(
        child: propertyFile == null ? Container() : Image.file(propertyFile!),
      ),
    );
  }
}
