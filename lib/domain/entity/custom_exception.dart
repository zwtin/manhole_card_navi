import 'package:freezed_annotation/freezed_annotation.dart';

part 'custom_exception.freezed.dart';

@freezed
abstract class CustomException with _$CustomException implements Exception {
  const factory CustomException({
    required String title,
    required String text,
  }) = _CustomException;
  const CustomException._();
}
