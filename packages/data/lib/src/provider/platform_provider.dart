import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

/// 起動時に非同期で初期化してから main.dart の ProviderScope で差し込む。
final sharedPreferencesProvider = Provider<StreamingSharedPreferences>(
  (_) => throw UnimplementedError(),
);

/// 起動時に非同期で初期化してから main.dart の ProviderScope で差し込む。
final packageInfoProvider = Provider<PackageInfo>(
  (_) => throw UnimplementedError(),
);
