import 'dart:typed_data';

import 'package:riverpod/riverpod.dart';

import '../core/result.dart';

/// アプリ全体で 1 つ。アプリのルート（lib/di/）で data パッケージの実装に差し替える。
final cardImageRepositoryProvider =
    Provider<CardImageRepository>(
  (ref) => throw UnimplementedError(
    'cardImageRepositoryProvider must be overridden',
  ),
);

/// カード画像の取得。
abstract class CardImageRepository {
  /// [url] の画像のデータ（JPEG などのエンコード済みのバイト列）を返す。
  ///
  /// 端末に保存済みならそれを返し、なければ配信元から取って保存する。[url] から
  /// 取れなければ、代わりの配信元 [subUrl] から取る。代わりがなければ空文字。
  ///
  /// [maxWidth] を渡すと、その幅に縮小した画像を返す。縮小したものも保存するので、
  /// 一覧のように小さく何度も出す画像で、毎回の縮小を省ける。
  Future<Result<Uint8List>> fetch({
    required String url,
    required String subUrl,
    int? maxWidth,
  });

  /// [fetch] と同じく [url] の画像のデータを返すが、取ってきた画像は端末に保存
  /// しない。保存済みならそれを使う。
  ///
  /// 取ってきた画像から別のもの（マップのマーカーなど）を作り、そちらを保存する
  /// ときに使う。元の画像まで保存すると、同じ絵を二重に持つことになる。
  Future<Result<Uint8List>> fetchWithoutStoring({
    required String url,
    required String subUrl,
  });
}
