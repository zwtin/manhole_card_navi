import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/domain/entity/custom_exception.dart';
import '/domain/entity/is_first_open.dart';
import '/domain/entity/result.dart';
import '/domain/repository/is_first_open_repository.dart';
import '/infra/repository_impl/is_first_open_repository_impl.dart';
import '/use_case/dto/is_first_open_dto.dart';

final isFirstOpenUseCaseProvider = Provider.autoDispose<IsFirstOpenUseCase>(
  (ref) {
    final isFirstOpenUseCase = IsFirstOpenUseCase(
      ref.watch(isFirstOpenRepositoryProvider),
    );
    ref.onDispose(isFirstOpenUseCase.dispose);
    return isFirstOpenUseCase;
  },
);

class IsFirstOpenUseCase {
  IsFirstOpenUseCase(
    this._isFirstOpenRepository,
  );

  final IsFirstOpenRepository _isFirstOpenRepository;

  final _logger = Logger();

  Future<Result<IsFirstOpenDTO>> get() async {
    final result = await _isFirstOpenRepository.get();
    if (result is Failure) {
      return const Result.failure(
        CustomException(
          title: 'エラー',
          text: '起動済みフラグの確認に失敗しました',
        ),
      );
    }
    final isFirstOpen = (result as Success<IsFirstOpen>).value;
    if (isFirstOpen.value) {
      final isNotFirstOpen = isFirstOpen.copyWith(value: false);
      await _isFirstOpenRepository.set(isFirstOpen: isNotFirstOpen);
    }
    return Result.success(
      IsFirstOpenDTO(
        value: isFirstOpen.value,
      ),
    );
  }

  void dispose() {
    _logger.d('IsFirstOpenUseCase dispose');
  }
}
