import 'package:app/src/view_model/check_app_update_view_model.dart';
import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

class MockAnalyticsUseCase extends Mock implements AnalyticsUseCase {}

class MockCheckAppUpdateUseCase extends Mock implements CheckAppUpdateUseCase {}

class MockNavigationService extends Mock implements NavigationService {}

void main() {
  late MockCheckAppUpdateUseCase checkAppUpdateUseCase;
  late MockNavigationService navigationService;
  late ProviderContainer container;

  setUp(() {
    checkAppUpdateUseCase = MockCheckAppUpdateUseCase();
    navigationService = MockNavigationService();
    container = ProviderContainer(
      overrides: [
        analyticsUseCaseProvider.overrideWithValue(MockAnalyticsUseCase()),
        checkAppUpdateUseCaseProvider.overrideWithValue(checkAppUpdateUseCase),
        navigationServiceProvider.overrideWithValue(navigationService),
      ],
    );
    // autoDispose の ViewModel がテスト中に破棄されないよう購読しておく。
    container.listen(checkAppUpdateViewModelProvider, (_, __) {});
    when(
      () => navigationService.showAlert(
        title: any(named: 'title'),
        message: any(named: 'message'),
        buttonTitle: any(named: 'buttonTitle'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => navigationService.openUrl(
        any(),
        external: any(named: 'external'),
      ),
    ).thenAnswer((_) async {});
  });

  tearDown(() {
    container.dispose();
  });

  /// getNeedUpdate が呼ばれるたびに [results] を先頭から順に返す。
  void stubNeedUpdate(List<Result<NeedAppUpdateDTO>> results) {
    var index = 0;
    when(() => checkAppUpdateUseCase.getNeedUpdate())
        .thenAnswer((_) async => results[index++]);
  }

  test('アップデートが不要なら、マスターデータの確認へ進む', () async {
    stubNeedUpdate([const Result.success(NeedAppUpdateDTO(value: false))]);

    await container.read(checkAppUpdateViewModelProvider.notifier).onLoad();

    verify(() => navigationService.goToCheckMasterUpdate()).called(1);
    verifyNever(
      () => navigationService.showAlert(
        title: any(named: 'title'),
        message: any(named: 'message'),
        buttonTitle: any(named: 'buttonTitle'),
      ),
    );
    expect(container.read(checkAppUpdateViewModelProvider).isLoading, isFalse);
  });

  test('バージョンの取得に失敗したら、アラートを閉じた後にやり直す', () async {
    stubNeedUpdate([
      const Result.failure(CustomException(title: 'エラー', text: '取得に失敗')),
      const Result.success(NeedAppUpdateDTO(value: false)),
    ]);

    await container.read(checkAppUpdateViewModelProvider.notifier).onLoad();

    verify(
      () => navigationService.showAlert(
        title: 'エラー',
        message: 'アプリバージョンの取得に失敗しました',
      ),
    ).called(1);
    verify(() => checkAppUpdateUseCase.getNeedUpdate()).called(2);
    verify(() => navigationService.goToCheckMasterUpdate()).called(1);
  });

  test('アップデートが必要なら、ストアへ誘導して先へは進まない', () async {
    stubNeedUpdate([
      const Result.success(NeedAppUpdateDTO(value: true)),
      // ストアから戻ってきたときにはアップデート済みになっている想定。
      const Result.success(NeedAppUpdateDTO(value: false)),
    ]);

    await container.read(checkAppUpdateViewModelProvider.notifier).onLoad();

    verifyInOrder([
      () => navigationService.showAlert(
            title: 'バージョンエラー',
            message: '最新のバージョンがリリースされています。アプリをアップデートしてください。',
            buttonTitle: 'ストアを開く',
          ),
      () => navigationService.goToCheckMasterUpdate(),
    ]);
    verify(() => checkAppUpdateUseCase.getNeedUpdate()).called(2);
  });
}
