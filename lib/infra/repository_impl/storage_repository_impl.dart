import 'package:firebase_storage/firebase_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/domain/entity/result.dart';
import '/domain/repository/storage_repository.dart';

final storageRepositoryProvider = Provider.autoDispose<StorageRepository>(
  (ref) {
    final storageRepository = StorageRepositoryImpl();
    ref.onDispose(storageRepository.dispose);
    return storageRepository;
  },
);

class StorageRepositoryImpl implements StorageRepository {
  final _logger = Logger();
  final _storage = FirebaseStorage.instance;

  @override
  Future<Result<void>> delete({
    required String url,
  }) async {
    try {
      final ref = _storage.refFromURL(url);
      await ref.delete();
      return const Result.success(null);
    } on Exception catch (exception) {
      return Result.failure(exception);
    }
  }

  void dispose() {
    _logger.d('StorageRepositoryImpl dispose');
  }
}
