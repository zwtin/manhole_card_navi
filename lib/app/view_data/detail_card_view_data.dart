import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import '/app/view_data/detail_contact_view_data.dart';

part 'detail_card_view_data.freezed.dart';

@freezed
abstract class DetailCardViewData with _$DetailCardViewData {
  const factory DetailCardViewData({
    required String id,
    required String imageUrl,
    required String name,
    required String prefecture,
    required String volume,
    required String publicationDate,
    required List<DetailContactViewData> contacts,
    required String distributionLinkText,
    required String distributionLinkUrl,
    required String distributionText,
    required String distributionOther,
  }) = _DetailCardViewData;
  const DetailCardViewData._();
}
