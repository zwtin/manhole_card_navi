import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/domain/entity/result.dart';
import '/domain/repository/app_badge_repository.dart';

final appBadgeRepositoryProvider = Provider.autoDispose<AppBadgeRepository>(
  (ref) {
    final appBadgeRepository = AppBadgeRepositoryImpl();
    ref.onDispose(appBadgeRepository.dispose);
    return appBadgeRepository;
  },
);

class AppBadgeRepositoryImpl implements AppBadgeRepository {
  final _logger = Logger();

  @override
  Future<Result<void>> updateCount({
    required int count,
  }) async {
    FlutterAppBadger.updateBadgeCount(count);
    return const Result.success(null);
  }

  @override
  Future<Result<void>> remove() async {
    FlutterAppBadger.removeBadge();
    return const Result.success(null);
  }

  void dispose() {
    _logger.d('AppBadgeRepositoryImpl dispose');
  }
}
