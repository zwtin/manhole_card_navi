import 'dart:convert';
import 'dart:io';

import 'package:domain/domain.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import '../mapper/local_card_mapper.dart';
import '../model/local_card_model.dart';

/// 端末に取り込んだマスターデータ（カード一式）を、1 つの JSON ファイルで持つ。
///
/// 読むときは全件をまとめて読み、メモリに持っておく（一覧・マップはどのみち全件を
/// 使う）。書くときは一時ファイルに書いてから名前を変えて置き換えるので、途中で
/// 失敗しても前のデータが残る。
///
/// ファイルの形を変えたら [_formatVersion] を上げる。ファイル名にバージョンが入るので、
/// 古い形のファイルは読まれず「まだ取り込んでいない」扱いになり、マスターデータを
/// 取り直す。古い形のファイルは消す。
///
/// 読み込んだカードをメモリに持つので、アプリ全体で 1 つだけ作る。
class MasterDataLocalDataSource {
  MasterDataLocalDataSource({
    required Future<Directory> Function() directory,
    Future<void> Function()? cleanUp,
  })  : _directory = directory,
        _cleanUp = cleanUp;

  /// Application Support にファイルを置く。最初に使うときに、以前マスターデータを
  /// 入れていた Realm のファイルを消す。
  factory MasterDataLocalDataSource.inApplicationSupport() {
    return MasterDataLocalDataSource(
      directory: getApplicationSupportDirectory,
      cleanUp: _deleteRealmFiles,
    );
  }

  static const _formatVersion = 1;
  static const _fileName = 'master_data_v$_formatVersion.json';
  static final _oldFileName = RegExp(r'^master_data_v\d+\.json(\.tmp)?$');

  final Future<Directory> Function() _directory;
  final Future<void> Function()? _cleanUp;

  Future<File>? _file;
  List<ManholeCard>? _cards;

  /// 取り込んだカード一式。まだ取り込んでいなければ null。
  ///
  /// ファイルが壊れていれば消して [CorruptedDataException] を投げる。消しておくと、
  /// 次の起動時の確認で「取り込んでいない」とわかり、取り直す。
  Future<List<ManholeCard>?> readAll() async {
    final cached = _cards;
    if (cached != null) {
      return cached;
    }
    final file = await _resolveFile();
    if (!await file.exists()) {
      return null;
    }
    final source = await file.readAsString();
    try {
      // 2MB ほどあるので、変換は別の Isolate で行う。
      final cards = await compute(_decode, source);
      return _cards = List.unmodifiable(cards);
    } on CorruptedDataException {
      await file.delete();
      rethrow;
    }
  }

  /// カード一式を [cards] で丸ごと入れ替える。
  Future<void> writeAll(List<ManholeCard> cards) async {
    final file = await _resolveFile();
    final source = await compute(_encode, cards);
    final temporary = File('${file.path}.tmp');
    await temporary.writeAsString(source, flush: true);
    await temporary.rename(file.path);
    _cards = List.unmodifiable(cards);
  }

  /// 端末にカード一式があるか。
  Future<bool> exists() async {
    if (_cards != null) {
      return true;
    }
    return (await _resolveFile()).exists();
  }

  static String _encode(List<ManholeCard> cards) {
    return jsonEncode([
      for (final card in cards) LocalCardMapper.toModel(card).toJson(),
    ]);
  }

  static List<ManholeCard> _decode(String source) {
    final Object? json;
    try {
      json = jsonDecode(source);
    } on FormatException catch (error, stackTrace) {
      throw CorruptedDataException(
        detail: '端末のマスターデータが JSON として読めません',
        cause: error,
        stackTrace: stackTrace,
      );
    }
    if (json is! List<dynamic>) {
      throw const CorruptedDataException(detail: '端末のマスターデータがカードの一覧ではありません');
    }
    return [
      for (final item in json)
        if (item is Map<String, dynamic>)
          LocalCardMapper.toCard(LocalCardModel.fromStoredJson(item))
        else
          throw const CorruptedDataException(
            detail: '端末のマスターデータにカードでない要素があります',
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

/// 以前マスターデータを入れていた Realm のファイルを消す。
///
/// realm は iOS では Documents、Android では files ディレクトリ（Application Support と
/// 同じ場所）に `default.realm` と付随するファイルを置いていた。消せなくても動作には
/// 関わらないので、失敗は無視する。
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
      // 残っても害はない。
    }
  }
}
