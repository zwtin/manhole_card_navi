import 'package:freezed_annotation/freezed_annotation.dart';

part 'volume.freezed.dart';

/// カードの弾（第 1 弾・第 2 弾…）。
@freezed
abstract class Volume with _$Volume {
  const factory Volume({
    required String id,
    required String name,
  }) = _Volume;
  const Volume._();
}
