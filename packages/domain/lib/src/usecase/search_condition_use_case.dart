import 'package:riverpod/riverpod.dart';

import 'package:domain/src/core/result.dart';
import 'package:domain/src/entity/search_condition.dart';
import 'package:domain/src/repository/search_condition_repository.dart';

final searchConditionUseCaseProvider =
    Provider<SearchConditionUseCase>(
  (ref) => SearchConditionUseCase(
    ref.watch(searchConditionRepositoryProvider),
  ),
);

class SearchConditionUseCase {
  SearchConditionUseCase(
    this._searchConditionRepository,
  );

  final SearchConditionRepository _searchConditionRepository;

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
