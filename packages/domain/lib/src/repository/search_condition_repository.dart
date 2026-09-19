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
  /// 検索条件。購読を始めたときに今の値が流れ、変わるたびに流れる。今の値だけが
  /// 欲しいときは `first` で取る。
  Stream<SearchCondition> watch();

  Future<Result<void>> save({required SearchCondition searchCondition});
}
