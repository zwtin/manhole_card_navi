import 'dart:typed_data';

import 'package:riverpod/riverpod.dart';

import '../core/result.dart';
import '../entity/manhole_card.dart';

/// アプリ全体で 1 つ。アプリのルート（lib/di/）で data パッケージの実装に差し替える。
final cardRepositoryProvider = Provider<CardRepository>(
  (ref) =>
      throw UnimplementedError('cardRepositoryProvider must be overridden'),
);

abstract class CardRepository {
  Future<Result<ManholeCard>> get({required String id});

  /// 端末に取り込んだすべてのカード。
  Future<Result<List<ManholeCard>>> fetchAll();

  /// [cardId] のカードの画像のデータ（JPEG などのエンコード済みのバイト列）。
  ///
  /// [maxWidth] を渡すと、その幅に縮小した画像を返す。どこから取るか・端末に
  /// 保存して使い回すかは data が決める。
  Future<Result<Uint8List>> fetchImage({
    required String cardId,
    int? maxWidth,
  });
}
