import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../dto/map_marker_dto.dart';
import '../entity/result.dart';

/// main.dart の ProviderScope で data パッケージの実装に差し替える。
final positionCardsQueryServiceProvider =
    Provider.autoDispose<PositionCardsQueryService>(
      (ref) =>
          throw UnimplementedError(
            'positionCardsQueryServiceProvider must be overridden',
          ),
    );

abstract class PositionCardsQueryService {
  Future<Result<List<MapMarkerDTO>>> fetch();
}
