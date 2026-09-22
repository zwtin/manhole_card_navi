import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:domain/src/core/domain_exception.dart';

part 'result.freezed.dart';

@freezed
sealed class Result<T> with _$Result<T> {
  const factory Result.success(T value) = Success<T>;
  const factory Result.failure(DomainException exception) = Failure<T>;
}
