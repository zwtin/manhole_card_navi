import 'package:freezed_annotation/freezed_annotation.dart';

part 'prefecture.freezed.dart';

@freezed
abstract class Prefecture with _$Prefecture {
  const factory Prefecture({
    required String id,
    required String name,
  }) = _Prefecture;
  const Prefecture._();

  /// 国の機関・全国組織のカードは、master で名前のない都道府県（コード 000）に
  /// 入っている。
  bool get isNationwide => name.isEmpty;
}
