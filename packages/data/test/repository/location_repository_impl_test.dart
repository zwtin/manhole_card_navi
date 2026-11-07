import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mocktail/mocktail.dart';

import 'package:data/src/datasource/crashlytics_data_source.dart';
import 'package:data/src/datasource/location_data_source.dart';
import 'package:data/src/repository/location_repository_impl.dart';
import 'package:domain/domain.dart';

import '../datasource/crashlytics_mock.dart';

class MockLocationDataSource extends Mock implements LocationDataSource {}

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
      CrashlyticsDataSource(crashlytics),
    );
  });

  group('requestPermission', () {
    test('端末の位置情報がオフなら、許可を求めずに false', () async {
      when(
        () => platform.isLocationServiceEnabled(),
      ).thenAnswer((_) async => false);

      final result = await repository.requestPermission();

      expect((result as Success<bool>).value, isFalse);
      verifyNever(() => platform.requestPermission());
    });

    test('求めた結果を、購読している画面にも流す', () async {
      when(
        () => platform.isLocationServiceEnabled(),
      ).thenAnswer((_) async => true);
      when(() => platform.requestPermission()).thenAnswer((_) async => true);
      final granted = repository.watchPermissionGranted().first;

      final result = await repository.requestPermission();

      expect((result as Success<bool>).value, isTrue);
      expect(await granted, isTrue);
    });

    test('許可を待っている間に dispose されても、結果はそのまま返し、閉じた Stream には流さない', () async {
      final answer = Completer<bool>();
      when(
        () => platform.isLocationServiceEnabled(),
      ).thenAnswer((_) async => true);
      when(() => platform.requestPermission()).thenAnswer((_) => answer.future);

      final requesting = repository.requestPermission();
      await pumpEventQueue();
      await repository.dispose();
      answer.complete(true);

      // 閉じた StreamController に add すると StateError で落ちる。
      expect((await requesting as Success<bool>).value, isTrue);
    });
  });

  group('getCurrentLocation', () {
    test('現在地を座標で返す', () async {
      when(
        () => platform.getCurrentPosition(),
      ).thenAnswer((_) async => (latitude: 35.68, longitude: 139.76));

      final result = await repository.getCurrentLocation();

      expect(
        (result as Success<Coordinate?>).value,
        Coordinate(latitude: 35.68, longitude: 139.76),
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
      verifyNotRecorded(crashlytics);
    });

    test('範囲外の座標は壊れたデータの失敗にし、元の例外を 1 回記録する', () async {
      when(
        () => platform.getCurrentPosition(),
      ).thenAnswer((_) async => (latitude: double.nan, longitude: 139.76));

      final result = await repository.getCurrentLocation();

      expect(
        (result as Failure<Coordinate?>).exception,
        isA<CorruptedDataException>(),
      );
      expect(recordedErrors(crashlytics).single.error, isA<FormatException>());
    });

    test('タイムアウトは応答が遅すぎる失敗にし、元の例外を記録する', () async {
      final thrown = TimeoutException('遅い');
      when(() => platform.getCurrentPosition()).thenThrow(thrown);

      final result = await repository.getCurrentLocation();

      expect(
        (result as Failure<Coordinate?>).exception,
        isA<TimedOutException>(),
      );
      expect(recordedErrors(crashlytics).single.error, same(thrown));
    });
  });
}
