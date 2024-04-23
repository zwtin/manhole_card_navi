import 'package:freezed_annotation/freezed_annotation.dart';

part 'firestore_prefecture_dao.freezed.dart';
part 'firestore_prefecture_dao.g.dart';

@freezed
abstract class FirestorePrefectureDAO with _$FirestorePrefectureDAO {
  const factory FirestorePrefectureDAO({
    required String id,
    required String name,
  }) = _FirestorePrefectureDAO;

  const FirestorePrefectureDAO._();

  factory FirestorePrefectureDAO.fromJson(Map<String, dynamic> json) =>
      _$FirestorePrefectureDAOFromJson(json);
}
