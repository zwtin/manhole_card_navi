import 'package:json_annotation/json_annotation.dart';

import 'package:data/src/model/local_card_model.dart';

part 'local_master_data_model.g.dart';

/// 端末に取り込んだマスターデータ。バージョンとカードを 1 つのファイルに一緒に
/// 書き、別々に保存しない。片方だけ入れ替わって食い違うのを防ぐため。
@JsonSerializable(checked: true, explicitToJson: true)
class LocalMasterDataModel {
  /// バージョンが空・カードが 0 件なら [FormatException]。どちらも、取り込んだ
  /// マスターデータとしては使えないため。
  LocalMasterDataModel({required this.version, required this.cards}) {
    if (version.isEmpty) {
      throw const FormatException('マスターデータのバージョンが空です');
    }
    if (cards.isEmpty) {
      throw const FormatException('マスターデータにカードがありません');
    }
  }

  factory LocalMasterDataModel.fromJson(Map<String, dynamic> json) =>
      _$LocalMasterDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$LocalMasterDataModelToJson(this);

  /// 配信したマスターデータのバージョン（Remote Config の値）。ファイルの形の
  /// バージョンとは別。
  final String version;

  final List<LocalCardModel> cards;
}
