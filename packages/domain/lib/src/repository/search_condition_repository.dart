import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../entity/result.dart';
import '../entity/search_condition.dart';

/// main.dart の ProviderScope で data パッケージの実装に差し替える。
final searchConditionRepositoryProvider =
    Provider.autoDispose<SearchConditionRepository>(
      (ref) =>
          throw UnimplementedError(
            'searchConditionRepositoryProvider must be overridden',
          ),
    );

abstract class SearchConditionRepository {
  Future<Result<void>> save({required SearchCondition searchCondition});
}
