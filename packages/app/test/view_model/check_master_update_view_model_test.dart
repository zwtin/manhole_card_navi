import 'package:app/src/router/navigation_service.dart';
import 'package:app/src/view_model/check_master_update_view_model.dart';
import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

class MockAnalyticsUseCase extends Mock implements AnalyticsUseCase {}

class MockCheckMasterUpdateUseCase extends Mock
    implements CheckMasterUpdateUseCase {}

class MockTermsOfServiceUseCase extends Mock implements TermsOfServiceUseCase {}

class MockNavigationService extends Mock implements NavigationService {}

void main() {
  late MockCheckMasterUpdateUseCase checkMasterUpdateUseCase;
  late MockTermsOfServiceUseCase termsOfServiceUseCase;
  late MockNavigationService navigationService;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(const UnknownException());
  });

  setUp(() {
    checkMasterUpdateUseCase = MockCheckMasterUpdateUseCase();
    termsOfServiceUseCase = MockTermsOfServiceUseCase();
    navigationService = MockNavigationService();
    container = ProviderContainer(
      overrides: [
        analyticsUseCaseProvider.overrideWithValue(MockAnalyticsUseCase()),
        checkMasterUpdateUseCaseProvider.overrideWithValue(
          checkMasterUpdateUseCase,
        ),
        termsOfServiceUseCaseProvider.overrideWithValue(termsOfServiceUseCase),
        navigationServiceProvider.overrideWithValue(navigationService),
      ],
    );
    // autoDispose の ViewModel がテスト中に破棄されないよう購読しておく。
    container.listen(checkMasterUpdateViewModelProvider, (_, __) {});
    when(
      () => navigationService.showFailure(
        title: any(named: 'title'),
        exception: any(named: 'exception'),
      ),
    ).thenAnswer((_) async {});
    when(() => termsOfServiceUseCase.getNeedAgree()).thenAnswer(
      (_) async => const Result.success(true),
    );
  });

  tearDown(() {
    container.dispose();
  });

  /// getNeedUpdate が呼ばれるたびに [results] を先頭から順に返す。
  void stubNeedUpdate(List<Result<bool>> results) {
    var index = 0;
    when(() => checkMasterUpdateUseCase.getNeedUpdate())
        .thenAnswer((_) async => results[index++]);
  }

  Future<void> onLoad() {
    return container.read(checkMasterUpdateViewModelProvider.notifier).onLoad();
  }

  test('更新が不要なら、取り込まずに次の画面へ進む', () async {
    stubNeedUpdate([const Result.success(false)]);

    await onLoad();

    verifyNever(() => checkMasterUpdateUseCase.updateMaster());
    verify(() => navigationService.goToTutorial()).called(1);
  });

  test('更新が必要なら、取り込んでから次の画面へ進む', () async {
    stubNeedUpdate([const Result.success(true)]);
    when(() => checkMasterUpdateUseCase.updateMaster())
        .thenAnswer((_) async => const Result.success(null));
    when(() => termsOfServiceUseCase.getNeedAgree()).thenAnswer(
      (_) async => const Result.success(false),
    );

    await onLoad();

    verify(() => checkMasterUpdateUseCase.updateMaster()).called(1);
    verify(() => navigationService.goToCheckTermsOfServiceUpdate()).called(1);
  });

  test('失敗したら、何に失敗したかと失敗の種類を知らせてやり直す', () async {
    stubNeedUpdate([
      const Result.failure(OfflineException()),
      const Result.success(false),
    ]);

    await onLoad();

    verify(
      () => navigationService.showFailure(
        title: 'マスターデータを更新できませんでした',
        exception: any(named: 'exception', that: isA<OfflineException>()),
      ),
    ).called(1);
    verify(() => checkMasterUpdateUseCase.getNeedUpdate()).called(2);
    verify(() => navigationService.goToTutorial()).called(1);
  });

  test('取り込みに失敗したら、確認からやり直す', () async {
    stubNeedUpdate([const Result.success(true), const Result.success(false)]);
    when(() => checkMasterUpdateUseCase.updateMaster()).thenAnswer(
      (_) async => const Result.failure(CorruptedDataException()),
    );

    await onLoad();

    verify(
      () => navigationService.showFailure(
        title: 'マスターデータを更新できませんでした',
        exception: any(named: 'exception', that: isA<CorruptedDataException>()),
      ),
    ).called(1);
    verify(() => checkMasterUpdateUseCase.getNeedUpdate()).called(2);
  });
}
