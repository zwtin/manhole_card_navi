import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '/app/widget/custom_navigator_observer.dart';

final customNavigatorObserverProvider =
    Provider.family.autoDispose<CustomNavigatorObserver, Key?>(
  (ref, key) {
    return CustomNavigatorObserver(key, ref);
  },
);
