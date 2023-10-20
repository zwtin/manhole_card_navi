import 'package:freezed_annotation/freezed_annotation.dart';

part 'is_first_open.freezed.dart';

@freezed
abstract class IsFirstOpen with _$IsFirstOpen {
  const factory IsFirstOpen({
    required bool value,
  }) = _IsFirstOpen;
  const IsFirstOpen._();
}
