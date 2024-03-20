import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/domain/entity/custom_exception.dart';
import '/domain/entity/result.dart';
import '/domain/repository/location_repository.dart';

final locationRepositoryProvider = Provider.autoDispose<LocationRepository>(
  (ref) {
    final locationRepository = LocationRepositoryImpl();
    ref.onDispose(locationRepository.dispose);
    return locationRepository;
  },
);

class LocationRepositoryImpl implements LocationRepository {
  final _logger = Logger();
  final _messaging = FirebaseMessaging.instance;

  @override
  Future<Result<void>> requestPermission() async {
    final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      return const Result.failure(
        CustomException(
          title: 'エラー',
          text: '位置情報サービスが使えないデバイスです',
        ),
      );
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return const Result.failure(
          CustomException(
            title: 'エラー',
            text: '位置権限を許可してください',
          ),
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return const Result.failure(
        CustomException(
          title: 'エラー',
          text: '位置権限を許可してください',
        ),
      );
    }

    return const Result.success(null);
  }

  void dispose() {
    _logger.d('LocationRepositoryImpl dispose');
  }
}
