import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import 'package:data/src/model/local_card_model.dart';
import 'package:data/src/model/malformed_data_exception.dart';

/// 読み込んだカードをメモリに持つので、アプリ全体で 1 つだけ作る。
class MasterDataLocalDataSource {
  MasterDataLocalDataSource({
    required Future<Directory> Function() directory,
    Future<void> Function()? cleanUp,
  })  : _directory = directory,
        _cleanUp = cleanUp;

  factory MasterDataLocalDataSource.inApplicationSupport() {
    return MasterDataLocalDataSource(
      directory: getApplicationSupportDirectory,
      cleanUp: _deleteRealmFiles,
    );
  }

  /// ファイルの形を変えたら上げる。古い形のファイルは読まずに消すので、取り込んで
  /// いない扱いになって取り直す。
  static const _formatVersion = 1;
  static const _fileName = 'master_data_v$_formatVersion.json';
  static final _oldFileName = RegExp(r'^master_data_v\d+\.json(\.tmp)?$');

  final Future<Directory> Function() _directory;
  final Future<void> Function()? _cleanUp;

  Future<File>? _file;
  Future<List<LocalCardModel>?>? _reading;
  List<LocalCardModel>? _cards;

  /// まだ取り込んでいなければ null。壊れたファイルは消すので、次の起動時の確認で
  /// 取り込んでいない扱いになって取り直す。
  Future<List<LocalCardModel>?> readAll() async {
    final cached = _cards;
    if (cached != null) {
      return cached;
    }
    // 読み込みと変換は重いので、同時に呼ばれても 1 回で済ませる。
    return _reading ??= _read().whenComplete(() => _reading = null);
  }

  Future<List<LocalCardModel>?> _read() async {
    final file = await _resolveFile();
    if (!await file.exists()) {
      return null;
    }
    final source = await file.readAsString();
    try {
      // 1〜2 MB あるので、別の Isolate で変換する。
      final cards = await compute(_decode, source);
      return _cards = List.unmodifiable(cards);
    } on MalformedDataException {
      await file.delete();
      rethrow;
    }
  }

  Future<void> writeAll(List<LocalCardModel> cards) async {
    final file = await _resolveFile();
    final source = await compute(_encode, cards);
    // 途中で失敗しても前のファイルが残るよう、別のファイルに書いてから置き換える。
    final temporary = File('${file.path}.tmp');
    await temporary.writeAsString(source, flush: true);
    await temporary.rename(file.path);
    _cards = List.unmodifiable(cards);
  }

  Future<bool> exists() async {
    if (_cards != null) {
      return true;
    }
    return (await _resolveFile()).exists();
  }

  static String _encode(List<LocalCardModel> cards) {
    return jsonEncode([for (final card in cards) card.toJson()]);
  }

  static List<LocalCardModel> _decode(String source) {
    final Object? json;
    try {
      json = jsonDecode(source);
    } on FormatException catch (error, stackTrace) {
      throw MalformedDataException(
        '端末のマスターデータが JSON として読めません',
        cause: error,
        stackTrace: stackTrace,
      );
    }
    if (json is! List<dynamic>) {
      throw const MalformedDataException('端末のマスターデータがカードの一覧ではありません');
    }
    return [
      for (final item in json)
        if (item is Map<String, dynamic>)
          LocalCardModel.fromStoredJson(item)
        else
          throw const MalformedDataException(
            '端末のマスターデータにカードでない要素があります',
          ),
    ];
  }

  Future<File> _resolveFile() => _file ??= _prepare();

  Future<File> _prepare() async {
    await _cleanUp?.call();
    final directory = await _directory();
    await directory.create(recursive: true);
    await for (final entity in directory.list()) {
      final name = entity.uri.pathSegments.lastWhere((s) => s.isNotEmpty);
      if (name != _fileName && _oldFileName.hasMatch(name)) {
        await entity.delete();
      }
    }
    return File('${directory.path}/$_fileName');
  }
}

/// 以前マスターデータを入れていた Realm のファイルを消す。Realm は iOS では
/// Documents、Android では files（Application Support と同じ場所）に置いていた。
Future<void> _deleteRealmFiles() async {
  for (final getDirectory in [
    getApplicationDocumentsDirectory,
    getApplicationSupportDirectory,
  ]) {
    try {
      final directory = await getDirectory();
      if (!await directory.exists()) {
        continue;
      }
      await for (final entity in directory.list()) {
        final name = entity.uri.pathSegments.lastWhere((s) => s.isNotEmpty);
        if (name.startsWith('default.realm')) {
          await entity.delete(recursive: true);
        }
      }
    } on FileSystemException {
      // 残っても動作には関わらない。
    }
  }
}
