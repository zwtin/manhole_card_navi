import 'package:logger/logger.dart';
import 'package:riverpod/riverpod.dart';

import 'package:domain/src/core/result.dart';
import 'package:domain/src/entity/coordinate.dart';
import 'package:domain/src/repository/location_repository.dart';

final locationUseCaseProvider = Provider<LocationUseCase>(
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

  Future<Result<bool>> requestPermission() async {
    return _locationRepository.requestPermission();
  }

  Future<Result<bool>> isPermissionGranted() async {
    return _locationRepository.isPermissionGranted();
  }

  Future<Result<Coordinate?>> getCurrentLocation() async {
    return _locationRepository.getCurrentLocation();
  }

  void dispose() {
    _logger.d('LocationUseCase dispose');
  }
}
