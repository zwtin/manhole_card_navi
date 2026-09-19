import 'package:domain/domain.dart';
import 'package:json_annotation/json_annotation.dart';

/// 外から受け取った JSON（Firestore のドキュメント・端末のファイル）を model にする。
///
/// 形が想定と違えば（項目の欠け・型の違い・知らない値）、[CorruptedDataException]
/// にする。[source] はどのデータがおかしいかを調べるための補足に使う。
T decodeModel<T>(
  Map<String, dynamic> json,
  T Function(Map<String, dynamic> json) fromJson, {
  required String source,
}) {
  try {
    return fromJson(json);
  } on CheckedFromJsonException catch (error, stackTrace) {
    throw CorruptedDataException(
      detail: '$source の ${error.key} が読めません（${error.message}）',
      cause: error,
      stackTrace: stackTrace,
    );
  }
}
