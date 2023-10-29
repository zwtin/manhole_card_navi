import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import '/domain/entity/manhole_card.dart';
import '/domain/entity/result.dart';
import '/domain/repository/already_get_card_repository.dart';
import '/temporary_provider.dart';

final alreadyGetCardRepositoryProvider =
    Provider.autoDispose<AlreadyGetCardRepository>(
  (ref) {
    final alreadyGetCardRepository = AlreadyGetCardRepositoryImpl(
      ref.watch(sharedPreferencesProvider),
    );
    ref.onDispose(alreadyGetCardRepository.dispose);
    return alreadyGetCardRepository;
  },
);

class AlreadyGetCardRepositoryImpl implements AlreadyGetCardRepository {
  AlreadyGetCardRepositoryImpl(
    this._instance,
  );

  final _logger = Logger();
  final StreamingSharedPreferences _instance;

  @override
  Future<Result<void>> save({
    required ManholeCard manholeCard,
  }) async {
    // TODO: implement save
    throw UnimplementedError();
  }

  @override
  Future<Result<void>> delete({
    required ManholeCard manholeCard,
  }) async {
    // TODO: implement delete
    throw UnimplementedError();
  }

  void dispose() {
    _logger.d('AlreadyGetCardRepositoryImpl dispose');
  }
}
