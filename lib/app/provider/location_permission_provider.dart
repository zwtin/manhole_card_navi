import 'package:hooks_riverpod/hooks_riverpod.dart';

final locationPermissionProvider =
    StateNotifierProvider.autoDispose<LocationPermissionNotifier, bool>(
  (ref) {
    return LocationPermissionNotifier();
  },
);

class LocationPermissionNotifier extends StateNotifier<bool> {
  LocationPermissionNotifier() : super(false);

  void requested() {
    state = true;
  }
}
