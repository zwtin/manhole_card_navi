import 'package:riverpod/riverpod.dart';

import '../dto/map_marker_dto.dart';
import '../entity/result.dart';

/// main.dart の ProviderScope で data パッケージの実装に差し替える。
final distributionCardsQueryServiceProvider =
    Provider.autoDispose<DistributionCardsQueryService>(
      (ref) =>
          throw UnimplementedError(
            'distributionCardsQueryServiceProvider must be overridden',
          ),
    );

abstract class DistributionCardsQueryService {
  Future<Result<List<MapMarkerDTO>>> fetch();
}
