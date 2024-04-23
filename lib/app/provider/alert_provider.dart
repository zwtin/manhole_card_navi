import 'package:hooks_riverpod/hooks_riverpod.dart';

import '/app/view_data/alert_view_data.dart';

final alertProvider =
    StateNotifierProvider.autoDispose<AlertNotifier, AlertViewData?>(
  (ref) {
    return AlertNotifier();
  },
);

class AlertNotifier extends StateNotifier<AlertViewData?> {
  AlertNotifier() : super(null);

  void show({
    required String title,
    required String message,
    required String? okButtonTitle,
    required Future<void> Function()? okButtonAction,
    required String? cancelButtonTitle,
    required Future<void> Function()? cancelButtonAction,
  }) {
    final AlertOKButtonViewData? okButtonViewData;
    if (okButtonTitle != null && okButtonAction != null) {
      okButtonViewData = AlertOKButtonViewData(
        title: okButtonTitle,
        action: okButtonAction,
      );
    } else {
      okButtonViewData = null;
    }

    final AlertCancelButtonViewData? cancelButtonViewData;
    if (cancelButtonTitle != null && cancelButtonAction != null) {
      cancelButtonViewData = AlertCancelButtonViewData(
        title: cancelButtonTitle,
        action: cancelButtonAction,
      );
    } else {
      cancelButtonViewData = null;
    }

    state = AlertViewData(
      title: title,
      message: message,
      okButtonViewData: okButtonViewData,
      cancelButtonViewData: cancelButtonViewData,
    );
  }

  void dismiss() {
    state = null;
  }
}
