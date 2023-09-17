import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:manhole_card_navi/app/provider/router_provider.dart';
import 'package:manhole_card_navi/app/view/home_view.dart';

final homeViewModelProvider =
    ChangeNotifierProvider.family.autoDispose<HomeViewModel, Key?>(
  (ref, key) {
    return HomeViewModel(
      key,
      ref,
    );
  },
);

class HomeViewModel extends ChangeNotifier {
  HomeViewModel(
    this._key,
    this._ref,
  );

  final Key? _key;
  final Ref _ref;
  final _logger = Logger();

  late GoogleMapController mapController;

  Future<void> onLoad() async {
    _logger.d('HomeViewModel');
  }

  void setGoogleMapController(GoogleMapController controller) {
    mapController = controller;
  }

  void onTap() {
    _ref.read(routerProvider(_key).notifier).push(
          nextWidget: HomeView(
            key: UniqueKey(),
          ),
        );
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d('HomeViewModel dispose');
  }
}
