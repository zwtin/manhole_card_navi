import '/domain/entity/manhole_card_distributions.dart';
import '/infra/dao/realm_distribution_dao.dart';

class RealmDistributionMapper {
  static List<RealmDistributionDAO> convertFromModel({
    required ManholeCardDistributions model,
  }) {
    return model.map(
      (element) {
        return RealmDistributionDAO(
          element.id,
          element.other,
          element.state.toString(),
        );
      },
    ).toList();
  }
}
