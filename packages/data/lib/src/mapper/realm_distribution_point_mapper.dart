import 'package:domain/domain.dart';

import '../dao/realm_distribution_point_dao.dart';

/// 配布地点の DAO と [Coordinate] の変換。
class RealmDistributionPointMapper {
  static Coordinate convertToEntity({
    required RealmDistributionPointDAO dao,
  }) {
    return Coordinate(
      latitude: dao.latitude,
      longitude: dao.longitude,
    );
  }

  static RealmDistributionPointDAO convertFromEntity({
    required Coordinate entity,
  }) {
    return RealmDistributionPointDAO(
      entity.latitude,
      entity.longitude,
    );
  }
}
