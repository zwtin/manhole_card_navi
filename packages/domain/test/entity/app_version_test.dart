import 'package:test/test.dart';

import 'package:domain/domain.dart';

void main() {
  AppVersion version(String value) => AppVersion.parse(value);

  group('比較', () {
    test('前の桁から順に、数として比べる', () {
      expect(version('1.5.0') > version('1.4.9'), isTrue);
      expect(version('1.10.0') > version('1.9.0'), isTrue);
      expect(version('2.0.0') > version('1.99.99'), isTrue);
    });

    test('前の桁で差がつけば、後ろの桁は見ない', () {
      expect(version('1.4.0') > version('1.3.5'), isTrue);
      expect(version('1.4.0') < version('1.3.5'), isFalse);
    });

    test('足りない桁は 0 とみなす', () {
      expect(version('1.5'), version('1.5.0'));
      expect(version('1.5').hashCode, version('1.5.0').hashCode);
      expect(version('1.5.1') > version('1.5'), isTrue);
      expect(version('1.5') < version('1.5.0.1'), isTrue);
    });

    test('同じバージョンは、以上・以下のどちらにも当てはまる', () {
      expect(version('1.5.0') >= version('1.5.0'), isTrue);
      expect(version('1.5.0') <= version('1.5.0'), isTrue);
      expect(version('1.5.0') < version('1.5.0'), isFalse);
    });
  });

  group('読み取り', () {
    test('元の文字列をそのまま持つ', () {
      expect(version('1.5').value, '1.5');
      expect(version('1.5').toString(), '1.5');
    });

    test('数字をドットで区切った形でなければ読めない', () {
      for (final value in [
        '',
        '1.',
        '.1',
        '1..0',
        'v1.5.0',
        '1.5.0-dev',
        '1.5.0+10',
        ' 1.5.0',
        '1.5.0 ',
        '99999999999999999999.0',
      ]) {
        expect(AppVersion.tryParse(value), isNull, reason: value);
        expect(() => AppVersion.parse(value), throwsFormatException);
      }
    });
  });
}
