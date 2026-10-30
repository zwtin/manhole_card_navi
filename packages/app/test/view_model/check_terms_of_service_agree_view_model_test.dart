import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import 'package:app/src/router/navigation_service.dart';
import 'package:app/src/view_model/check_terms_of_service_agree_view_model.dart';
import 'package:domain/domain.dart';

import 'test_doubles.dart';

void main() {
  late MockNavigationService navigationService;
  late MockTermsOfServiceUseCase termsOfServiceUseCase;
  late ProviderContainer container;

  setUpAll(registerFallbackValues);

  setUp(() {
    navigationService = MockNavigationService();
    termsOfServiceUseCase = MockTermsOfServiceUseCase();

    when(
      () => navigationService.showAlert(
        title: any(named: 'title'),
        message: any(named: 'message'),
        buttonTitle: any(named: 'buttonTitle'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => navigationService.showFailure(
        title: any(named: 'title'),
        exception: any(named: 'exception'),
      ),
    ).thenAnswer((_) async {});

    container = ProviderContainer(
      overrides: [
        analyticsUseCaseProvider.overrideWithValue(MockAnalyticsUseCase()),
        navigationServiceProvider.overrideWithValue(navigationService),
        termsOfServiceUseCaseProvider.overrideWithValue(termsOfServiceUseCase),
      ],
    );
    // autoDispose の ViewModel がテスト中に破棄されないよう購読しておく。
    container.listen(checkTermsOfServiceAgreeViewModelProvider, (_, __) {});
  });

  tearDown(() {
    container.dispose();
  });

  CheckTermsOfServiceAgreeViewModel viewModel() {
    return container.read(checkTermsOfServiceAgreeViewModelProvider.notifier);
  }

  /// agree が呼ばれるたびに [results] を先頭から順に返す。
  void stubAgree(List<Result<void>> results) {
    var index = 0;
    when(
      () => termsOfServiceUseCase.agree(),
    ).thenAnswer((_) async => results[index++]);
  }

  test('チェックを入れずに押したら、同意を求めて先へ進まない', () async {
    await viewModel().onTapAgreeButton();

    verify(
      () => navigationService.showAlert(
        title: 'エラー',
        message: '利用規約とプライバシーポリシーに同意してください',
      ),
    ).called(1);
    verifyNever(() => termsOfServiceUseCase.agree());
    verifyNever(() => navigationService.goToHome());
  });

  test('チェックを入れて押したら、同意を保存してホームへ進む', () async {
    stubAgree([const Result.success(null)]);
    viewModel().onTapCheckBox();

    await viewModel().onTapAgreeButton();

    verifyInOrder([
      () => termsOfServiceUseCase.agree(),
      () => navigationService.goToHome(),
    ]);
  });

  test('同意を保存できなければ、知らせてからやり直す', () async {
    stubAgree([
      const Result.failure(PersistenceException()),
      const Result.success(null),
    ]);
    viewModel().onTapCheckBox();

    await viewModel().onTapAgreeButton();

    verify(
      () => navigationService.showFailure(
        title: '同意を保存できませんでした',
        exception: any(named: 'exception', that: isA<PersistenceException>()),
      ),
    ).called(1);
    verify(() => termsOfServiceUseCase.agree()).called(2);
    verify(() => navigationService.goToHome()).called(1);
    expect(
      container.read(checkTermsOfServiceAgreeViewModelProvider).isLoading,
      isFalse,
    );
  });

  test('チェックは押すたびに切り替わる', () {
    viewModel().onTapCheckBox();
    viewModel().onTapCheckBox();

    expect(
      container.read(checkTermsOfServiceAgreeViewModelProvider).isAgreed,
      isFalse,
    );
  });
}
