import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
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
    alreadyGetCardRepositoryProvider.overrideWith((ref) {
      final repository = AlreadyGetCardRepositoryImpl(
        infrastructure.preferences,
        failureRecorder,
      );
      ref.onDispose(repository.dispose);
      return repository;
    }),
    analyticsRepositoryProvider.overrideWith((ref) {
      final repository = AnalyticsRepositoryImpl(
        FirebaseAnalytics.instance,
        failureRecorder,
      );
      ref.onDispose(repository.dispose);
      return repository;
    }),
    appBadgeRepositoryProvider.overrideWith((ref) {
      final repository = AppBadgeRepositoryImpl(failureRecorder);
      ref.onDispose(repository.dispose);
      return repository;
    }),
    appInfoRepositoryProvider.overrideWith((ref) {
      final repository = AppInfoRepositoryImpl(
        infrastructure.packageInfo,
        infrastructure.remoteConfig,
        failureRecorder,
      );
      ref.onDispose(repository.dispose);
      return repository;
    }),
    cardImageRepositoryProvider.overrideWith((ref) {
      final repository = CardImageRepositoryImpl(CardImageCacheManager());
      ref.onDispose(repository.dispose);
      return repository;
    }),
    cardRepositoryProvider.overrideWith((ref) {
      final repository = CardRepositoryImpl(
        infrastructure.masterData,
        failureRecorder,
      );
      ref.onDispose(repository.dispose);
      return repository;
    }),
    locationRepositoryProvider.overrideWith((ref) {
      final repository = LocationRepositoryImpl(
        const LocationDataSource(),
        failureRecorder,
      );
      ref.onDispose(repository.dispose);
      return repository;
    }),
    masterDataRepositoryProvider.overrideWith((ref) {
      final repository = MasterDataRepositoryImpl(
        FirebaseFirestore.instance,
        infrastructure.masterData,
        failureRecorder,
      );
      ref.onDispose(repository.dispose);
      return repository;
    }),
    masterVersionRepositoryProvider.overrideWith((ref) {
      final repository = MasterVersionRepositoryImpl(
        infrastructure.preferences,
        infrastructure.remoteConfig,
        failureRecorder,
      );
      ref.onDispose(repository.dispose);
      return repository;
    }),
    privacyPolicyRepositoryProvider.overrideWith((ref) {
      final repository = PrivacyPolicyRepositoryImpl(
        infrastructure.remoteConfig,
        failureRecorder,
      );
      ref.onDispose(repository.dispose);
      return repository;
    }),
    pushNotificationRepositoryProvider.overrideWith((ref) {
      final repository = PushNotificationRepositoryImpl(
        FirebaseMessaging.instance,
        failureRecorder,
      );
      ref.onDispose(repository.dispose);
      return repository;
    }),
    searchConditionRepositoryProvider.overrideWith((ref) {
      final repository = SearchConditionRepositoryImpl(
        infrastructure.preferences,
        failureRecorder,
      );
      ref.onDispose(repository.dispose);
      return repository;
    }),
    termsOfServiceRepositoryProvider.overrideWith((ref) {
      final repository = TermsOfServiceRepositoryImpl(
        infrastructure.preferences,
        infrastructure.remoteConfig,
        failureRecorder,
      );
      ref.onDispose(repository.dispose);
      return repository;
    }),
    userRepositoryProvider.overrideWith((ref) {
      final repository = UserRepositoryImpl(
        FirebaseAuth.instance,
        FirebaseAnalytics.instance,
        FirebaseCrashlytics.instance,
        failureRecorder,
      );
      ref.onDispose(repository.dispose);
      return repository;
    }),
  ];
}
