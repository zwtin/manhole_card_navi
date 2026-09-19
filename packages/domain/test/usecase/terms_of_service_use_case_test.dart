import 'package:mocktail/mocktail.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import 'package:domain/domain.dart';

class MockTermsOfServiceRepository extends Mock
    implements TermsOfServiceRepository {}

void main() {
  late MockTermsOfServiceRepository repository;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(const TermsOfServiceVersion(value: ''));
  });

  setUp(() {
    repository = MockTermsOfServiceRepository();
    container = ProviderContainer(
      overrides: [
        termsOfServiceRepositoryProvider.overrideWithValue(repository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  void stubAgreed(String? value) {
    when(() => repository.getAgreedVersion()).thenAnswer(
      (_) async => Result.success(
        value == null ? null : TermsOfServiceVersion(value: value),
      ),
    );
  }

  void stubInquired(String value) {
    when(() => repository.getInquiredVersion()).thenAnswer(
      (_) async => Result.success(TermsOfServiceVersion(value: value)),
    );
  }

  group('TermsOfServiceUseCase.getNeedAgree', () {
    test('一度も同意していなければ同意が必要', () async {
      stubAgreed(null);

      final result = await container
          .read(termsOfServiceUseCaseProvider)
          .getNeedAgree();

      expect((result as Success<bool>).value, isTrue);
    });

    test('同意済みのバージョンがあれば同意は不要', () async {
      stubAgreed('2');

      final result = await container
          .read(termsOfServiceUseCaseProvider)
          .getNeedAgree();

      expect((result as Success<bool>).value, isFalse);
    });
  });

  group('TermsOfServiceUseCase.getNeedUpdate', () {
    test('同意済みと要求のバージョンが違えば再同意が必要', () async {
      stubAgreed('1');
      stubInquired('2');

      final result = await container
          .read(termsOfServiceUseCaseProvider)
          .getNeedUpdate();

      expect((result as Success<bool>).value, isTrue);
    });

    test('同意済みと要求のバージョンが同じなら再同意は不要', () async {
      stubAgreed('2');
      stubInquired('2');

      final result = await container
          .read(termsOfServiceUseCaseProvider)
          .getNeedUpdate();

      expect((result as Success<bool>).value, isFalse);
    });
  });

  group('TermsOfServiceUseCase.agree', () {
    test('要求バージョンを同意済みバージョンとして保存する', () async {
      stubInquired('3');
      when(
        () => repository.setAgreedVersion(version: any(named: 'version')),
      ).thenAnswer((_) async => const Result.success(null));

      final result = await container
          .read(termsOfServiceUseCaseProvider)
          .agree();

      expect(result, isA<Success<void>>());
      verify(
        () => repository.setAgreedVersion(
          version: const TermsOfServiceVersion(value: '3'),
        ),
      ).called(1);
    });

    test('要求バージョンが取れなければ保存しない', () async {
      when(() => repository.getInquiredVersion()).thenAnswer(
        (_) async => const Result.failure(OfflineException()),
      );

      final result = await container
          .read(termsOfServiceUseCaseProvider)
          .agree();

      expect(result, isA<Failure<void>>());
      verifyNever(
        () => repository.setAgreedVersion(version: any(named: 'version')),
      );
    });
  });
}
