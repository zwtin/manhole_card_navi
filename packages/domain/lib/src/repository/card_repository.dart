import 'dart:typed_data';

import 'package:riverpod/riverpod.dart';

import 'package:domain/src/core/result.dart';
import 'package:domain/src/entity/manhole_card.dart';

final cardRepositoryProvider = Provider<CardRepository>(
  (ref) =>
      throw UnimplementedError('cardRepositoryProvider must be overridden'),
);

abstract class CardRepository {
  Future<Result<ManholeCard>> get({required String id});

  Future<Result<List<ManholeCard>>> fetchAll();

  /// エンコードされたままの画像（JPEG など）。
  Future<Result<Uint8List>> fetchImage({
    required String cardId,
    int? maxWidth,
  });
}
