import 'package:freezed_annotation/freezed_annotation.dart';

part 'firestore_distribution_dao.freezed.dart';
part 'firestore_distribution_dao.g.dart';

@freezed
abstract class FirestoreDistributionDAO with _$FirestoreDistributionDAO {
  const factory FirestoreDistributionDAO({
    required String id,
    required String other,
    required String state,
  }) = _FirestoreDistributionDAO;

  const FirestoreDistributionDAO._();

  factory FirestoreDistributionDAO.fromJson(Map<String, dynamic> json) =>
      _$FirestoreDistributionDAOFromJson(json);
}
