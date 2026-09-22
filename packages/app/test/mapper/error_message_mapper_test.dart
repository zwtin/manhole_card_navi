import 'package:app/src/mapper/error_message_mapper.dart';
import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('失敗の種類ごとに、利用者がとれる行動を本文にする', () {
    expect(
      ErrorMessageMapper.messageOf(const OfflineException()),
      contains('電波のよい場所'),
    );
    expect(
      ErrorMessageMapper.messageOf(const TimedOutException()),
      contains('しばらくしてから'),
    );
    expect(
      ErrorMessageMapper.messageOf(const CorruptedDataException()),
      contains('改善要望・不具合報告'),
    );
    expect(
      ErrorMessageMapper.messageOf(const PersistenceException()),
      contains('空き容量'),
    );
  });

  test('原因の分からない失敗は、予期しないエラーとして伝える', () {
    expect(
      ErrorMessageMapper.messageOf(const UnknownException()),
      startsWith('予期しないエラー'),
    );
  });
}
