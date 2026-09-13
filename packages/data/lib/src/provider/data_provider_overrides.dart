import 'package:domain/domain.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../query_service/already_get_card_query_service_impl.dart';
import '../query_service/distribution_cards_query_service_impl.dart';
import '../query_service/list_cards_query_service_impl.dart';
import '../query_service/position_cards_query_service_impl.dart';
import '../query_service/search_condition_query_service_impl.dart';
import '../repository/already_get_card_repository_impl.dart';
import '../repository/analytics_repository_impl.dart';
import '../repository/app_badge_repository_impl.dart';
import '../repository/app_info_repository_impl.dart';
import '../repository/card_repository_impl.dart';
import '../repository/location_repository_impl.dart';
import '../repository/master_version_repository_impl.dart';
import '../repository/prefecture_repository_impl.dart';
import '../repository/privacy_policy_repository_impl.dart';
import '../repository/push_notification_repository_impl.dart';
import '../repository/search_condition_repository_impl.dart';
import '../repository/terms_of_service_repository_impl.dart';
import '../repository/volume_repository_impl.dart';
import 'platform_provider.dart';

/// domain パッケージが宣言した Repository / QueryService の provider を、この
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
  masterVersionRepositoryProvider.overrideWith((ref) {
    final repository = MasterVersionRepositoryImpl(
      ref.watch(sharedPreferencesProvider),
    );
    ref.onDispose(repository.dispose);
    return repository;
  }),
  prefectureRepositoryProvider.overrideWith((ref) {
    final repository = PrefectureRepositoryImpl();
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
  volumeRepositoryProvider.overrideWith((ref) {
    final repository = VolumeRepositoryImpl();
    ref.onDispose(repository.dispose);
    return repository;
  }),
  alreadyGetCardQueryServiceProvider.overrideWith((ref) {
    final queryService = AlreadyGetCardQueryServiceImpl(
      ref.watch(sharedPreferencesProvider),
    );
    ref.onDispose(queryService.dispose);
    return queryService;
  }),
  distributionCardsQueryServiceProvider.overrideWith((ref) {
    final queryService = DistributionCardsQueryServiceImpl();
    ref.onDispose(queryService.dispose);
    return queryService;
  }),
  listCardsQueryServiceProvider.overrideWith((ref) {
    final queryService = ListCardsQueryServiceImpl();
    ref.onDispose(queryService.dispose);
    return queryService;
  }),
  positionCardsQueryServiceProvider.overrideWith((ref) {
    final queryService = PositionCardsQueryServiceImpl();
    ref.onDispose(queryService.dispose);
    return queryService;
  }),
  searchConditionQueryServiceProvider.overrideWith((ref) {
    final queryService = SearchConditionQueryServiceImpl(
      ref.watch(sharedPreferencesProvider),
    );
    ref.onDispose(queryService.dispose);
    return queryService;
  }),
];
