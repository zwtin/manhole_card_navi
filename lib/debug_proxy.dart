import 'dart:io';

import 'package:flutter/foundation.dart';

/// アプリの通信をローカルのプロキシ（Charles / Proxyman / mitmproxy など）へ
/// 流して中身を覗けるようにする。
///
/// dart-define の `proxy` にプロキシの待ち受け先を指定したときだけ有効になる。
/// 指定は `dart_defines/development.env` に書く（このファイルは .gitignore 済みで
/// commit されない）。
///
/// ```
/// proxy="192.168.1.10:8888"
/// ```
///
/// 使わないときは `proxy=""` のまま残しておけばよい（空なので無視される）。
/// ポートは省略できない。値が空か解釈できない場合は何もせず素通しになる。
///
/// **効く範囲**: Dart 側（`dart:io` の [HttpClient]）の通信すべて。カード画像の
/// 取得（card_image_cache_manager.dart / map_markers_view_data_mapper.dart）や
/// `package:http` はここを通るので覗ける。一方、Firebase SDK と Google Maps は
/// ネイティブ実装なのでここは通らず、端末（またはシミュレータを動かしている Mac）
/// の OS のプロキシ設定に従う。詳しくは README の「通信をプロキシで覗く」を参照。
///
/// **証明書について**: プロキシが HTTPS を復号するには中間者の証明書が要るが、
/// Dart の [HttpClient] は OS にインストールした CA を見ずに自前のルートストアを
/// 使うため、端末に CA を入れても検証は通らない。そのため
/// [HttpClient.badCertificateCallback] で検証結果を無視している。**リリース
/// ビルドでは [kReleaseMode] で必ず無効化する**こと。
class DebugProxy {
  DebugProxy._();

  static const String _proxy = String.fromEnvironment('proxy');

  /// プロキシ設定を差し込む。通信が始まる前（`main` の先頭）で呼ぶ。
  ///
  /// `proxy` が空（`proxy=""` や未指定）なら何もしない。普段は空のまま
  /// 置いておける。
  static void install() {
    // 空白だけの指定（`proxy=" "`）も「書いていない」とみなす。ここで弾かないと
    // 下の解釈エラーの警告が毎回出てしまう。
    final proxy = _proxy.trim();
    if (proxy.isEmpty) {
      return;
    }
    if (kReleaseMode) {
      // 証明書の検証を止めるため、リリースビルドでは絶対に有効にしない。
      debugPrint('[DebugProxy] release ビルドでは無効です（指定値: $proxy）');
      return;
    }

    final target = _normalize(proxy);
    if (target == null) {
      debugPrint(
        '[DebugProxy] proxy の指定を解釈できません: $proxy'
        '（ポートも要る。例: proxy="192.168.1.10:8888"）',
      );
      return;
    }

    HttpOverrides.global = _ProxyHttpOverrides(target);
    debugPrint('[DebugProxy] Dart 側の HTTP 通信を $target 経由にしました');
  }

  /// `192.168.1.10:8888` / `http://192.168.1.10:8888` のどちらでも受け付けて
  /// `ホスト:ポート` に正規化する。解釈できなければ null。
  static String? _normalize(String value) {
    var rest = value;
    final schemeEnd = rest.indexOf('://');
    if (schemeEnd >= 0) {
      rest = rest.substring(schemeEnd + 3);
    }
    rest = rest.split('/').first;

    final separator = rest.lastIndexOf(':');
    if (separator <= 0) {
      return null;
    }
    final host = rest.substring(0, separator);
    final port = int.tryParse(rest.substring(separator + 1));
    if (host.isEmpty || port == null || port <= 0 || port > 65535) {
      return null;
    }
    return '$host:$port';
  }
}

class _ProxyHttpOverrides extends HttpOverrides {
  _ProxyHttpOverrides(this._target);

  /// `ホスト:ポート` 形式のプロキシの宛先。
  final String _target;

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);
    client.findProxy = (_) => 'PROXY $_target';
    // プロキシが差し込む中間者証明書を通すため。install() がリリースビルドを
    // 弾いているので、ここに来るのは debug / profile のみ。
    client.badCertificateCallback = (_, __, ___) => true;
    return client;
  }
}
