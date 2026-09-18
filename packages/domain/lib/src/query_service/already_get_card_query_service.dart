import 'package:riverpod/riverpod.dart';

import '../dto/already_get_card_dto.dart';
import '../entity/result.dart';

/// main.dart の ProviderScope で data パッケージの実装に差し替える。
final alreadyGetCardQueryServiceProvider =
    Provider.autoDispose<AlreadyGetCardQueryService>(
      (ref) =>
          throw UnimplementedError(
            'alreadyGetCardQueryServiceProvider must be overridden',
          ),
    );

abstract class AlreadyGetCardQueryService {
  Future<Result<List<AlreadyGetCardDTO>>> get();
  Stream<List<AlreadyGetCardDTO>> getStream();
}
