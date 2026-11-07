import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:path_provider/path_provider.dart';

import 'package:data/src/model/local_master_data_model.dart';

/// 読み込んだマスターデータをメモリに持つので、アプリ全体で 1 つだけ作る。
class MasterDataLocalDataSource {
  MasterDataLocalDataSource({required Future<Directory> Function() directory})
    : _directory = directory;

  factory MasterDataLocalDataSource.inApplicationSupport() {
    return MasterDataLocalDataSource(directory: getApplicationSupportDirectory);
  }

  /// 以前マスターデータを入れていた Realm のファイルを消す。Realm は iOS では
  /// Documents、Android では files（Application Support と同じ場所）に置いていた。
  static Future<void> deleteRealmFiles() async {
    for (final getDirectory in [
      getApplicationDocumentsDirectory,
      getApplicationSupportDirectory,
    ]) {
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
    }
  }

  /// マスターデータが変わるたびに、このファイルを上書きする。
  static const _fileName = 'master_data.json';

  /// 消すもの。書きかけの一時ファイルと、1.5.0 までのアプリが使っていた
  /// `master_data_v1.json`（読まずに消すので、取り込んでいない扱いになって取り直す）。
  static final _leftoverFileName = RegExp(
    r'^master_data(_v\d+)?\.json(\.tmp)?$',
  );

  final Future<Directory> Function() _directory;

  Future<File>? _file;
  Future<LocalMasterDataModel?>? _reading;
  LocalMasterDataModel? _master;

  /// ファイルの読み書きを 1 つずつ順に行う。読んでいる間に書き込みが終わって
  /// 古い内容でキャッシュを戻したり、2 つの書き込みが同じ一時ファイルを使ったり
  /// しないようにするため。
  Future<void> _lastOperation = Future.value();

  /// まだ取り込んでいなければ null。壊れたファイルは消すので、次の起動時の確認で
  /// 取り込んでいない扱いになって取り直す。
  Future<LocalMasterDataModel?> read() async {
    final cached = _master;
    if (cached != null) {
      return cached;
    }
    // 読み込みと変換は重いので、同時に呼ばれても 1 回で済ませる。
    return _reading ??= _serialize(_read).whenComplete(() => _reading = null);
  }

  Future<LocalMasterDataModel?> _read() async {
    // 待っている間に書き込みが終わっていれば、それが最新。
    final cached = _master;
    if (cached != null) {
      return cached;
    }
    final file = await _resolveFile();
    if (!await file.exists()) {
      return null;
    }
    final source = await file.readAsString();
    try {
      // 1〜2 MB あるので、別の Isolate で変換する。
      return _master = _unmodifiable(await compute(_decode, source));
    } on FormatException {
      await file.delete();
      rethrow;
    } on CheckedFromJsonException {
      await file.delete();
      rethrow;
    }
  }

  /// 途中で失敗したら、前のファイルとキャッシュをそのまま残す。
  Future<void> write(LocalMasterDataModel master) {
    return _serialize(() => _write(master));
  }

  Future<void> _write(LocalMasterDataModel master) async {
    final file = await _resolveFile();
    final source = await compute(_encode, master);
    // 途中で失敗しても前のファイルが残るよう、別のファイルに書いてから置き換える。
    final temporary = File('${file.path}.tmp');
    await temporary.writeAsString(source, flush: true);
    await temporary.rename(file.path);
    _master = _unmodifiable(master);
  }

  Future<T> _serialize<T>(Future<T> Function() operation) {
    final result = _lastOperation.then((_) => operation());
    // 失敗は呼んだ側に返す。後に続く操作は、前の操作が失敗しても始める。
    _lastOperation = result.then<void>((_) {}, onError: (Object _) {});
    return result;
  }

  static LocalMasterDataModel _unmodifiable(LocalMasterDataModel master) {
    return LocalMasterDataModel(
      version: master.version,
      cards: List.unmodifiable(master.cards),
    );
  }

  static String _encode(LocalMasterDataModel master) {
    return jsonEncode(master.toJson());
  }

  static LocalMasterDataModel _decode(String source) {
    final json = jsonDecode(source);
    if (json is! Map<String, dynamic>) {
      throw const FormatException('端末のマスターデータがオブジェクトではありません');
    }
    return LocalMasterDataModel.fromJson(json);
  }

  Future<File> _resolveFile() => _file ??= _prepare();

  Future<File> _prepare() async {
    final directory = await _directory();
    await directory.create(recursive: true);
    await for (final entity in directory.list()) {
      final name = entity.uri.pathSegments.lastWhere((s) => s.isNotEmpty);
      if (name != _fileName && _leftoverFileName.hasMatch(name)) {
        await entity.delete();
      }
    }
    return File('${directory.path}/$_fileName');
  }
}
