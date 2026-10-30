import 'package:freezed_annotation/freezed_annotation.dart';

part 'terms_of_service_view_data.freezed.dart';

@freezed
abstract class TermsOfServiceViewData with _$TermsOfServiceViewData {
  const factory TermsOfServiceViewData({@Default('') String html}) =
      _TermsOfServiceViewData;
}
