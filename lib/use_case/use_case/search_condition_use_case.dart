import 'package:hooks_riverpod/hooks_riverpod.dart';

import '/domain/entity/result.dart';
import '/domain/entity/search_condition.dart';
import '/domain/repository/search_condition_repository.dart';
import '/infra/repository_impl/search_condition_repository_impl.dart';

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
