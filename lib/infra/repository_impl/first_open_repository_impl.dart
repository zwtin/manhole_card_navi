import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import '/domain/entity/custom_exception.dart';
import '/domain/entity/is_first_open.dart';
import '/domain/entity/result.dart';
import '/domain/repository/first_open_repository.dart';
import '/temporary_provider.dart';

final firstOpenRepositoryProvider = Provider.autoDispose<FirstOpenRepository>(
  (ref) {
    final firstOpenRepository = FirstOpenRepositoryImpl(
      ref.watch(sharedPreferencesProvider),
    );
    ref.onDispose(firstOpenRepository.dispose);
    return firstOpenRepository;
  },
);

class FirstOpenRepositoryImpl implements FirstOpenRepository {
  FirstOpenRepositoryImpl(
    this._instance,
  );

  final _logger = Logger();
  final StreamingSharedPreferences _instance;

  @override
  Future<Result<IsFirstOpen>> getIsFirstOpen() async {
    final isFirstOpen = _instance
        .getBool(
          'is_first_open',
          defaultValue: true,
        )
        .getValue();
    return Result.success(
      IsFirstOpen(
        value: isFirstOpen,
      ),
    );
  }

  @override
  Future<Result<void>> setIsFirstOpen({
    required IsFirstOpen isFirstOpen,
  }) async {
    try {
      final result = await _instance.setBool(
        'is_first_open',
        isFirstOpen.value,
      );
      if (result) {
        return const Result.success(null);
      } else {
        return const Result.failure(
          CustomException(
            title: 'エラー',
            text: '起動済みフラグの保存に失敗しました',
          ),
        );
      }
    } on Exception catch (exception) {
      return Result.failure(exception);
    }
  }

  void dispose() {
    _logger.d('FirstOpenRepositoryImpl dispose');
  }
}
