import 'package:app/src/router/go_router_navigation_service.dart';
import 'package:domain/domain.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockErrorReporter extends Mock implements ErrorReporter {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockErrorReporter errorReporter;
  late GoRouterNavigationService navigationService;

  setUpAll(() {
    registerFallbackValue(const UnknownException());
  });

  setUp(() {
    errorReporter = MockErrorReporter();
    when(
      () => errorReporter.recordFailure(any(), reason: any(named: 'reason')),
    ).thenAnswer((_) async {});
    // 画面を組み立てないので、アラートは出さずにすぐ戻る。
    navigationService = GoRouterNavigationService(
      GoRouter(
        routes: [GoRoute(path: '/', builder: (_, __) => const SizedBox())],
      ),
      errorReporter,
    );
  });

  test('調べる必要のある失敗は、何に失敗したかを添えて記録する', () async {
    const exception = CorruptedDataException(detail: 'cards/1 の name がない');

    await navigationService.showFailure(
      title: 'マスターデータを更新できませんでした',
      exception: exception,
    );

    verify(
      () => errorReporter.recordFailure(
        exception,
        reason: 'マスターデータを更新できませんでした',
      ),
    ).called(1);
  });

  test('時間をおけば直る失敗は記録しない', () async {
    for (final exception in const [OfflineException(), TimedOutException()]) {
      await navigationService.showFailure(
        title: 'カード情報を取得できませんでした',
        exception: exception,
      );
    }

    verifyNever(
      () => errorReporter.recordFailure(any(), reason: any(named: 'reason')),
    );
  });
}
