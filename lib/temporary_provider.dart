import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

final sharedPreferencesProvider =
    Provider<StreamingSharedPreferences>((_) => throw UnimplementedError());

final packageInfoProvider =
    Provider<PackageInfo>((_) => throw UnimplementedError());
