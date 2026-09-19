import 'package:json_annotation/json_annotation.dart';

import 'package:data/src/model/malformed_data_exception.dart';

T decodeModel<T>(
  Map<String, dynamic> json,
  T Function(Map<String, dynamic> json) fromJson, {
  required String source,
}) {
  try {
    return fromJson(json);
  } on CheckedFromJsonException catch (error, stackTrace) {
    throw MalformedDataException(
      '$source の ${error.key} が読めません（${error.message}）',
      cause: error,
      stackTrace: stackTrace,
    );
  }
}
