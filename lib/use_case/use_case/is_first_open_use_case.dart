import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:manhole_card_navi/domain/entity/is_first_open.dart';
import 'package:manhole_card_navi/domain/repository/first_open_repository.dart';
import 'package:manhole_card_navi/infra/repository_impl/first_open_repository_impl.dart';
import 'package:manhole_card_navi/use_case/dto/first_open_dto.dart';

import '/domain/entity/custom_exception.dart';
import '/domain/entity/result.dart';

final isFirstOpenUseCaseProvider = Provider.autoDispose<IsFirstOpenUseCase>(
  (ref) {
    final isFirstOpenUseCase = IsFirstOpenUseCase(
      ref.watch(firstOpenRepositoryProvider),
    );
    ref.onDispose(isFirstOpenUseCase.dispose);
    return isFirstOpenUseCase;
  },
);

class IsFirstOpenUseCase {
  IsFirstOpenUseCase(
    this._firstOpenRepository,
  );

  final FirstOpenRepository _firstOpenRepository;

  final _logger = Logger();

  Future<Result<FirstOpenDTO>> getIsFirstOpen() async {
    final result = await _firstOpenRepository.getIsFirstOpen();
    if (result is Failure) {
      return const Result.failure(
        CustomException(
          title: 'エラー',
          text: '起動済みフラグの確認に失敗しました',
        ),
      );
    }
    final isFirstOpen = (result as Success<IsFirstOpen>).value;
    return Result.success(
      FirstOpenDTO(
        isFirst: isFirstOpen.value,
      ),
    );
  }

  Future<Result<void>> setIsFirstOpen() async {
    const isNotFirstOpen = IsFirstOpen(value: false);
    return _firstOpenRepository.setIsFirstOpen(isFirstOpen: isNotFirstOpen);
  }

  void dispose() {
    _logger.d('IsFirstOpenUseCase dispose');
  }
}
