import 'package:freezed_annotation/freezed_annotation.dart';

part 'prefecture.freezed.dart';

@freezed
abstract class Prefecture with _$Prefecture {
  const factory Prefecture({
    required String id,
    required String name,
  }) = _Prefecture;
  const Prefecture._();

  bool get isNationwide => id == '000';
}
