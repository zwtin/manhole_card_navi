import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:realm/realm.dart';

import '/domain/entity/current_master_version.dart';
import '/domain/entity/manhole_card_distribution.dart';
import '/domain/entity/manhole_card_distributions.dart';
import '/domain/entity/result.dart';
import '/domain/repository/distribution_repository.dart';
import '/infra/dao/realm_distribution_dao.dart';
import '/infra/mapper/realm_distributions_mapper.dart';

final distributionRepositoryProvider =
    Provider.autoDispose<DistributionRepository>(
  (ref) {
    final distributionRepository = DistributionRepositoryImpl();
    ref.onDispose(distributionRepository.dispose);
    return distributionRepository;
  },
);

class DistributionRepositoryImpl implements DistributionRepository {
  final _logger = Logger();
  final _firestore = FirebaseFirestore.instance;

  @override
  Future<Result<ManholeCardDistributions>> fetchMaster({
    required CurrentMasterVersion currentMasterVersion,
  }) async {
    final querySnapshot = await _firestore
        .collection('master')
        .doc(currentMasterVersion.version)
        .collection('distributions')
        .get();
    final list = querySnapshot.docs.map(
      (doc) {
        return ManholeCardDistribution(
          id: doc['id'] as String,
          other: doc['other'] as String,
          state: ManholeCardDistributionState.values.byName(
            doc['state'] as String,
          ),
        );
      },
    ).toList();
    return Result.success(
      ManholeCardDistributions(
        list: list,
      ),
    );
  }

  @override
  Future<Result<void>> deleteMaster() async {
    var config = Configuration.local([
      RealmDistributionDAO.schema,
    ]);
    var realm = Realm(config);

    realm.write(() {
      realm.deleteAll<RealmDistributionDAO>();
    });
    realm.close();

    return const Result.success(null);
  }

  @override
  Future<Result<void>> saveMaster({
    required ManholeCardDistributions manholeCardDistributions,
  }) async {
    var config = Configuration.local([
      RealmDistributionDAO.schema,
    ]);
    var realm = Realm(config);

    final realmDistributions = RealmDistributionsMapper.convertFromModel(
      model: manholeCardDistributions,
    );

    realm.write(() {
      realm.addAll(realmDistributions);
    });
    realm.close();

    return const Result.success(null);
  }

  void dispose() {
    _logger.d('DistributionRepositoryImpl dispose');
  }
}
