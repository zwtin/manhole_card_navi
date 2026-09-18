import 'package:riverpod/riverpod.dart';

import '../core/result.dart';
import '../entity/manhole_card.dart';

/// main.dart の ProviderScope で data パッケージの実装に差し替える。
final cardRepositoryProvider = Provider.autoDispose<CardRepository>(
  (ref) =>
      throw UnimplementedError('cardRepositoryProvider must be overridden'),
);

abstract class CardRepository {
  Future<Result<ManholeCard>> get({required String id});
}
