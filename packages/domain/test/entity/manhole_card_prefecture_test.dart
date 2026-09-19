import 'package:domain/domain.dart';
import 'package:test/test.dart';

void main() {
  test('名前のない都道府県は、国の機関・全国組織のカードとして扱う', () {
    expect(
      const ManholeCardPrefecture(id: '000', name: '').isNationwide,
      isTrue,
    );
    expect(
      const ManholeCardPrefecture(id: '027', name: '大阪府').isNationwide,
      isFalse,
    );
  });
}
