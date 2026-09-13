import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../entity/result.dart';
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

  Future<Result<void>> save({
    required SearchCondition searchCondition,
  }) {
    return _searchConditionRepository.save(
      searchCondition: searchCondition,
    );
  }
}
