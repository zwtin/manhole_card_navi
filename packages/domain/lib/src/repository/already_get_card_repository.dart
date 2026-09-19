import 'package:riverpod/riverpod.dart';

import 'package:domain/src/core/result.dart';

final alreadyGetCardRepositoryProvider =
    Provider<AlreadyGetCardRepository>(
      (ref) =>
          throw UnimplementedError(
            'alreadyGetCardRepositoryProvider must be overridden',
          ),
    );

abstract class AlreadyGetCardRepository {
  /// 購読を始めたときに今の値が流れる。
  Stream<Set<String>> watch();

  Future<Result<void>> save({required String cardId});

  Future<Result<void>> delete({required String cardId});
}
