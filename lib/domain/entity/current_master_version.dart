import 'package:freezed_annotation/freezed_annotation.dart';

part 'current_master_version.freezed.dart';

@freezed
abstract class CurrentMasterVersion implements _$CurrentMasterVersion {
  const factory CurrentMasterVersion({
    required String version,
  }) = _CurrentMasterVersion;
  const CurrentMasterVersion._();
}
