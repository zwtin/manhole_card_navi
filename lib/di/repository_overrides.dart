import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
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
  final failureRecorder = infrastructure.failureRecorder;
  return [
    alreadyGetCardRepositoryProvider.overrideWith(
      (_) => AlreadyGetCardRepositoryImpl(
        infrastructure.preferences,
        failureRecorder,
      ),
    ),
    analyticsRepositoryProvider.overrideWith(
      (_) => AnalyticsRepositoryImpl(
        FirebaseAnalytics.instance,
        failureRecorder,
      ),
    ),
    appBadgeRepositoryProvider.overrideWith(
      (_) => AppBadgeRepositoryImpl(failureRecorder),
    ),
    appInfoRepositoryProvider.overrideWith(
      (_) => AppInfoRepositoryImpl(
        infrastructure.packageInfo,
        infrastructure.remoteConfig,
        failureRecorder,
      ),
    ),
    cardRepositoryProvider.overrideWith(
      (_) => CardRepositoryImpl(
        infrastructure.masterData,
        infrastructure.cardImage,
        failureRecorder,
      ),
    ),
    locationRepositoryProvider.overrideWith(
      (_) => LocationRepositoryImpl(
        const LocationDataSource(),
        failureRecorder,
      ),
    ),
    masterDataRepositoryProvider.overrideWith(
      (_) => MasterDataRepositoryImpl(
        FirebaseFirestore.instance,
        infrastructure.masterData,
        failureRecorder,
      ),
    ),
    masterVersionRepositoryProvider.overrideWith(
      (_) => MasterVersionRepositoryImpl(
        infrastructure.preferences,
        infrastructure.remoteConfig,
        failureRecorder,
      ),
    ),
    privacyPolicyRepositoryProvider.overrideWith(
      (_) => PrivacyPolicyRepositoryImpl(
        infrastructure.remoteConfig,
        failureRecorder,
      ),
    ),
    pushNotificationRepositoryProvider.overrideWith(
      (_) => PushNotificationRepositoryImpl(
        FirebaseMessaging.instance,
        failureRecorder,
      ),
    ),
    searchConditionRepositoryProvider.overrideWith(
      (_) => SearchConditionRepositoryImpl(
        infrastructure.preferences,
        failureRecorder,
      ),
    ),
    termsOfServiceRepositoryProvider.overrideWith(
      (_) => TermsOfServiceRepositoryImpl(
        infrastructure.preferences,
        infrastructure.remoteConfig,
        failureRecorder,
      ),
    ),
    userRepositoryProvider.overrideWith(
      (_) => UserRepositoryImpl(
        FirebaseAuth.instance,
        FirebaseAnalytics.instance,
        infrastructure.crashlytics,
        failureRecorder,
      ),
    ),
  ];
}
