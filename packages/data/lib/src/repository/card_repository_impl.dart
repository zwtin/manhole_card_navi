import 'package:domain/domain.dart';
import 'package:logger/logger.dart';
import 'package:realm/realm.dart';

import '../dao/realm_card_dao.dart';
import '../dao/realm_configuration.dart';
import '../exception/domain_exception_converter.dart';
import '../mapper/realm_card_mapper.dart';
import '../service/failure_recorder.dart';

class CardRepositoryImpl implements CardRepository {
  final _logger = Logger();
  final _failureRecorder = FailureRecorder();

  @override
  Future<Result<ManholeCard>> get({
    required String id,
  }) async {
    try {
      final realm = RealmConfiguration.open();
      try {
        final dao = realm.all<RealmCardDAO>().query(r'id == $0', [id]).firstOrNull;
        if (dao == null) {
          return _failureRecorder.failure(
            NotFoundException(detail: 'ID が $id のカードが端末にありません'),
          );
        }
        return Result.success(RealmCardMapper.convertToEntity(dao: dao));
      } finally {
        realm.close();
      }
    } on Exception catch (error, stackTrace) {
      return _failureRecorder.failure(
        DomainExceptionConverter.fromLocalStorage(error, stackTrace),
        stackTrace,
      );
    }
  }

  @override
  Future<Result<List<ManholeCard>>> fetchAll() async {
    try {
      final realm = RealmConfiguration.open();
      try {
        final daoList = realm.all<RealmCardDAO>();
        if (daoList.isEmpty) {
          return _failureRecorder.failure(
            const NotFoundException(detail: '端末にマスターデータがありません'),
          );
        }
        return Result.success(
          daoList
              .map((dao) => RealmCardMapper.convertToEntity(dao: dao))
              .toList(),
        );
      } finally {
        realm.close();
      }
    } on Exception catch (error, stackTrace) {
      return _failureRecorder.failure(
        DomainExceptionConverter.fromLocalStorage(error, stackTrace),
        stackTrace,
      );
    }
  }

  void dispose() {
    _logger.d('CardRepositoryImpl dispose');
  }
}
