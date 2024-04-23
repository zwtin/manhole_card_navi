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

  @override
  Future<Result<void>> requestPermission() async {
    try {
      final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isServiceEnabled) {
        throw const CustomException(
          title: 'エラー',
          text: '位置情報が取得できないデバイスです。',
        );
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw const CustomException(
            title: 'エラー',
            text: '位置情報のアクセスを許可してください。',
          );
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw const CustomException(
          title: 'エラー',
          text: '位置情報のアクセスを許可してください。',
        );
      }

      return const Result.success(null);
    } on CustomException catch (customException) {
      return Result.failure(
        customException,
      );
    } on Exception catch (_) {
      return const Result.failure(
        CustomException(
          title: 'エラー',
          text: '位置情報にアクセスできませんでした。',
        ),
      );
    }
  }

  void dispose() {
    _logger.d('LocationRepositoryImpl dispose');
  }
}
