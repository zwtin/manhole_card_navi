import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'router_view_data.freezed.dart';

@freezed
abstract class RouterViewData with _$RouterViewData {
  const factory RouterViewData({
    required TransitionType type,
    Widget? nextWidget,
  }) = _RouterViewData;
  const RouterViewData._();
}

enum TransitionType {
  push,
  pushReplacement,
  present,
  image,
  pop,
  popToRoot,
}
