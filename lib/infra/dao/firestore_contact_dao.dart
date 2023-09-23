import 'package:freezed_annotation/freezed_annotation.dart';

part 'firestore_contact_dao.freezed.dart';
part 'firestore_contact_dao.g.dart';

@freezed
abstract class FirestoreContactDAO with _$FirestoreContactDAO {
  const factory FirestoreContactDAO({
    required String address,
    required String id,
    required double latitude,
    required String longitude,
    required String name,
    required String other,
    required String phoneNumber,
  }) = _FirestoreContactDAO;

  const FirestoreContactDAO._();

  factory FirestoreContactDAO.fromJson(Map<String, dynamic> json) =>
      _$FirestoreContactDAOFromJson(json);
}
