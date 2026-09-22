import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'infrastructure.dart';

/// domain が宣言した Repository の provider を、data の実装に差し替える。
/// main.dart の ProviderScope に渡す。
///
/// どの実装を、どの DataSource で作るかを決めるのは、アプリの中でここだけ。
List<Override> repositoryOverrides(Infrastructure infrastructure) {
  final crashlytics = infrastructure.crashlytics;
  return [
    alreadyGetCardRepositoryProvider.overrideWith(
      (_) => AlreadyGetCardRepositoryImpl(
        infrastructure.preferences,
        crashlytics,
      ),
    ),
    analyticsRepositoryProvider.overrideWith(
      (_) => AnalyticsRepositoryImpl(infrastructure.analytics, crashlytics),
    ),
    appBadgeRepositoryProvider.overrideWith(
      (_) => AppBadgeRepositoryImpl(
        const AppBadgeDataSource(),
        crashlytics,
      ),
    ),
    appInfoRepositoryProvider.overrideWith(
      (_) => AppInfoRepositoryImpl(
        infrastructure.packageInfo,
        infrastructure.remoteConfig,
        crashlytics,
      ),
    ),
    cardRepositoryProvider.overrideWith(
      (_) => CardRepositoryImpl(
        infrastructure.masterDataLocal,
        infrastructure.cardImage,
        infrastructure.analytics,
        crashlytics,
      ),
    ),
    locationRepositoryProvider.overrideWith(
      (_) => LocationRepositoryImpl(
        const LocationDataSource(),
        crashlytics,
      ),
    ),
    masterDataRepositoryProvider.overrideWith(
      (_) => MasterDataRepositoryImpl(
        infrastructure.masterDataRemote,
        infrastructure.masterDataLocal,
        crashlytics,
      ),
    ),
    masterVersionRepositoryProvider.overrideWith(
      (_) => MasterVersionRepositoryImpl(
        infrastructure.preferences,
        infrastructure.remoteConfig,
        crashlytics,
      ),
    ),
    privacyPolicyRepositoryProvider.overrideWith(
      (_) => PrivacyPolicyRepositoryImpl(
        infrastructure.remoteConfig,
        crashlytics,
      ),
    ),
    pushNotificationRepositoryProvider.overrideWith(
      (_) => PushNotificationRepositoryImpl(
        infrastructure.pushNotification,
        crashlytics,
      ),
    ),
    searchConditionRepositoryProvider.overrideWith(
      (_) => SearchConditionRepositoryImpl(
        infrastructure.preferences,
        crashlytics,
      ),
    ),
    termsOfServiceRepositoryProvider.overrideWith(
      (_) => TermsOfServiceRepositoryImpl(
        infrastructure.preferences,
        infrastructure.remoteConfig,
        crashlytics,
      ),
    ),
    userRepositoryProvider.overrideWith(
      (_) => UserRepositoryImpl(
        infrastructure.auth,
        infrastructure.analytics,
        crashlytics,
      ),
    ),
  ];
}
