import 'package:freezed_annotation/freezed_annotation.dart';

part 'master_version.freezed.dart';

/// マスターデータのバージョン（例: `0006`）。
///
/// 一致するかどうかだけを比べ、大小は比べない。一致しなければ取り直すので、
/// 古いバージョンに戻したいときも Remote Config の値を戻すだけで済む。
@freezed
abstract class MasterVersion with _$MasterVersion {
  const factory MasterVersion({
    required String value,
  }) = _MasterVersion;
}
