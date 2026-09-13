import 'package:domain/domain.dart';

import '../dao/realm_distribution_point_dao.dart';

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
