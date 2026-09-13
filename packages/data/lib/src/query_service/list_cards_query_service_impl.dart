import 'package:domain/domain.dart';
import 'package:logger/logger.dart';

import '../dao/realm_card_dao.dart';
import '../dao/realm_configuration.dart';

class ListCardsQueryServiceImpl implements ListCardsQueryService {
  final _logger = Logger();

  @override
  Future<Result<List<ListCardDTO>>> fetch() async {
    try {
      var realm = RealmConfiguration.open();

      final cardDAOList = realm.all<RealmCardDAO>();
      if (cardDAOList.isEmpty) {
        throw const CustomException(
          title: 'エラー',
          text: 'データが見つかりませんでした。',
        );
      }

      final cardDTOList = cardDAOList.map((dao) {
        return ListCardDTO(
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
        );
      }).toList();

      return Result.success(cardDTOList);
    } on CustomException catch (customException) {
      return Result.failure(
        customException,
      );
    } on Exception catch (_) {
      return const Result.failure(
        CustomException(
          title: 'エラー',
          text: 'リストデータの取得に失敗しました。',
        ),
      );
    }
  }

  void dispose() {
    _logger.d('ListCardsQueryServiceImpl dispose');
  }
}
