import 'package:riverpod/riverpod.dart';

import 'package:domain/src/core/result.dart';
import 'package:domain/src/entity/coordinate.dart';
import 'package:domain/src/repository/location_repository.dart';

final locationUseCaseProvider = Provider<LocationUseCase>(
  (ref) => LocationUseCase(
    ref.watch(locationRepositoryProvider),
  ),
);

class LocationUseCase {
  LocationUseCase(
    this._locationRepository,
  );

  final LocationRepository _locationRepository;

  Future<Result<bool>> requestPermission() async {
    return _locationRepository.requestPermission();
  }

  Future<Result<bool>> isPermissionGranted() async {
    return _locationRepository.isPermissionGranted();
  }

  Future<Result<Coordinate?>> getCurrentLocation() async {
    return _locationRepository.getCurrentLocation();
  }
}
