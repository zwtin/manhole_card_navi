import 'package:manhole_card_navi/domain/entity/inquired_app_version.dart';

import '/domain/entity/result.dart';

abstract class RemoteConfigRepository {
  Future<Result<InquiredAppVersion>> getInquiredAppVersion();
  Future<Result<String>> getTermsOfService();
}
