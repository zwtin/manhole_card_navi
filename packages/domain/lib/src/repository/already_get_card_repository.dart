import 'package:riverpod/riverpod.dart';

import '../core/result.dart';

/// アプリ全体で 1 つ。アプリのルート（lib/di/）で data パッケージの実装に差し替える。
final alreadyGetCardRepositoryProvider =
    Provider<AlreadyGetCardRepository>(
      (ref) =>
          throw UnimplementedError(
            'alreadyGetCardRepositoryProvider must be overridden',
          ),
    );

/// どのカードを取得したかの記録。記録しているのはカードの ID そのもの。
abstract class AlreadyGetCardRepository {
  /// 取得済みカードの ID。購読を始めたときに今の値が流れ、変わるたびに流れる。
  /// 今の値だけが欲しいときは `first` で取る。
  Stream<Set<String>> watch();

  /// [cardId] のカードを取得済みにする。
  Future<Result<void>> save({required String cardId});

  /// [cardId] のカードを未取得に戻す。
  Future<Result<void>> delete({required String cardId});
}
