import 'package:riverpod/riverpod.dart';

import '../core/result.dart';
import '../dto/map_marker_dto.dart';

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
