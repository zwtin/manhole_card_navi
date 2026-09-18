import 'package:riverpod/riverpod.dart';

import '../core/result.dart';
import '../dto/list_card_dto.dart';

/// main.dart の ProviderScope で data パッケージの実装に差し替える。
final listCardsQueryServiceProvider =
    Provider.autoDispose<ListCardsQueryService>(
      (ref) =>
          throw UnimplementedError(
            'listCardsQueryServiceProvider must be overridden',
          ),
    );

abstract class ListCardsQueryService {
  Future<Result<List<ListCardDTO>>> fetch();
}
