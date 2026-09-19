import 'package:riverpod/riverpod.dart';

import '../core/result.dart';
import '../entity/manhole_card.dart';

/// アプリ全体で 1 つ。アプリのルート（lib/di/）で data パッケージの実装に差し替える。
final cardRepositoryProvider = Provider<CardRepository>(
  (ref) =>
      throw UnimplementedError('cardRepositoryProvider must be overridden'),
);

abstract class CardRepository {
  Future<Result<ManholeCard>> get({required String id});

  /// 端末に取り込んだすべてのカード。
  Future<Result<List<ManholeCard>>> fetchAll();
}
