import 'package:domain/domain.dart';

/// 失敗の種類（[DomainException]）から、ダイアログの本文を決める。
///
/// タイトル（何に失敗したか）は画面が決め、本文（なぜか・どうすればよいか）は
/// ここで決める。
abstract final class ErrorMessageMapper {
  static const _unexpected = '予期しないエラーが発生しました。時間をおいてお試しください。';

  static String messageOf(Exception exception) {
    return switch (exception) {
      OfflineException() => '通信できませんでした。電波のよい場所で、もう一度お試しください。',
      TimedOutException() => '応答に時間がかかっています。しばらくしてから、もう一度お試しください。',
      CorruptedDataException() =>
        'データを正しく読み込めませんでした。時間をおいてお試しください。'
            '直らない場合は、設定の「改善要望・不具合報告」からお知らせください。',
      NotFoundException() => '表示するデータが見つかりませんでした。',
      PersistenceException() => '端末にデータを保存できませんでした。空き容量を確認してください。',
      UnknownException() => _unexpected,
      // DomainException へ移行していない失敗（CustomException など）。移行が
      // 終わって Result の失敗が DomainException だけになったら消し、種類の
      // 足し忘れをコンパイラに見つけてもらう。
      _ => _unexpected,
    };
  }
}
