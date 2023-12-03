import 'package:freezed_annotation/freezed_annotation.dart';

part 'firestore_card_dao.freezed.dart';
part 'firestore_card_dao.g.dart';

@freezed
abstract class FirestoreCardDAO with _$FirestoreCardDAO {
  const factory FirestoreCardDAO({
    required String id,
    required double latitude,
    required double longitude,
    required String name,
    required String publicationDate,
    required String imageId,
    required String prefectureId,
    required String volumeId,
    required String distributionState,
    required String distributionLinkText,
    required String distributionLinkUrl,
    required String distributionText,
    required String distributionOther,
  }) = _FirestoreCardDAO;

  const FirestoreCardDAO._();

  factory FirestoreCardDAO.fromJson(Map<String, dynamic> json) =>
      _$FirestoreCardDAOFromJson(json);
}
