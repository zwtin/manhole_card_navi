import 'package:riverpod/riverpod.dart';

import '../core/result.dart';
import '../entity/master_version.dart';

/// アプリ全体で 1 つ。アプリのルート（lib/di/）で data パッケージの実装に差し替える。
final masterDataRepositoryProvider =
    Provider<MasterDataRepository>(
  (ref) => throw UnimplementedError(
    'masterDataRepositoryProvider must be overridden',
  ),
);

/// マスターデータ（カード・都道府県・弾）の端末への取り込み。
///
/// 1 つのバージョンのマスターデータ一式を単位に扱う。サーバーから取って端末に
/// 書くまでを data の中で済ませ、カードは domain を通さない。取り込んだカードは
/// `CardRepository` で読む。
abstract class MasterDataRepository {
  /// サーバーから [version] のマスターデータを取得し、端末のものと丸ごと入れ替える。
  /// 途中で失敗したら何も変えない。
  Future<Result<void>> replace({required MasterVersion version});

  /// 端末にマスターデータが取り込まれているか。
  Future<Result<bool>> exists();
}
