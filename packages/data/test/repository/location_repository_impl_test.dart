import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mocktail/mocktail.dart';

import 'package:data/src/datasource/crashlytics_data_source.dart';
import 'package:data/src/repository/failure_recorder.dart';
import 'package:data/src/datasource/location_data_source.dart';
import 'package:data/src/repository/location_repository_impl.dart';
import 'package:domain/domain.dart';

import '../datasource/crashlytics_mock.dart';

class MockLocationDataSource extends Mock implements LocationDataSource {}

Position _position() {
  return Position(
    latitude: 35.68,
    longitude: 139.76,
    timestamp: DateTime(2026, 1, 1),
    accuracy: 0,
    altitude: 0,
    altitudeAccuracy: 0,
    heading: 0,
    headingAccuracy: 0,
    speed: 0,
    speedAccuracy: 0,
  );
}

void main() {
  late MockLocationDataSource platform;
  late MockFirebaseCrashlytics crashlytics;
  late LocationRepositoryImpl repository;

  setUp(() {
    platform = MockLocationDataSource();
    crashlytics = MockFirebaseCrashlytics();
    stubRecordError(crashlytics);
    repository = LocationRepositoryImpl(
      platform,
      FailureRecorder(CrashlyticsDataSource(crashlytics)),
    );
  });

  void verifyNotRecorded() {
    verifyNever(
      () => crashlytics.recordError(
        any(),
        any(),
        reason: any(named: 'reason'),
        information: any(named: 'information'),
        printDetails: any(named: 'printDetails'),
        fatal: any(named: 'fatal'),
      ),
    );
  }

  group('requestPermission', () {
    test('端末の位置情報がオフなら、許可を求めずに false', () async {
      when(() => platform.isLocationServiceEnabled())
          .thenAnswer((_) async => false);

      final result = await repository.requestPermission();

      expect((result as Success<bool>).value, isFalse);
      verifyNever(() => platform.requestPermission());
    });

    test('まだ決めていなければ許可を求め、使用中のみでも許可とみなす', () async {
      when(() => platform.isLocationServiceEnabled())
          .thenAnswer((_) async => true);
      when(() => platform.checkPermission())
          .thenAnswer((_) async => LocationPermission.denied);
      when(() => platform.requestPermission())
          .thenAnswer((_) async => LocationPermission.whileInUse);

      final result = await repository.requestPermission();

      expect((result as Success<bool>).value, isTrue);
    });
  });

  group('getCurrentLocation', () {
    test('現在地を座標で返す', () async {
      when(() => platform.getCurrentPosition())
          .thenAnswer((_) async => _position());

      final result = await repository.getCurrentLocation();

      expect(
        (result as Success<Coordinate?>).value,
        const Coordinate(latitude: 35.68, longitude: 139.76),
      );
    });

    test('端末の位置情報がオフ・許可なしなら、失敗ではなく null', () async {
      for (final error in [
        const LocationServiceDisabledException(),
        const PermissionDeniedException('denied'),
      ]) {
        when(() => platform.getCurrentPosition()).thenThrow(error);

        final result = await repository.getCurrentLocation();

        expect((result as Success<Coordinate?>).value, isNull);
      }
      verifyNotRecorded();
    });

    test('タイムアウトは応答が遅すぎる失敗にし、記録しない', () async {
      when(() => platform.getCurrentPosition())
          .thenThrow(TimeoutException('遅い'));

      final result = await repository.getCurrentLocation();

      expect(
        (result as Failure<Coordinate?>).exception,
        isA<TimedOutException>(),
      );
      verifyNotRecorded();
    });
  });
}
