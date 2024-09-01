import 'package:realm/realm.dart';

part 'realm_image_dao.realm.dart';

@RealmModel()
class $RealmImageDAO {
  @PrimaryKey()
  late String id;
  late String colorOriginal;
  late String colorResized;
  late String colorFrameGreen;
  late String colorFrameRed;
  late String colorFrameYellow;
  late String grayOriginal;
  late String grayResized;
  late String grayFrameGreen;
  late String grayFrameRed;
  late String grayFrameYellow;
}
