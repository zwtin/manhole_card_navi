import 'package:flutter_test/flutter_test.dart';

import 'package:app/src/router/app_router.dart';

void main() {
  test('ピンの座標を載せたモーダルの URL から、同じ座標を読める', () {
    final location = AppRoutePath.cardModalWithPin(
      '27-226-B001',
      latitude: 34.56,
      longitude: 135.6,
    );

    expect(AppRoutePath.pinOf(Uri.parse(location)), (
      latitude: 34.56,
      longitude: 135.6,
    ));
    expect(Uri.parse(location).path, AppRoutePath.cardModal('27-226-B001'));
  });

  test('「マップで見る」から開いたモーダルには、ピンの座標がない', () {
    expect(
      AppRoutePath.pinOf(Uri.parse(AppRoutePath.cardModal('27-226-B001'))),
      isNull,
    );
  });
}
