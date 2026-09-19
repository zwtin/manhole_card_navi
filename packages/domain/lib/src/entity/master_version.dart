import 'package:freezed_annotation/freezed_annotation.dart';

part 'master_version.freezed.dart';

/// 大小は比べず、一致しなければ取り直す。古いバージョンに戻したいときも、
/// Remote Config の値を戻すだけで済むように。
@freezed
abstract class MasterVersion with _$MasterVersion {
  const factory MasterVersion({
    required String value,
  }) = _MasterVersion;
}
