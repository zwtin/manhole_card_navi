import 'package:domain/domain.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

class MockMasterDataRepository extends Mock implements MasterDataRepository {}

class MockMasterVersionRepository extends Mock
    implements MasterVersionRepository {}

void main() {
  late MockMasterDataRepository masterDataRepository;
  late MockMasterVersionRepository masterVersionRepository;
  late ProviderContainer container;

  const inquiredVersion = MasterVersion(value: '0006');

  final card = ManholeCard(
    id: '27-226-B001',
    position: const Coordinate(latitude: 34.5, longitude: 135.6),
    name: '藤井寺市',
    publicationDate: DateTime(2026, 1, 1),
    distributionState: DistributionState.distributing,
    image: 'https://example.com/27-226-B001.jpg',
    imageSub: '',
    distributionPlaceHtml: '',
    distributionTimeHtml: '',
    stockHtml: '',
    distributionPoints: const [],
    prefecture: const Prefecture(id: '27', name: '大阪府'),
    volume: const Volume(id: '0000', name: '第1弾'),
  );

  setUpAll(() {
    registerFallbackValue(const MasterVersion(value: ''));
    registerFallbackValue(<ManholeCard>[]);
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
    when(() => masterVersionRepository.getInquiredVersion())
        .thenAnswer((_) async => const Result.success(inquiredVersion));
  });

  tearDown(() {
    container.dispose();
  });

  CheckMasterUpdateUseCase getUseCase() {
    return container.read(checkMasterUpdateUseCaseProvider);
  }

  void stubCurrentVersion(MasterVersion? version) {
    when(() => masterVersionRepository.getCurrentVersion())
        .thenAnswer((_) async => Result.success(version));
  }

  group('getNeedUpdate', () {
    test('取り込み済みと要求のバージョンが違えば更新が必要', () async {
      stubCurrentVersion(const MasterVersion(value: '0005'));

      final result = await getUseCase().getNeedUpdate();

      expect((result as Success<bool>).value, isTrue);
      verifyNever(() => masterDataRepository.exists());
    });

    test('まだ一度も取り込んでいなければ更新が必要', () async {
      stubCurrentVersion(null);

      final result = await getUseCase().getNeedUpdate();

      expect((result as Success<bool>).value, isTrue);
    });

    test('バージョンが同じでも端末にマスターデータが無ければ更新が必要', () async {
      stubCurrentVersion(inquiredVersion);
      when(() => masterDataRepository.exists())
          .thenAnswer((_) async => const Result.success(false));

      final result = await getUseCase().getNeedUpdate();

      expect((result as Success<bool>).value, isTrue);
    });

    test('バージョンが同じで端末にマスターデータがあれば更新は不要', () async {
      stubCurrentVersion(inquiredVersion);
      when(() => masterDataRepository.exists())
          .thenAnswer((_) async => const Result.success(true));

      final result = await getUseCase().getNeedUpdate();

      expect((result as Success<bool>).value, isFalse);
    });

    test('要求バージョンの取得の失敗は、種類を変えずにそのまま返す', () async {
      const failure = OfflineException();
      when(() => masterVersionRepository.getInquiredVersion())
          .thenAnswer((_) async => const Result.failure(failure));

      final result = await getUseCase().getNeedUpdate();

      expect((result as Failure<bool>).exception, same(failure));
    });
  });

  group('updateMaster', () {
    setUp(() {
      when(() => masterDataRepository.fetch(version: any(named: 'version')))
          .thenAnswer((_) async => Result.success([card]));
      when(() => masterDataRepository.replace(cards: any(named: 'cards')))
          .thenAnswer((_) async => const Result.success(null));
      when(
        () => masterVersionRepository.setCurrentVersion(
          version: any(named: 'version'),
        ),
      ).thenAnswer((_) async => const Result.success(null));
    });

    test('要求バージョンのマスターデータで入れ替えてから、取り込み済みバージョンを記録する',
        () async {
      final result = await getUseCase().updateMaster();

      expect(result, isA<Success<void>>());
      verifyInOrder([
        () => masterDataRepository.fetch(version: inquiredVersion),
        () => masterDataRepository.replace(cards: [card]),
        () => masterVersionRepository.setCurrentVersion(
              version: inquiredVersion,
            ),
      ]);
    });

    test('取得に失敗したら、入れ替えも記録もせずに失敗を返す', () async {
      const failure = OfflineException();
      when(() => masterDataRepository.fetch(version: any(named: 'version')))
          .thenAnswer((_) async => const Result.failure(failure));

      final result = await getUseCase().updateMaster();

      expect((result as Failure<void>).exception, same(failure));
      verifyNever(() => masterDataRepository.replace(cards: any(named: 'cards')));
      verifyNever(
        () => masterVersionRepository.setCurrentVersion(
          version: any(named: 'version'),
        ),
      );
    });

    test('入れ替えに失敗したら、取り込み済みバージョンを記録しない', () async {
      const failure = PersistenceException();
      when(() => masterDataRepository.replace(cards: any(named: 'cards')))
          .thenAnswer((_) async => const Result.failure(failure));

      final result = await getUseCase().updateMaster();

      expect((result as Failure<void>).exception, same(failure));
      verifyNever(
        () => masterVersionRepository.setCurrentVersion(
          version: any(named: 'version'),
        ),
      );
    });
  });
}
