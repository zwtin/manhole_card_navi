import 'package:freezed_annotation/freezed_annotation.dart';

part 'firestore_image_dao.freezed.dart';
part 'firestore_image_dao.g.dart';

@freezed
abstract class FirestoreImageDAO with _$FirestoreImageDAO {
  const factory FirestoreImageDAO({
    required String id,
    required String name,
  }) = _FirestoreImageDAO;

  const FirestoreImageDAO._();

  factory FirestoreImageDAO.fromJson(Map<String, dynamic> json) =>
      _$FirestoreImageDAOFromJson(json);
}
