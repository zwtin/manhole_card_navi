import 'package:domain/domain.dart';
import 'package:logger/logger.dart';

import '../dao/realm_card_dao.dart';
import '../dao/realm_configuration.dart';
import '../exception/domain_exception_converter.dart';

class ListCardsQueryServiceImpl implements ListCardsQueryService {
  final _logger = Logger();

  @override
  Future<Result<List<ListCardDTO>>> fetch() async {
    try {
      final realm = RealmConfiguration.open();
      try {
        final daoList = realm.all<RealmCardDAO>();
        if (daoList.isEmpty) {
          throw const NotFoundException(detail: '端末にマスターデータがありません');
        }
        return Result.success(
          daoList
              .map(
                (dao) => ListCardDTO(
                  id: dao.id,
                  name: dao.name,
                  imagePath: dao.image,
                  imageSubPath: dao.imageSub,
                  prefectureId: dao.prefecture?.id ?? '',
                  prefectureName: dao.prefecture?.name ?? '',
                  volumeId: dao.volume?.id ?? '',
                  volumeName: dao.volume?.name ?? '',
                  distributionState: dao.distributionState,
                  publicationDate: dao.publicationDate,
                ),
              )
              .toList(),
        );
      } finally {
        realm.close();
      }
    } on Exception catch (error, stackTrace) {
      return Result.failure(
        DomainExceptionConverter.fromLocalStorage(error, stackTrace),
      );
    }
  }

  void dispose() {
    _logger.d('ListCardsQueryServiceImpl dispose');
  }
}
