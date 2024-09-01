import 'package:freezed_annotation/freezed_annotation.dart';

part 'firestore_image_dao.freezed.dart';
part 'firestore_image_dao.g.dart';

@freezed
abstract class FirestoreImageDAO with _$FirestoreImageDAO {
  const factory FirestoreImageDAO({
    required String id,
    required String colorOriginal,
    required String colorResized,
    required String colorFrameGreen,
    required String colorFrameRed,
    required String colorFrameYellow,
    required String grayOriginal,
    required String grayResized,
    required String grayFrameGreen,
    required String grayFrameRed,
    required String grayFrameYellow,
  }) = _FirestoreImageDAO;

  const FirestoreImageDAO._();

  factory FirestoreImageDAO.fromJson(Map<String, dynamic> json) =>
      _$FirestoreImageDAOFromJson(json);
}
