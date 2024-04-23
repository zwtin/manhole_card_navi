import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:realm/realm.dart';

import '/domain/entity/custom_exception.dart';
import '/domain/entity/result.dart';
import '/infra/dao/realm_card_dao.dart';
import '/infra/dao/realm_contact_dao.dart';
import '/infra/dao/realm_image_dao.dart';
import '/infra/dao/realm_prefecture_dao.dart';
import '/infra/dao/realm_volume_dao.dart';
import '/temporary_provider.dart';
import '/use_case/dto/map_marker_dto.dart';
import '/use_case/query_service/distribution_cards_query_service.dart';

final distributionCardsQueryServiceProvider =
    Provider.autoDispose<DistributionCardsQueryService>(
  (ref) {
    final distributionCardsQueryService = DistributionCardsQueryServiceImpl(
      ref.watch(directoryProvider),
    );
    ref.onDispose(distributionCardsQueryService.dispose);
    return distributionCardsQueryService;
  },
);

class DistributionCardsQueryServiceImpl
    implements DistributionCardsQueryService {
  DistributionCardsQueryServiceImpl(
    this._directory,
  );

  final _logger = Logger();
  final Directory _directory;

  @override
  Future<Result<List<MapMarkerDTO>>> fetch() async {
    try {
      final config = Configuration.local([
        RealmCardDAO.schema,
        RealmContactDAO.schema,
        RealmImageDAO.schema,
        RealmPrefectureDAO.schema,
        RealmVolumeDAO.schema,
      ]);
      var realm = Realm(config);

      final daoList = realm.all<RealmCardDAO>();
      if (daoList.isEmpty) {
        throw const CustomException(
          title: 'エラー',
          text: 'データが見つかりませんでした。',
        );
      }

      final appDirectory = _directory;
      final imageDirectory = Directory('${appDirectory.path}/images');

      final dtoList = <MapMarkerDTO>[];
      for (final dao in daoList) {
        final DistributionStateDTO distributionState;
        switch (dao.distributionState) {
          case 'distributing':
            distributionState = DistributionStateDTO.distributing;
            break;
          case 'stopped':
            distributionState = DistributionStateDTO.stopped;
            break;
          case 'notClear':
            distributionState = DistributionStateDTO.notClear;
            break;
          default:
            distributionState = DistributionStateDTO.notClear;
            break;
        }
        final imagePath = dao.image == null
            ? ''
            : '${imageDirectory.path}/${dao.image!.name}';

        for (final contact in dao.contacts) {
          dtoList.add(
            MapMarkerDTO(
              cardId: dao.id,
              imagePath: imagePath,
              distributionState: distributionState,
              latitude: contact.latitude,
              longitude: contact.longitude,
            ),
          );
        }
      }

      return Result.success(dtoList);
    } on CustomException catch (customException) {
      return Result.failure(
        customException,
      );
    } on Exception catch (_) {
      return const Result.failure(
        CustomException(
          title: 'エラー',
          text: '配布場所データの取得に失敗しました。',
        ),
      );
    }
  }

  void dispose() {
    _logger.d('DistributionCardsQueryServiceImpl dispose');
  }
}
