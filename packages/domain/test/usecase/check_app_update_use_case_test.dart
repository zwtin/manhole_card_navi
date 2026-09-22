import 'package:mocktail/mocktail.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import 'package:domain/domain.dart';

class MockAppInfoRepository extends Mock implements AppInfoRepository {}

void main() {
  late MockAppInfoRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = MockAppInfoRepository();
    container = ProviderContainer(
      overrides: [appInfoRepositoryProvider.overrideWithValue(repository)],
    );
  });

  tearDown(() {
    container.dispose();
  });

  Future<Result<bool>> getNeedUpdate({
    required String current,
    required String inquired,
  }) {
    when(() => repository.getAppInfo()).thenAnswer(
      (_) async => Result.success(
        AppInfo(name: 'マンホールカードナビ', version: AppVersion.parse(current)),
      ),
    );
    when(() => repository.getInquiredVersion()).thenAnswer(
      (_) async => Result.success(AppVersion.parse(inquired)),
    );
    return container.read(checkAppUpdateUseCaseProvider).getNeedUpdate();
  }

  test('必要なバージョンより古ければ、アップデートが必要', () async {
    final result = await getNeedUpdate(current: '1.4.9', inquired: '1.5.0');

    expect((result as Success<bool>).value, isTrue);
  });

  test('必要なバージョンと同じなら、アップデートは不要', () async {
    final result = await getNeedUpdate(current: '1.5.0', inquired: '1.5.0');

    expect((result as Success<bool>).value, isFalse);
  });

  test('必要なバージョンより新しければ、後ろの桁が小さくてもアップデートは不要', () async {
    final result = await getNeedUpdate(current: '1.4.0', inquired: '1.3.5');

    expect((result as Success<bool>).value, isFalse);
  });

  test('必要なバージョンの方が桁が多くても比べられる', () async {
    final result = await getNeedUpdate(current: '1.5', inquired: '1.5.0.1');

    expect((result as Success<bool>).value, isTrue);
  });

  test('必要なバージョンが取れなければ、失敗を返す', () async {
    when(() => repository.getAppInfo()).thenAnswer(
      (_) async => Result.success(
        AppInfo(name: 'マンホールカードナビ', version: AppVersion.parse('1.5.0')),
      ),
    );
    when(() => repository.getInquiredVersion()).thenAnswer(
      (_) async => const Result.failure(OfflineException()),
    );

    final result =
        await container.read(checkAppUpdateUseCaseProvider).getNeedUpdate();

    expect((result as Failure<bool>).exception, isA<OfflineException>());
  });
}
