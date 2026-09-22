import 'package:test/test.dart';

import 'package:domain/domain.dart';

void main() {
  test('都道府県コード 000 を全国として扱う', () {
    expect(const Prefecture(id: '000', name: '').isNationwide, isTrue);
    expect(const Prefecture(id: '027', name: '大阪府').isNationwide, isFalse);
  });

  test('名前が空でも、コードが 000 でなければ全国ではない', () {
    expect(const Prefecture(id: '099', name: '').isNationwide, isFalse);
  });
}
