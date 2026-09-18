import 'package:riverpod/riverpod.dart';

import '../core/result.dart';
import '../entity/search_condition.dart';
import '../repository/search_condition_repository.dart';

final searchConditionUseCaseProvider =
    Provider.autoDispose<SearchConditionUseCase>(
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

  Future<Result<SearchCondition>> get() {
    return _searchConditionRepository.get();
  }

  /// 検索条件が変わるたびに流れる。購読を始めたときにも今の値が流れる。
  Stream<SearchCondition> getStream() {
    return _searchConditionRepository.getStream();
  }

  Future<Result<void>> save({
    required SearchCondition searchCondition,
  }) {
    return _searchConditionRepository.save(
      searchCondition: searchCondition,
    );
  }
}
