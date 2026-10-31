import 'dart:convert';
import 'dart:io';

import 'package:json_annotation/json_annotation.dart';
import 'package:path_provider/path_provider.dart';

import 'package:data/src/model/local_card_model.dart';

/// 読み込んだ差分をメモリに持つので、アプリ全体で 1 つだけ作る。
class CardUpdatesLocalDataSource {
  CardUpdatesLocalDataSource({required Future<Directory> Function() directory})
    : _directory = directory;

  factory CardUpdatesLocalDataSource.inApplicationSupport() {
    return CardUpdatesLocalDataSource(
      directory: getApplicationSupportDirectory,
    );
  }

  static const _fileName = 'card_updates.json';

  final Future<Directory> Function() _directory;

  Future<Map<String, LocalCardUpdateModel>>? _reading;
  Map<String, LocalCardUpdateModel>? _updates;

  /// カードの ID ごとの差分。なければ空。壊れたファイルは消すので、次の起動で
  /// 取り直す。ファイルの形を変えたときも、読めずに消えて取り直す。
  Future<Map<String, LocalCardUpdateModel>> readAll() async {
    final cached = _updates;
    if (cached != null) {
      return cached;
    }
    return _reading ??= _read().whenComplete(() => _reading = null);
  }

  Future<Map<String, LocalCardUpdateModel>> _read() async {
    final file = await _resolveFile();
    if (!await file.exists()) {
      return _updates = const {};
    }
    final source = await file.readAsString();
    try {
      return _updates = _toMap(_decode(source));
    } on FormatException {
      await file.delete();
      rethrow;
    } on CheckedFromJsonException {
      await file.delete();
      rethrow;
    }
  }

  Future<void> writeAll(List<LocalCardUpdateModel> updates) async {
    final file = await _resolveFile();
    final source = jsonEncode([for (final update in updates) update.toJson()]);
    // 途中で失敗しても前のファイルが残るよう、別のファイルに書いてから置き換える。
    final temporary = File('${file.path}.tmp');
    await temporary.writeAsString(source, flush: true);
    await temporary.rename(file.path);
    _updates = _toMap(updates);
  }

  Future<void> delete() async {
    final file = await _resolveFile();
    if (await file.exists()) {
      await file.delete();
    }
    _updates = const {};
  }

  static Map<String, LocalCardUpdateModel> _toMap(
    List<LocalCardUpdateModel> updates,
  ) {
    return Map.unmodifiable({for (final update in updates) update.id: update});
  }

  static List<LocalCardUpdateModel> _decode(String source) {
    final json = jsonDecode(source);
    if (json is! List<dynamic>) {
      throw const FormatException('端末のカードの差分が一覧ではありません');
    }
    return [
      for (final item in json)
        if (item is Map<String, dynamic>)
          LocalCardUpdateModel.fromJson(item)
        else
          throw const FormatException('端末のカードの差分に差分でない要素があります'),
    ];
  }

  Future<File> _resolveFile() async {
    final directory = await _directory();
    await directory.create(recursive: true);
    return File('${directory.path}/$_fileName');
  }
}
