# CLAUDE.md

このファイルは、このリポジトリでコードを扱う際の Claude Code (claude.ai/code) へのガイダンスを提供します。

## 重要な指示
**このリポジトリで作業する際は、常に日本語で応答してください。**

## プロジェクト概要

マンホールカードナビ - 日本全国のマンホールカードを収集・ナビゲーションするためのFlutterモバイルアプリケーション。

## 開発コマンド

### Flutterコマンド
**重要:** すべてのFlutterコマンドで `flutter` の代わりに `fvm flutter` を使用してください。

```bash
# 依存関係の取得
fvm flutter pub get

# アプリの実行（開発環境）
fvm flutter run --dart-define-from-file=dart_defines/development.env

# アプリの実行（本番環境）
fvm flutter run --dart-define-from-file=dart_defines/production.env

# APKのビルド（本番環境）
fvm flutter build apk --dart-define-from-file=dart_defines/production.env

# iOSのビルド（本番環境）
fvm flutter build ios --dart-define-from-file=dart_defines/production.env

# コード解析
fvm flutter analyze

# テストの実行
fvm flutter test

# コード生成（Freezed、JsonSerializableなど）
fvm flutter pub run build_runner build --delete-conflicting-outputs

# アプリアイコンの生成
fvm flutter pub run flutter_launcher_icons -f flutter_launcher_icons-production.yaml

# ネイティブスプラッシュ画面の生成
fvm flutter pub run flutter_native_splash:create
```

## アーキテクチャ

### クリーンアーキテクチャレイヤー

1. **プレゼンテーション層** (`lib/app/`)
   - `view/` - UI画面とページ
   - `view_model/` - Riverpodによる状態管理
   - `view_data/` - UI専用のデータモデル
   - `widget/` - 再利用可能なUIコンポーネント
   - `mapper/` - ドメインとビューデータ間の変換
   - `provider/` - Riverpodプロバイダー

2. **ドメイン層** (`lib/domain/`)
   - `entity/` - ビジネスエンティティ
   - `repository/` - リポジトリインターフェース

3. **ユースケース層** (`lib/use_case/`)
   - `use_case/` - ビジネスロジックの実装
   - `dto/` - データ転送オブジェクト
   - `query_service/` - クエリサービスインターフェース

4. **インフラストラクチャ層** (`lib/infra/`)
   - `dao/` - データアクセスオブジェクト（Firestore、Realm）
   - `mapper/` - インフラストラクチャとドメイン間のデータマッピング

### 状態管理
- Riverpod + Flutter Hooksを使用した状態管理
- ViewModelがビジネスロジックと状態を処理
- プロバイダーは `lib/app/provider/` に集約

### データ層
- **リモート:** クラウドデータ用のFirebase Firestore
- **ローカル:** オフラインストレージ用のRealmデータベース
- **コード生成:** イミュータブルモデル用のFreezed、JSONパース用のJsonSerializable

### 主要な依存関係
- Firebaseスイート（Auth、Firestore、Storage、Analytics、Crashlyticsなど）
- Google Maps統合
- ローカルデータベース用のRealm
- 状態管理用のRiverpod + Flutter Hooks
- データモデル用のFreezed + JsonSerializable

## 環境設定

### ビルドフレーバー
- **開発環境:** `dart_defines/development.env`
- **本番環境:** `dart_defines/production.env`

各環境には個別のFirebaseプロジェクトと設定があります。

## Firebase統合
- Firebaseオプションは `lib/firebase_options.dart` で設定
- 開発環境と本番環境で個別のFirebaseプロジェクトを使用
- Firebase Auth、Firestore、Storage、Analytics、Crashlytics、Performance、Messaging、Remote Config、Cloud Functionsを使用

## コード生成
モデルはFreezedとJsonSerializableを使用。モデル変更後は以下を実行：
```bash
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

生成されるファイル：
- `*.freezed.dart` - Freezedイミュータブルクラス
- `*.g.dart` - JsonSerializable JSONパース
- `*.realm.dart` - Realmデータベースモデル