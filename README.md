# manhole_card_navi

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## 通信をプロキシで覗く

Charles / Proxyman / mitmproxy などのローカルプロキシにアプリの通信を流して、
中身を確認できるようにしてある。主な用途はカード画像の配信調査（Cloudflare R2 と
Firebase Hosting のどちらから取れているかの確認）。

### 1. 設定する

`dart_defines/development.env` に `proxy` の行を置いておく。このファイルは
`.gitignore` 済みなので commit されない。

```
# 普段はこれ。空なので無視され、従来どおり素通しになる
proxy=""

# 覗きたいときだけ待ち受け先を書く
proxy="192.168.1.10:8888"
```

**普段は `proxy=""` のまま置いておいてよい。** 行を消す必要はなく、覗きたいとき
だけ値を入れて起動し直す。

- **ポートは省略できない。** IP だけだと無効になり、起動ログに警告が出て素通しになる。
- IP は Mac の LAN アドレス（`ipconfig getifaddr en0`）。iOS シミュレータなら
  `127.0.0.1:8888`、Android エミュレータなら `10.0.2.2:8888`。
- `http://192.168.1.10:8888` のようにスキーマ付きで書いても解釈する。

### 2. debug ビルドで起動する

```bash
fvm flutter run --dart-define-from-file=dart_defines/development.env
```

**release ビルドでは指定しても無効になる**（証明書の検証を止めるため、
`kReleaseMode` で必ず落としている）。`fvm flutter build apk` は既定で release
なので、APK を作って調べたいときは `--debug` を付けること。

起動時のログに `[DebugProxy] Dart 側の HTTP 通信を ... 経由にしました` が出れば
有効になっている。

### 3. キャッシュを消す（配信調査では必須）

**一度取得したカード画像はディスクキャッシュに残り、2 回目以降はリクエストが
飛ばない。** プロキシに何も出てこない原因はたいていこれ。アプリ内にキャッシュを
消す口はないので、調査のたびに**アプリを削除して入れ直す**（Android なら
設定 > アプリ > ストレージ消去でもよい）。

一覧・詳細の画像（`CardImageCacheManager`、キー `libCachedImageData`）と
マーカー画像（`map_markers_view_data_mapper.dart` の独自ディスクキャッシュ）は
別々のキャッシュだが、どちらも入れ直せば消える。

### 覗ける通信の対応表

| 通信 | 経路 | 必要な設定 |
| --- | --- | --- |
| カード画像（一覧・詳細・マーカー） | Dart `HttpClient` | `proxy` の指定だけ |
| `package:http` を使う処理 | Dart `HttpClient` | `proxy` の指定だけ |
| Firebase Auth / Storage / Functions / Remote Config | ネイティブ | OS のプロキシ設定 + CA 証明書 |
| Google Maps のタイル | ネイティブ | OS のプロキシ設定 + CA 証明書 |
| Firestore | ネイティブ（gRPC） | HTTP プロキシでは覗きにくい |

カード画像は Dart 側で完結するので、**CA 証明書のインストールは不要**。
`lib/debug_proxy.dart` が証明書の検証を無視するため、プロキシを
立てて 1 行足すだけで HTTPS の中身まで見える。

主系（`image_url` / R2）の GET が失敗すると、続けて代替（`image_sub_url` /
Firebase Hosting）への GET が飛ぶので、フォールバックが働いた瞬間がそのまま
並んで見える。なお代替 URL の受け渡しに使っている `x-image-sub-url` ヘッダは
送信前に取り除かれるため、プロキシには現れない。

### ネイティブ側まで覗きたい場合

`proxy` が効くのは Dart 側の通信だけ。Firebase SDK と Google Maps はネイティブ
実装なので、OS のプロキシ設定と CA 証明書が別途要る。

**OS のプロキシ設定**

- **実機**: Wi-Fi 設定でプロキシを手動指定する。
- **iOS シミュレータ**: Mac のシステム設定のプロキシを見る。
- **Android エミュレータ**: `-http-proxy` か 設定 > プロキシ で指定する。

**CA 証明書**

- **iOS 実機**: 証明書をインストール →
  設定 > 一般 > 情報 > 証明書信頼設定 で「ルート証明書を全面的に信頼」を ON。
- **iOS シミュレータ**: Charles なら Help > SSL Proxying > Install Charles Root
  Certificate in iOS Simulators。
- **Android**: 証明書をインストールするとユーザー CA として入る。アプリ側は
  `android/app/src/debug/res/xml/network_security_config.xml` でユーザー CA を
  信頼するようにしてあるので、**debug ビルドならそのまま通る**。
  release / profile ビルドには入らないので通らない。

なお Firestore は gRPC（HTTP/2）で通信するため、HTTP プロキシでは素直に
覗けないことが多い。
