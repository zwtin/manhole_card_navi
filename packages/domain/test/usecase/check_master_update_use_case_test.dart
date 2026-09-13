import 'package:domain/domain.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockCardRepository extends Mock implements CardRepository {}

class MockMasterVersionRepository extends Mock
    implements MasterVersionRepository {}

class MockPrefectureRepository extends Mock implements PrefectureRepository {}

class MockVolumeRepository extends Mock implements VolumeRepository {}

void main() {
  late MockCardRepository cardRepository;
  late MockMasterVersionRepository masterVersionRepository;
  late MockPrefectureRepository prefectureRepository;
  late MockVolumeRepository volumeRepository;
  late ProviderContainer container;

  final card = ManholeCard(
    id: '27-226-B001',
    latitude: 34.5,
    longitude: 135.6,
    name: '藤井寺市',
    publicationDate: DateTime(2026, 1, 1),
    distributionState: const ManholeCardDistributionState.distributing(),
    image: 'https://example.com/27-226-B001.jpg',
    imageSub: '',
    distributionPlaceHtml: '',
    distributionTimeHtml: '',
    stockHtml: '',
    distributionPoints: const ManholeCardDistributionPoints(list: []),
    // 取得直後のカードは都道府県名・弾名を持たない。
    prefecture: const ManholeCardPrefecture(id: '27', name: ''),
    volume: const ManholeCardVolume(id: '0000', name: ''),
  );

  setUpAll(() {
    registerFallbackValue(const InquiredMasterVersion(value: ''));
    registerFallbackValue(const CurrentMasterVersion(value: ''));
    registerFallbackValue(const ManholeCards(list: []));
    registerFallbackValue(const ManholeCardPrefectures(list: []));
    registerFallbackValue(const ManholeCardVolumes(list: []));
  });

  setUp(() {
    cardRepository = MockCardRepository();
    masterVersionRepository = MockMasterVersionRepository();
    prefectureRepository = MockPrefectureRepository();
    volumeRepository = MockVolumeRepository();
    container = ProviderContainer(
      overrides: [
        cardRepositoryProvider.overrideWithValue(cardRepository),
        masterVersionRepositoryProvider.overrideWithValue(
          masterVersionRepository,
        ),
        prefectureRepositoryProvider.overrideWithValue(prefectureRepository),
        volumeRepositoryProvider.overrideWithValue(volumeRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  CheckMasterUpdateUseCase getUseCase() {
    return container.read(checkMasterUpdateUseCaseProvider);
  }

  void stubVersions({required String current, required String inquired}) {
    when(() => masterVersionRepository.getCurrentVersion()).thenAnswer(
      (_) async => Result.success(CurrentMasterVersion(value: current)),
    );
    when(() => masterVersionRepository.getInquiredVersion()).thenAnswer(
      (_) async => Result.success(InquiredMasterVersion(value: inquired)),
    );
  }

  group('getNeedUpdate', () {
    test('取得済みと要求のバージョンが違えば更新が必要', () async {
      stubVersions(current: '0005', inquired: '0006');

      final result = await getUseCase().getNeedUpdate();

      expect((result as Success<NeedMasterUpdateDTO>).value.value, isTrue);
      verifyNever(() => cardRepository.hasMaster());
    });

    test('バージョンが同じでもローカルにカードが無ければ更新が必要', () async {
      stubVersions(current: '0006', inquired: '0006');
      when(() => cardRepository.hasMaster())
          .thenAnswer((_) async => const Result.success(false));

      final result = await getUseCase().getNeedUpdate();

      expect((result as Success<NeedMasterUpdateDTO>).value.value, isTrue);
    });

    test('バージョンが同じでローカルにカードがあれば更新は不要', () async {
      stubVersions(current: '0006', inquired: '0006');
      when(() => cardRepository.hasMaster())
          .thenAnswer((_) async => const Result.success(true));

      final result = await getUseCase().getNeedUpdate();

      expect((result as Success<NeedMasterUpdateDTO>).value.value, isFalse);
    });

    test('要求バージョンが取れていなければ、カードの有無を見ずに更新しない', () async {
      stubVersions(current: '', inquired: '');

      final result = await getUseCase().getNeedUpdate();

      expect((result as Success<NeedMasterUpdateDTO>).value.value, isFalse);
      verifyNever(() => cardRepository.hasMaster());
    });

    test('バージョンの取得に失敗したら失敗を返す', () async {
      when(() => masterVersionRepository.getCurrentVersion()).thenAnswer(
        (_) async => const Result.failure(
          CustomException(title: 'エラー', text: '取得に失敗'),
        ),
      );
      when(() => masterVersionRepository.getInquiredVersion()).thenAnswer(
        (_) async =>
            const Result.success(InquiredMasterVersion(value: '0006')),
      );

      final result = await getUseCase().getNeedUpdate();

      expect(result, isA<Failure<NeedMasterUpdateDTO>>());
    });
  });

  group('updateMaster', () {
    setUp(() {
      when(() => masterVersionRepository.getInquiredVersion()).thenAnswer(
        (_) async =>
            const Result.success(InquiredMasterVersion(value: '0006')),
      );
      when(
        () => prefectureRepository.fetchMaster(
          inquiredMasterVersion: any(named: 'inquiredMasterVersion'),
        ),
      ).thenAnswer(
        (_) async => const Result.success(
          ManholeCardPrefectures(
            list: [ManholeCardPrefecture(id: '27', name: '大阪府')],
          ),
        ),
      );
      when(() => prefectureRepository.deleteMaster())
          .thenAnswer((_) async => const Result.success(null));
      when(
        () => prefectureRepository.saveMaster(
          manholeCardPrefectures: any(named: 'manholeCardPrefectures'),
        ),
      ).thenAnswer((_) async => const Result.success(null));
      when(
        () => volumeRepository.fetchMaster(
          inquiredMasterVersion: any(named: 'inquiredMasterVersion'),
        ),
      ).thenAnswer(
        (_) async => const Result.success(
          ManholeCardVolumes(
            list: [ManholeCardVolume(id: '0000', name: '第1弾')],
          ),
        ),
      );
      when(() => volumeRepository.deleteMaster())
          .thenAnswer((_) async => const Result.success(null));
      when(
        () => volumeRepository.saveMaster(
          manholeCardVolumes: any(named: 'manholeCardVolumes'),
        ),
      ).thenAnswer((_) async => const Result.success(null));
      when(
        () => cardRepository.fetchMaster(
          inquiredMasterVersion: any(named: 'inquiredMasterVersion'),
        ),
      ).thenAnswer((_) async => Result.success(ManholeCards(list: [card])));
      when(() => cardRepository.deleteMaster())
          .thenAnswer((_) async => const Result.success(null));
      when(
        () => cardRepository.saveMaster(
          manholeCards: any(named: 'manholeCards'),
        ),
      ).thenAnswer((_) async => const Result.success(null));
      when(
        () => masterVersionRepository.setCurrentVersion(
          currentMasterVersion: any(named: 'currentMasterVersion'),
        ),
      ).thenAnswer((_) async => const Result.success(null));
    });

    test('カードより先に都道府県・弾を取り込む', () async {
      final result = await getUseCase().updateMaster();

      expect(result, isA<Success<void>>());
      verifyInOrder([
        () => prefectureRepository.saveMaster(
              manholeCardPrefectures: any(named: 'manholeCardPrefectures'),
            ),
        () => volumeRepository.saveMaster(
              manholeCardVolumes: any(named: 'manholeCardVolumes'),
            ),
        () => cardRepository.saveMaster(
              manholeCards: any(named: 'manholeCards'),
            ),
      ]);
    });

    test('都道府県名・弾名を引き当ててからカードを保存する', () async {
      await getUseCase().updateMaster();

      final saved = verify(
        () => cardRepository.saveMaster(
          manholeCards: captureAny(named: 'manholeCards'),
        ),
      ).captured.single as ManholeCards;
      expect(saved.list.single.prefecture.name, '大阪府');
      expect(saved.list.single.volume.name, '第1弾');
    });

    test('取り込みが終わったら取得済みバージョンを要求バージョンにする', () async {
      await getUseCase().updateMaster();

      verify(
        () => masterVersionRepository.setCurrentVersion(
          currentMasterVersion: const CurrentMasterVersion(value: '0006'),
        ),
      ).called(1);
    });

    test('カードの取得に失敗したら、取得済みバージョンを更新しない', () async {
      when(
        () => cardRepository.fetchMaster(
          inquiredMasterVersion: any(named: 'inquiredMasterVersion'),
        ),
      ).thenAnswer(
        (_) async => const Result.failure(
          CustomException(title: 'エラー', text: '取得に失敗'),
        ),
      );

      final result = await getUseCase().updateMaster();

      expect(result, isA<Failure<void>>());
      verifyNever(
        () => masterVersionRepository.setCurrentVersion(
          currentMasterVersion: any(named: 'currentMasterVersion'),
        ),
      );
    });
  });
}
