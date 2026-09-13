import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../entity/result.dart';
import '../entity/search_condition.dart';

/// main.dart の ProviderScope で data パッケージの実装に差し替える。
final searchConditionQueryServiceProvider =
    Provider.autoDispose<SearchConditionQueryService>(
      (ref) =>
          throw UnimplementedError(
            'searchConditionQueryServiceProvider must be overridden',
          ),
    );

abstract class SearchConditionQueryService {
  Future<Result<SearchCondition>> get();
  Stream<SearchCondition> getStream();
}
