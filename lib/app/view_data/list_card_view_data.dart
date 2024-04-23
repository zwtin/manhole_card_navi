import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'list_card_view_data.freezed.dart';

@freezed
abstract class ListCardViewData with _$ListCardViewData {
  const factory ListCardViewData({
    required String id,
    required Uint8List icon,
    required String name,
    required String volume,
    required String publicationDate,
    required bool isHidden,
  }) = _ListCardViewData;
  const ListCardViewData._();
}
