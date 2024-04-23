import 'package:freezed_annotation/freezed_annotation.dart';

part 'firestore_volume_dao.freezed.dart';
part 'firestore_volume_dao.g.dart';

@freezed
abstract class FirestoreVolumeDAO with _$FirestoreVolumeDAO {
  const factory FirestoreVolumeDAO({
    required String id,
    required String name,
  }) = _FirestoreVolumeDAO;

  const FirestoreVolumeDAO._();

  factory FirestoreVolumeDAO.fromJson(Map<String, dynamic> json) =>
      _$FirestoreVolumeDAOFromJson(json);
}
