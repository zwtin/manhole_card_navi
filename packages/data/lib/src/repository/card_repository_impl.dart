import 'package:domain/domain.dart';
import 'package:logger/logger.dart';

import '../datasource/failure_recorder.dart';
import '../datasource/master_data_local_data_source.dart';
import '../mapper/domain_exception_mapper.dart';
import '../mapper/local_card_mapper.dart';
import '../model/local_card_model.dart';

class CardRepositoryImpl implements CardRepository {
  CardRepositoryImpl(
    this._masterData,
    this._failureRecorder,
  );

  final _logger = Logger();
  final MasterDataLocalDataSource _masterData;
  final FailureRecorder _failureRecorder;

  @override
  Future<Result<ManholeCard>> get({
    required String id,
  }) {
    return _failureRecorder.guard(
      () async {
        final card = (await _readAll()).where((card) => card.id == id);
        if (card.isEmpty) {
          throw NotFoundException(detail: 'ID が $id のカードが端末にありません');
        }
        return LocalCardMapper.toCard(card.first);
      },
      convert: DomainExceptionMapper.fromLocalStorage,
    );
  }

  @override
  Future<Result<List<ManholeCard>>> fetchAll() {
    return _failureRecorder.guard(
      () async => [
        for (final card in await _readAll()) LocalCardMapper.toCard(card),
      ],
      convert: DomainExceptionMapper.fromLocalStorage,
    );
  }

  Future<List<LocalCardModel>> _readAll() async {
    final cards = await _masterData.readAll();
    if (cards == null || cards.isEmpty) {
      throw const NotFoundException(detail: '端末にマスターデータがありません');
    }
    return cards;
  }

  void dispose() {
    _logger.d('CardRepositoryImpl dispose');
  }
}
