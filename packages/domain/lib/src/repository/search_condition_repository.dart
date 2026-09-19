import 'package:riverpod/riverpod.dart';

import '../core/result.dart';
import '../entity/search_condition.dart';

/// アプリ全体で 1 つ。アプリのルート（lib/di/）で data パッケージの実装に差し替える。
final searchConditionRepositoryProvider =
    Provider<SearchConditionRepository>(
      (ref) =>
          throw UnimplementedError(
            'searchConditionRepositoryProvider must be overridden',
          ),
    );

abstract class SearchConditionRepository {
  Future<Result<SearchCondition>> get();

  /// 検索条件が変わるたびに流れる。購読を始めたときにも今の値が流れる。
  Stream<SearchCondition> getStream();

  Future<Result<void>> save({required SearchCondition searchCondition});
}
