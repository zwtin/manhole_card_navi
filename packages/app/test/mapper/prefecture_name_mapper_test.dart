import 'package:app/src/mapper/prefecture_name_mapper.dart';
import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('全国のカードは「全国」、それ以外は都道府県名を表示する', () {
    expect(
      PrefectureNameMapper.nameOf(
        const ManholeCardPrefecture(id: '000', name: ''),
      ),
      '全国',
    );
    expect(
      PrefectureNameMapper.nameOf(
        const ManholeCardPrefecture(id: '027', name: '大阪府'),
      ),
      '大阪府',
    );
  });
}
