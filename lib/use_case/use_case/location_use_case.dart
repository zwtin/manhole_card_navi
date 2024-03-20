import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/domain/entity/result.dart';
import '/domain/repository/location_repository.dart';
import '/infra/repository_impl/location_repository_impl.dart';

final locationUseCaseProvider = Provider.autoDispose<LocationUseCase>(
  (ref) {
    final locationUseCase = LocationUseCase(
      ref.watch(locationRepositoryProvider),
    );
    ref.onDispose(locationUseCase.dispose);
    return locationUseCase;
  },
);

class LocationUseCase {
  LocationUseCase(
    this._locationRepository,
  );

  final LocationRepository _locationRepository;

  final _logger = Logger();

  Future<Result<void>> requestPermission() async {
    return _locationRepository.requestPermission();
  }

  void dispose() {
    _logger.d('LocationUseCase dispose');
  }
}
