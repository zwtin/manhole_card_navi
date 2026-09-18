import 'package:freezed_annotation/freezed_annotation.dart';

part 'terms_of_service_version.freezed.dart';

/// 利用規約のバージョン。
///
/// 同意済みのバージョンが同意してもらう必要のあるバージョンと一致しなければ、
/// 再同意を求める。一致するかどうかだけを比べ、大小は比べない。
@freezed
abstract class TermsOfServiceVersion with _$TermsOfServiceVersion {
  const factory TermsOfServiceVersion({
    required String value,
  }) = _TermsOfServiceVersion;
}
