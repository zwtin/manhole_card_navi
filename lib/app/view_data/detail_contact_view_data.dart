import 'package:freezed_annotation/freezed_annotation.dart';

part 'detail_contact_view_data.freezed.dart';

@freezed
abstract class DetailContactViewData with _$DetailContactViewData {
  const factory DetailContactViewData({
    required String id,
    required String name,
    required String nameUrl,
    required String address,
    required String phoneNumber,
    required String other,
    required String time,
    required String timeOther,
  }) = _DetailContactViewData;
  const DetailContactViewData._();
}
