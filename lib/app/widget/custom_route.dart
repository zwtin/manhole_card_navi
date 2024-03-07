import 'package:flutter/material.dart';

class CustomMaterialPageRoute<T> extends MaterialPageRoute<T> {
  CustomMaterialPageRoute({
    required T result,
    required super.builder,
    super.fullscreenDialog,
  }) : _result = result;

  final T _result;

  @override
  T? get currentResult => _result;
}

class CustomPageRouteBuilder<T> extends PageRouteBuilder<T> {
  CustomPageRouteBuilder({
    required T result,
    required super.pageBuilder,
    super.transitionDuration,
    super.reverseTransitionDuration,
  }) : _result = result;

  final T _result;

  @override
  T? get currentResult => _result;
}
