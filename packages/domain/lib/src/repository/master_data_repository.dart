import 'package:riverpod/riverpod.dart';

import '../core/result.dart';
import '../entity/manhole_card.dart';
import '../entity/master_version.dart';

/// アプリ全体で 1 つ。アプリのルート（lib/di/）で data パッケージの実装に差し替える。
final masterDataRepositoryProvider =
    Provider<MasterDataRepository>(
  (ref) => throw UnimplementedError(
    'masterDataRepositoryProvider must be overridden',
  ),
);

/// マスターデータ（カード・都道府県・弾）の取得と、端末への取り込み。
///
/// 1 つのバージョンのマスターデータ一式を単位に扱う。カードの都道府県・弾は
/// サーバーでは別に持っているが、名前の引き当ては data の中で済ませ、ここでは
/// 完全なカードだけをやり取りする。
abstract class MasterDataRepository {
  /// [version] のマスターデータを取得する。
  Future<Result<List<ManholeCard>>> fetch({required MasterVersion version});

  /// 端末のマスターデータを [cards] で丸ごと入れ替える。途中で失敗したら
  /// 何も変えない。
  Future<Result<void>> replace({required List<ManholeCard> cards});

  /// 端末にマスターデータが取り込まれているか。
  Future<Result<bool>> exists();
}
