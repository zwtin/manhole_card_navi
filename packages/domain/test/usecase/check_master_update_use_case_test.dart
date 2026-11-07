import 'package:mocktail/mocktail.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import 'package:domain/domain.dart';

class MockMasterDataRepository extends Mock implements MasterDataRepository {}

class MockMasterVersionRepository extends Mock
    implements MasterVersionRepository {}

void main() {
  late MockMasterDataRepository masterDataRepository;
  late MockMasterVersionRepository masterVersionRepository;
  late ProviderContainer container;

  const inquiredVersion = MasterVersion(value: '0006');

  setUpAll(() {
    registerFallbackValue(const MasterVersion(value: ''));
  });

  setUp(() {
    masterDataRepository = MockMasterDataRepository();
    masterVersionRepository = MockMasterVersionRepository();
    container = ProviderContainer(
      overrides: [
        masterDataRepositoryProvider.overrideWithValue(masterDataRepository),
        masterVersionRepositoryProvider.overrideWithValue(
          masterVersionRepository,
        ),
      ],
    );
    when(
      () => masterVersionRepository.getInquiredVersion(),
    ).thenAnswer((_) async => const Result.success(inquiredVersion));
  });

  tearDown(() {
    container.dispose();
  });

  CheckMasterUpdateUseCase getUseCase() {
    return container.read(checkMasterUpdateUseCaseProvider);
  }

  void stubCurrentVersion(MasterVersion? version) {
    when(
      () => masterDataRepository.getCurrentVersion(),
    ).thenAnswer((_) async => Result.success(version));
  }

  group('getNeedUpdate', () {
    test('取り込み済みと要求のバージョンが違えば更新が必要', () async {
      stubCurrentVersion(const MasterVersion(value: '0005'));

      final result = await getUseCase().getNeedUpdate();

      expect((result as Success<bool>).value, isTrue);
    });

    test('取り込み済みのほうが新しくても、違えば更新が必要（古い版へ戻せる）', () async {
      stubCurrentVersion(const MasterVersion(value: '0007'));

      final result = await getUseCase().getNeedUpdate();

      expect((result as Success<bool>).value, isTrue);
    });

    test('まだ一度も取り込んでいなければ更新が必要', () async {
      stubCurrentVersion(null);

      final result = await getUseCase().getNeedUpdate();

      expect((result as Success<bool>).value, isTrue);
    });

    test('取り込み済みと要求のバージョンが同じなら更新は不要', () async {
      stubCurrentVersion(inquiredVersion);

      final result = await getUseCase().getNeedUpdate();

      expect((result as Success<bool>).value, isFalse);
    });

    test('取り込み済みのバージョンを読めなければ、失敗にせず更新が必要', () async {
      when(
        () => masterDataRepository.getCurrentVersion(),
      ).thenAnswer((_) async => const Result.failure(CorruptedDataException()));

      final result = await getUseCase().getNeedUpdate();

      expect((result as Success<bool>).value, isTrue);
    });

    test('要求バージョンの取得の失敗は、種類を変えずにそのまま返す', () async {
      const failure = OfflineException();
      when(
        () => masterVersionRepository.getInquiredVersion(),
      ).thenAnswer((_) async => const Result.failure(failure));

      final result = await getUseCase().getNeedUpdate();

      expect((result as Failure<bool>).exception, same(failure));
    });
  });

  group('updateMaster', () {
    test('要求バージョンのマスターデータで入れ替える', () async {
      when(
        () => masterDataRepository.replace(version: any(named: 'version')),
      ).thenAnswer((_) async => const Result.success(null));

      final result = await getUseCase().updateMaster();

      expect(result, isA<Success<void>>());
      verify(() => masterDataRepository.replace(version: inquiredVersion));
    });

    test('入れ替えに失敗したら、その失敗を返す', () async {
      const failure = OfflineException();
      when(
        () => masterDataRepository.replace(version: any(named: 'version')),
      ).thenAnswer((_) async => const Result.failure(failure));

      final result = await getUseCase().updateMaster();

      expect((result as Failure<void>).exception, same(failure));
    });

    test('要求バージョンを取れなければ、入れ替えない', () async {
      const failure = OfflineException();
      when(
        () => masterVersionRepository.getInquiredVersion(),
      ).thenAnswer((_) async => const Result.failure(failure));

      final result = await getUseCase().updateMaster();

      expect((result as Failure<void>).exception, same(failure));
      verifyNever(
        () => masterDataRepository.replace(version: any(named: 'version')),
      );
    });
  });
}
