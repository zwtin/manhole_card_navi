import 'package:domain/domain.dart';

import '../dao/realm_distribution_point_dao.dart';
import 'realm_distribution_point_mapper.dart';

class RealmDistributionPointsMapper {
  static ManholeCardDistributionPoints convertToEntity({
    required List<RealmDistributionPointDAO> daoList,
  }) {
    return ManholeCardDistributionPoints(
      list: daoList.map(
        (element) {
          return RealmDistributionPointMapper.convertToEntity(dao: element);
        },
      ).toList(),
    );
  }

  static List<RealmDistributionPointDAO> convertFromEntity({
    required ManholeCardDistributionPoints entity,
  }) {
    return entity.map(
      (element) {
        return RealmDistributionPointMapper.convertFromEntity(entity: element);
      },
    ).toList();
  }
}
