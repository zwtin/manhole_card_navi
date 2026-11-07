import 'package:riverpod/riverpod.dart';

import 'package:domain/src/core/result.dart';
import 'package:domain/src/entity/card_browsing_settings.dart';

final cardBrowsingSettingsRepositoryProvider =
    Provider<CardBrowsingSettingsRepository>(
      (ref) =>
          throw UnimplementedError(
            'cardBrowsingSettingsRepositoryProvider must be overridden',
          ),
    );

abstract class CardBrowsingSettingsRepository {
  /// 購読を始めたときに今の値が流れる。
  Stream<CardBrowsingSettings> watch();

  Future<Result<void>> save({required CardBrowsingSettings settings});
}
