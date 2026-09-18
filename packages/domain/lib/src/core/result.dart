import 'package:freezed_annotation/freezed_annotation.dart';

import '../exception/domain_exception.dart';

part 'result.freezed.dart';

/// 失敗しうる処理の結果。失敗は [DomainException] の種類で表す。
///
/// Repository などは想定内の失敗（通信・サーバーのデータ・端末の保存領域）を
/// 例外として投げずに、必ずこの型に包んで返す。呼ぶ側は try / catch せずに、
/// 成功か失敗かを確かめるだけでよい。バグ（Error）は包まずにそのまま流す。
@freezed
sealed class Result<T> with _$Result<T> {
  const factory Result.success(T value) = Success<T>;
  const factory Result.failure(DomainException exception) = Failure<T>;
}
