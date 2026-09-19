import 'package:domain/domain.dart';
import 'package:logger/logger.dart';

import '../exception/domain_exception_converter.dart';
import '../service/failure_recorder.dart';
import '../storage/master_data_store.dart';

class CardRepositoryImpl implements CardRepository {
  CardRepositoryImpl(
    this._store,
    this._failureRecorder,
  );

  final _logger = Logger();
  final MasterDataStore _store;
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
        return card.first;
      },
      convert: DomainExceptionConverter.fromLocalStorage,
    );
  }

  @override
  Future<Result<List<ManholeCard>>> fetchAll() {
    return _failureRecorder.guard(
      _readAll,
      convert: DomainExceptionConverter.fromLocalStorage,
    );
  }

  Future<List<ManholeCard>> _readAll() async {
    final cards = await _store.readAll();
    if (cards == null || cards.isEmpty) {
      throw const NotFoundException(detail: '端末にマスターデータがありません');
    }
    return cards;
  }

  void dispose() {
    _logger.d('CardRepositoryImpl dispose');
  }
}
