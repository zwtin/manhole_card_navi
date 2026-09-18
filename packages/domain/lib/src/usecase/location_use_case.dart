import 'package:logger/logger.dart';
import 'package:riverpod/riverpod.dart';

import '../core/result.dart';
import '../repository/location_repository.dart';

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

  Future<Result<bool>> requestPermission() async {
    return _locationRepository.requestPermission();
  }

  Future<Result<bool>> isPermissionGranted() async {
    return _locationRepository.isPermissionGranted();
  }

  Future<Result<({double latitude, double longitude})>>
      getCurrentLocation() async {
    return _locationRepository.getCurrentLocation();
  }

  void dispose() {
    _logger.d('LocationUseCase dispose');
  }
}
