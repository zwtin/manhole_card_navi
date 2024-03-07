import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

abstract class PvSendable {
  Future<void> sendPV(Ref ref);
}

class CustomNavigatorObserver extends NavigatorObserver {
  CustomNavigatorObserver(
    this._key,
    this._ref,
  );

  final Key? _key;
  final Ref _ref;
  PvSendable? _sended;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final result = route.currentResult;
    if (result == null) {
      return;
    }
    if (result is! PvSendable) {
      return;
    }
    if (_sended == result) {
      return;
    }
    _sended = result;
    sendPV();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final result = previousRoute?.currentResult;
    if (result == null) {
      return;
    }
    if (result is! PvSendable) {
      return;
    }
    if (_sended == result) {
      return;
    }
    _sended = result;
    sendPV();
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    final result = newRoute?.currentResult;
    if (result == null) {
      return;
    }
    if (result is! PvSendable) {
      return;
    }
    if (_sended == result) {
      return;
    }
    _sended = result;
    sendPV();
  }

  void sendPV() {
    _sended?.sendPV(_ref);
  }
}
