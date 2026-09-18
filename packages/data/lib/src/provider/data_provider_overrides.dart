import 'package:domain/domain.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../repository/already_get_card_repository_impl.dart';
import '../repository/analytics_repository_impl.dart';
import '../repository/app_badge_repository_impl.dart';
import '../repository/app_info_repository_impl.dart';
import '../repository/card_image_repository_impl.dart';
import '../repository/card_repository_impl.dart';
import '../repository/location_repository_impl.dart';
import '../repository/master_data_repository_impl.dart';
import '../repository/master_version_repository_impl.dart';
import '../repository/privacy_policy_repository_impl.dart';
import '../repository/push_notification_repository_impl.dart';
import '../repository/search_condition_repository_impl.dart';
import '../repository/terms_of_service_repository_impl.dart';
import '../service/crashlytics_error_reporter.dart';
import 'platform_provider.dart';

/// domain パッケージが宣言した Repository / ErrorReporter の provider を、この
/// パッケージの実装に差し替える。main.dart の ProviderScope に渡す。
///
/// 実装が [sharedPreferencesProvider] / [packageInfoProvider] を読むため、
/// その 2 つも合わせて override すること。
final List<Override> dataProviderOverrides = [
  alreadyGetCardRepositoryProvider.overrideWith((ref) {
    final repository = AlreadyGetCardRepositoryImpl(
      ref.watch(sharedPreferencesProvider),
    );
    ref.onDispose(repository.dispose);
    return repository;
  }),
  analyticsRepositoryProvider.overrideWith((ref) {
    final repository = AnalyticsRepositoryImpl();
    ref.onDispose(repository.dispose);
    return repository;
  }),
  appBadgeRepositoryProvider.overrideWith((ref) {
    final repository = AppBadgeRepositoryImpl();
    ref.onDispose(repository.dispose);
    return repository;
  }),
  appInfoRepositoryProvider.overrideWith((ref) {
    final repository = AppInfoRepositoryImpl(ref.watch(packageInfoProvider));
    ref.onDispose(repository.dispose);
    return repository;
  }),
  cardImageRepositoryProvider.overrideWith((ref) {
    final repository = CardImageRepositoryImpl();
    ref.onDispose(repository.dispose);
    return repository;
  }),
  cardRepositoryProvider.overrideWith((ref) {
    final repository = CardRepositoryImpl();
    ref.onDispose(repository.dispose);
    return repository;
  }),
  locationRepositoryProvider.overrideWith((ref) {
    final repository = LocationRepositoryImpl();
    ref.onDispose(repository.dispose);
    return repository;
  }),
  masterDataRepositoryProvider.overrideWith((ref) {
    final repository = MasterDataRepositoryImpl();
    ref.onDispose(repository.dispose);
    return repository;
  }),
  masterVersionRepositoryProvider.overrideWith((ref) {
    final repository = MasterVersionRepositoryImpl(
      ref.watch(sharedPreferencesProvider),
    );
    ref.onDispose(repository.dispose);
    return repository;
  }),
  privacyPolicyRepositoryProvider.overrideWith((ref) {
    final repository = PrivacyPolicyRepositoryImpl();
    ref.onDispose(repository.dispose);
    return repository;
  }),
  pushNotificationRepositoryProvider.overrideWith((ref) {
    final repository = PushNotificationRepositoryImpl();
    ref.onDispose(repository.dispose);
    return repository;
  }),
  searchConditionRepositoryProvider.overrideWith((ref) {
    final repository = SearchConditionRepositoryImpl(
      ref.watch(sharedPreferencesProvider),
    );
    ref.onDispose(repository.dispose);
    return repository;
  }),
  termsOfServiceRepositoryProvider.overrideWith((ref) {
    final repository = TermsOfServiceRepositoryImpl(
      ref.watch(sharedPreferencesProvider),
    );
    ref.onDispose(repository.dispose);
    return repository;
  }),
  errorReporterProvider.overrideWith(
    (ref) => CrashlyticsErrorReporter(FirebaseCrashlytics.instance),
  ),
];
