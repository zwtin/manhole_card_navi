import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'infrastructure.dart';

/// domain が宣言した Repository の provider を、data の実装に差し替える。
/// main.dart の ProviderScope に渡す。
///
/// どの実装を、どの部品（[Infrastructure] と Firebase の各インスタンス）で作るかを
/// 決めるのは、アプリの中でここだけ。
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
        infrastructure.masterData,
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
        FirebaseFirestore.instance,
        infrastructure.masterData,
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
        FirebaseMessaging.instance,
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
        FirebaseAuth.instance,
        infrastructure.analytics,
        crashlytics,
      ),
    ),
  ];
}
