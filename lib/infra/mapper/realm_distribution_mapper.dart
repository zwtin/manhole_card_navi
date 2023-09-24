import '/domain/entity/manhole_card_distribution.dart';
import '/infra/dao/realm_distribution_dao.dart';

class RealmDistributionMapper {
  static ManholeCardDistribution convertToModel({
    required RealmDistributionDAO dao,
  }) {
    return ManholeCardDistribution(
      id: dao.id,
      other: dao.other,
      state: ManholeCardDistributionState.values.byName(
        dao.state,
      ),
    );
  }
}
