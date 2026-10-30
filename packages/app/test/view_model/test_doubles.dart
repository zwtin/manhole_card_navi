import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mocktail/mocktail.dart';

import 'package:app/src/router/current_route.dart';
import 'package:app/src/router/navigation_service.dart';
import 'package:domain/domain.dart';

class MockAlreadyGetCardUseCase extends Mock implements AlreadyGetCardUseCase {}

class MockAnalyticsUseCase extends Mock implements AnalyticsUseCase {}

class MockAppInfoUseCase extends Mock implements AppInfoUseCase {}

class MockCardUseCase extends Mock implements CardUseCase {}

class MockCheckMasterUpdateUseCase extends Mock
    implements CheckMasterUpdateUseCase {}

class MockLocationUseCase extends Mock implements LocationUseCase {}

class MockNavigationService extends Mock implements NavigationService {}

class MockSearchConditionUseCase extends Mock
    implements SearchConditionUseCase {}

class MockTermsOfServiceUseCase extends Mock implements TermsOfServiceUseCase {}

class MockUserUseCase extends Mock implements UserUseCase {}

/// GoRouter の代わりに、最前面の画面を [go] で切り替える。
class FakeCurrentRoute extends CurrentRouteNotifier {
  @override
  CurrentRoute? build() => null;

  void go(String location) {
    final uri = Uri.parse(location);
    final segments = uri.pathSegments;
    state = CurrentRoute(
      pageKey: ValueKey(location),
      matchedLocation: uri.path,
      uri: uri,
      pathParameters: {
        if (segments.length >= 3 && segments[1] == 'card')
          'cardId': segments[2],
      },
    );
  }
}

/// 購読を始めたときに [initial] を流し、その後は [changes] を流す。Repository の
/// watch と同じく、購読を始めた時点から後の変化を取りこぼさない。
Stream<T> watching<T>(T initial, Stream<T> changes) {
  StreamSubscription<T>? subscription;
  final controller = StreamController<T>();
  controller
    ..onListen = () {
      controller.add(initial);
      subscription = changes.listen(controller.add);
    }
    ..onCancel = () => subscription?.cancel();
  return controller.stream;
}

/// 1x1 の PNG。
final pngBytes = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==',
);

ManholeCard manholeCard({
  required String id,
  String prefectureId = '13',
  Coordinate position = const Coordinate(latitude: 35.68, longitude: 139.76),
  List<Coordinate> distributionPoints = const [
    Coordinate(latitude: 35.69, longitude: 139.77),
  ],
}) {
  return ManholeCard(
    id: id,
    position: position,
    name: 'カード $id',
    publicationDate: DateTime(2026, 1, 2),
    distributionState: DistributionState.distributing,
    distributionPlaceHtml: '',
    distributionTimeHtml: '',
    stockHtml: '',
    distributionPoints: distributionPoints,
    prefecture: Prefecture(id: prefectureId, name: '県 $prefectureId'),
    volume: const Volume(id: '0000', name: '第1弾'),
  );
}

void registerFallbackValues() {
  registerFallbackValue(const UnknownException());
  registerFallbackValue(SearchCondition.initial());
  registerFallbackValue(const AnalyticsEvent.appOpen());
}
