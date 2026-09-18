import 'package:app/src/view_model/check_master_update_view_model.dart';
import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

class MockAnalyticsUseCase extends Mock implements AnalyticsUseCase {}

class MockCheckMasterUpdateUseCase extends Mock
    implements CheckMasterUpdateUseCase {}

class MockCheckTermsOfServiceAgreeUseCase extends Mock
    implements CheckTermsOfServiceAgreeUseCase {}

class MockNavigationService extends Mock implements NavigationService {}

void main() {
  late MockCheckMasterUpdateUseCase checkMasterUpdateUseCase;
  late MockCheckTermsOfServiceAgreeUseCase checkTermsOfServiceAgreeUseCase;
  late MockNavigationService navigationService;
  late ProviderContainer container;

  setUp(() {
    checkMasterUpdateUseCase = MockCheckMasterUpdateUseCase();
    checkTermsOfServiceAgreeUseCase = MockCheckTermsOfServiceAgreeUseCase();
    navigationService = MockNavigationService();
    container = ProviderContainer(
      overrides: [
        analyticsUseCaseProvider.overrideWithValue(MockAnalyticsUseCase()),
        checkMasterUpdateUseCaseProvider.overrideWithValue(
          checkMasterUpdateUseCase,
        ),
        checkTermsOfServiceAgreeUseCaseProvider.overrideWithValue(
          checkTermsOfServiceAgreeUseCase,
        ),
        navigationServiceProvider.overrideWithValue(navigationService),
      ],
    );
    // autoDispose の ViewModel がテスト中に破棄されないよう購読しておく。
    container.listen(checkMasterUpdateViewModelProvider, (_, __) {});
    when(
      () => navigationService.showAlert(
        title: any(named: 'title'),
        message: any(named: 'message'),
        buttonTitle: any(named: 'buttonTitle'),
      ),
    ).thenAnswer((_) async {});
    when(() => checkTermsOfServiceAgreeUseCase.getNeedAgree()).thenAnswer(
      (_) async => const Result.success(NeedTermsOfServiceAgreeDTO(value: true)),
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
    when(() => checkTermsOfServiceAgreeUseCase.getNeedAgree()).thenAnswer(
      (_) async =>
          const Result.success(NeedTermsOfServiceAgreeDTO(value: false)),
    );

    await onLoad();

    verify(() => checkMasterUpdateUseCase.updateMaster()).called(1);
    verify(() => navigationService.goToCheckTermsOfServiceUpdate()).called(1);
  });

  test('通信できずに失敗したら、失敗の種類に応じた本文を出してやり直す', () async {
    stubNeedUpdate([
      const Result.failure(OfflineException()),
      const Result.success(false),
    ]);

    await onLoad();

    verify(
      () => navigationService.showAlert(
        title: 'マスターデータを更新できませんでした',
        message: '通信できませんでした。電波のよい場所で、もう一度お試しください。',
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
      () => navigationService.showAlert(
        title: 'マスターデータを更新できませんでした',
        message: any(named: 'message', that: startsWith('データを正しく読み込めませんでした')),
      ),
    ).called(1);
    verify(() => checkMasterUpdateUseCase.getNeedUpdate()).called(2);
  });
}
