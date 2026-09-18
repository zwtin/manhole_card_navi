import 'package:riverpod/riverpod.dart';

import '../core/result.dart';
import '../entity/manhole_card.dart';

/// main.dart の ProviderScope で data パッケージの実装に差し替える。
final alreadyGetCardRepositoryProvider =
    Provider.autoDispose<AlreadyGetCardRepository>(
      (ref) =>
          throw UnimplementedError(
            'alreadyGetCardRepositoryProvider must be overridden',
          ),
    );

abstract class AlreadyGetCardRepository {
  Future<Result<void>> save({required ManholeCard manholeCard});
  Future<Result<void>> delete({required ManholeCard manholeCard});
}
