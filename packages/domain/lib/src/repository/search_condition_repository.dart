import 'package:riverpod/riverpod.dart';

import 'package:domain/src/core/result.dart';
import 'package:domain/src/entity/search_condition.dart';

final searchConditionRepositoryProvider =
    Provider<SearchConditionRepository>(
      (ref) =>
          throw UnimplementedError(
            'searchConditionRepositoryProvider must be overridden',
          ),
    );

abstract class SearchConditionRepository {
  /// 購読を始めたときに今の値が流れる。
  Stream<SearchCondition> watch();

  Future<Result<void>> save({required SearchCondition searchCondition});
}
