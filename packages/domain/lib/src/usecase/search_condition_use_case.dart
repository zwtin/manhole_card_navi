import 'package:riverpod/riverpod.dart';

import '../core/result.dart';
import '../entity/search_condition.dart';
import '../repository/search_condition_repository.dart';

/// UseCase は状態を持たないので、画面ごとに分けずアプリ全体で 1 つ。
final searchConditionUseCaseProvider =
    Provider<SearchConditionUseCase>(
  (ref) {
    return SearchConditionUseCase(
      ref.watch(searchConditionRepositoryProvider),
    );
  },
);

class SearchConditionUseCase {
  SearchConditionUseCase(
    this._searchConditionRepository,
  );

  final SearchConditionRepository _searchConditionRepository;

  /// 検索条件。購読を始めたときに今の値が流れ、変わるたびに流れる。
  Stream<SearchCondition> watch() {
    return _searchConditionRepository.watch();
  }

  Future<Result<void>> save({
    required SearchCondition searchCondition,
  }) {
    return _searchConditionRepository.save(
      searchCondition: searchCondition,
    );
  }
}
