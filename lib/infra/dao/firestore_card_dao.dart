import 'package:freezed_annotation/freezed_annotation.dart';

part 'firestore_card_dao.freezed.dart';
part 'firestore_card_dao.g.dart';

@freezed
abstract class FirestoreCardDAO implements _$FirestoreCardDAO {
  const factory FirestoreCardDAO({
    required String id,
    required double latitude,
    required String longitude,
    required String name,
    required String publicationDate,
  }) = _FirestoreCardDAO;

  const FirestoreCardDAO._();

  factory FirestoreCardDAO.fromJson(Map<String, dynamic> json) =>
      _$FirestoreCardDAOFromJson(json);
}
