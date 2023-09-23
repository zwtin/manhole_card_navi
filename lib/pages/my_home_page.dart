import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:realm/realm.dart';

import '/infra/dao/realm_card_dao.dart';
import '/infra/dao/realm_prefecture_dao.dart';
import '/infra/dao/realm_volume_dao.dart';

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

    var config = Configuration.local([
      RealmCardDAO.schema,
      RealmPrefectureDAO.schema,
      RealmVolumeDAO.schema,
    ]);
    var realm = Realm(config);

    // var card = RealmCardDAO('00-101-A001', '日本下水道事業団');
    // var prefecture = RealmPrefectureDAO('00', '全国');
    // var volume1 = RealmVolumeDAO('0000', '第01弾');
    // var volume2 = RealmVolumeDAO('0001', '第02弾');
    // card.prefectures.add(prefecture);
    // card.volumes.add(volume1);
    // card.volumes.add(volume2);
    //
    // realm.write(() {
    //   realm.add(card);
    // });
    // realm.close();

    // realm.write(() {
    //   realm.deleteAll<RealmPrefectureDAO>();
    // });
    // realm.write(() {
    //   realm.deleteAll();
    // });
    // realm.close();

    // var prefectures = realm.all<RealmPrefectureDAO>();
    // var hokkaido = prefectures[0];
    // print("hokkaido id is ${hokkaido.id} name ${hokkaido.name}");

    // final firebaseStorageRef = FirebaseStorage.instance.ref();
    // final firebaseStoragePath =
    //     firebaseStorageRef.child('images/cards/00-101-A01.jpg');
    // try {
    //   const oneMegabyte = 1024 * 1024;
    //   Future(() async {
    //     final Uint8List? data = await firebaseStoragePath.getData(oneMegabyte);
    //     if (data == null) {
    //       return;
    //     }
    //     final appDirectory = await getApplicationDocumentsDirectory();
    //     final imageDirectory = Directory('${appDirectory.path}/images');
    //     var imagePath = '';
    //     if (!imageDirectory.existsSync()) {
    //       imageDirectory.createSync(recursive: true);
    //       imageDirectory.createSync();
    //       imagePath = '${imageDirectory.path}/00-101-A01.jpg';
    //       final imageFile = File(imagePath);
    //       await imageFile.writeAsBytes(data);
    //     } else {
    //       imageDirectory.deleteSync(recursive: true);
    //       imagePath = '${imageDirectory.path}/00-101-A01.jpg';
    //     }
    //     final readFile = File(imagePath);
    //     setState(() {
    //       bytes = data;
    //       propertyFile = readFile;
    //     });
    //   });
    // } on FirebaseException catch (e) {}

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
