import 'package:freezed_annotation/freezed_annotation.dart';

import '/app/widget/common_widget.dart';

part 'router_view_data.freezed.dart';

@freezed
abstract class RouterViewData with _$RouterViewData {
  const factory RouterViewData({
    required TransitionType type,
    CommonWidget? nextWidget,
  }) = _RouterViewData;
  const RouterViewData._();
}

enum TransitionType {
  init,
  push,
  pushReplacement,
  present,
  modal,
  image,
  pop,
  popToRoot,
}
