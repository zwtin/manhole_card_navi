import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import 'package:app/src/router/navigation_service.dart';
import 'package:app/src/view_model/check_terms_of_service_update_view_model.dart';
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
    when(
      () => termsOfServiceUseCase.agree(),
    ).thenAnswer((_) async => const Result.success(null));

    container = ProviderContainer(
      overrides: [
        analyticsUseCaseProvider.overrideWithValue(MockAnalyticsUseCase()),
        navigationServiceProvider.overrideWithValue(navigationService),
        termsOfServiceUseCaseProvider.overrideWithValue(termsOfServiceUseCase),
      ],
    );
    // autoDispose の ViewModel がテスト中に破棄されないよう購読しておく。
    container.listen(checkTermsOfServiceUpdateViewModelProvider, (_, __) {});
  });

  tearDown(() {
    container.dispose();
  });

  CheckTermsOfServiceUpdateViewModel viewModel() {
    return container.read(checkTermsOfServiceUpdateViewModelProvider.notifier);
  }

  /// getNeedUpdate が呼ばれるたびに [results] を先頭から順に返す。
  void stubNeedUpdate(List<Result<bool>> results) {
    var index = 0;
    when(
      () => termsOfServiceUseCase.getNeedUpdate(),
    ).thenAnswer((_) async => results[index++]);
  }

  bool inquireUpdate() {
    return container
        .read(checkTermsOfServiceUpdateViewModelProvider)
        .inquireUpdate;
  }

  test('規約が更新されていなければ、そのままホームへ進む', () async {
    stubNeedUpdate([const Result.success(false)]);

    await viewModel().onLoad();

    expect(inquireUpdate(), isFalse);
    verify(() => navigationService.goToHome()).called(1);
  });

  test('規約が更新されていれば、同意するまでホームへ進まない', () async {
    stubNeedUpdate([const Result.success(true)]);

    await viewModel().onLoad();

    expect(inquireUpdate(), isTrue);
    verifyNever(() => navigationService.goToHome());

    viewModel().onTapCheckBox();
    await viewModel().onTapAgreeButton();

    verifyInOrder([
      () => termsOfServiceUseCase.agree(),
      () => navigationService.goToHome(),
    ]);
  });

  test('更新を確かめられなければ、知らせてからやり直す', () async {
    stubNeedUpdate([
      const Result.failure(OfflineException()),
      const Result.success(false),
    ]);

    await viewModel().onLoad();

    verify(
      () => navigationService.showFailure(
        title: '利用規約の更新を確認できませんでした',
        exception: any(named: 'exception', that: isA<OfflineException>()),
      ),
    ).called(1);
    verify(() => termsOfServiceUseCase.getNeedUpdate()).called(2);
    verify(() => navigationService.goToHome()).called(1);
  });

  test('チェックを入れずに押したら、同意を求めて先へ進まない', () async {
    stubNeedUpdate([const Result.success(true)]);
    await viewModel().onLoad();

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
}
