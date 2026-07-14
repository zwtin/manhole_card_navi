import '/domain/entity/manhole_card_distribution_point.dart';
import '/infra/dao/realm_distribution_point_dao.dart';

class RealmDistributionPointMapper {
  static ManholeCardDistributionPoint convertToEntity({
    required RealmDistributionPointDAO dao,
  }) {
    return ManholeCardDistributionPoint(
      latitude: dao.latitude,
      longitude: dao.longitude,
    );
  }

  static RealmDistributionPointDAO convertFromEntity({
    required ManholeCardDistributionPoint entity,
  }) {
    return RealmDistributionPointDAO(
      entity.latitude,
      entity.longitude,
    );
  }
}
