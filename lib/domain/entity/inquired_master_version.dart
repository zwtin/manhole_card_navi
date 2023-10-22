import 'package:freezed_annotation/freezed_annotation.dart';

part 'inquired_master_version.freezed.dart';

@freezed
abstract class InquiredMasterVersion with _$InquiredMasterVersion {
  const factory InquiredMasterVersion({
    required String value,
  }) = _InquiredMasterVersion;
  const InquiredMasterVersion._();
}
