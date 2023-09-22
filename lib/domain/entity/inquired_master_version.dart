import 'package:freezed_annotation/freezed_annotation.dart';

part 'inquired_master_version.freezed.dart';

@freezed
abstract class InquiredMasterVersion implements _$InquiredMasterVersion {
  const factory InquiredMasterVersion({
    required String version,
  }) = _InquiredMasterVersion;
  const InquiredMasterVersion._();
}
