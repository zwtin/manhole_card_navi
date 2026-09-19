import 'dart:typed_data';

import 'package:logger/logger.dart';
import 'package:riverpod/riverpod.dart';

import '../core/result.dart';
import '../repository/card_image_repository.dart';

/// UseCase は状態を持たないので、画面ごとに分けずアプリ全体で 1 つ。
final cardImageUseCaseProvider = Provider<CardImageUseCase>(
  (ref) {
    final cardImageUseCase = CardImageUseCase(
      ref.watch(cardImageRepositoryProvider),
    );
    ref.onDispose(cardImageUseCase.dispose);
    return cardImageUseCase;
  },
);

class CardImageUseCase {
  CardImageUseCase(
    this._cardImageRepository,
  );

  final CardImageRepository _cardImageRepository;

  final _logger = Logger();

  /// カード画像のデータ。引数は [CardImageRepository.fetch] と同じ。
  Future<Result<Uint8List>> fetch({
    required String url,
    required String subUrl,
    int? maxWidth,
  }) {
    return _cardImageRepository.fetch(
      url: url,
      subUrl: subUrl,
      maxWidth: maxWidth,
    );
  }

  /// 端末に保存せずに取るカード画像のデータ。引数は
  /// [CardImageRepository.fetchWithoutStoring] と同じ。
  Future<Result<Uint8List>> fetchWithoutStoring({
    required String url,
    required String subUrl,
  }) {
    return _cardImageRepository.fetchWithoutStoring(url: url, subUrl: subUrl);
  }

  void dispose() {
    _logger.d('CardImageUseCase dispose');
  }
}
