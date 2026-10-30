#!/bin/bash
# ワークツリーで動作確認（ビルド・実機デプロイ）をするための初期セットアップ。
# git 管理外のファイルはワークツリーに引き継がれないため、それを補う。
# 冪等。何度実行しても安全。
set -euo pipefail

ROOT="$(git rev-parse --show-toplevel)"
# --git-common-dir は、どのワークツリーからでも本体の .git を指す。
# 本体のチェックアウトで実行すると相対パス（.git）が返り ROOT との比較が成立しないため、
# --path-format=absolute（git 2.31+）で絶対パスに揃える。
MAIN="$(dirname "$(git rev-parse --path-format=absolute --git-common-dir)")"
cd "$ROOT"

echo "==> 対象: $ROOT"

# 1. gitignore されている設定ファイル・署名ファイルを本体から symlink する。
#    コピーではなく symlink にしているのは、本体側で更新されたときに
#    ワークツリー側が古いまま気づけない事故を防ぐため。
#
#    ビルド時にコピー先として「書き込まれる」ファイルは symlink してはいけない。
#    symlink を辿って本体側のファイルを上書きしてしまうため。該当するのは次の 3 つで、
#    いずれもビルドのたびに下のリストのファイルから生成されるので張る必要もない。
#      - android/app/google-services.json     （Gradle の selectGoogleServicesJson がコピー）
#      - ios/Runner/GoogleService-Info.plist  （Xcode のビルドフェーズが cp -f でコピー）
#      - ios/Flutter/Dart-Defines.xcconfig    （スキームの Pre-action が書き出す）
LINKS=(
  # development / production 構成が --dart-define-from-file で渡す
  dart_defines/development.env
  dart_defines/production.env
  # iOS の flutterfire upload-crashlytics-symbols ビルドフェーズが参照する。ないと iOS ビルドが落ちる
  firebase.json
  # release 署名。storeFile は android/app からの相対パス（signingConfigs/*.jks）で解決される
  android/key.properties
  # ディレクトリごと張る。.gitignore の該当行は末尾スラッシュなし（**/android/app/signingConfigs）なので、
  # git がファイル扱いするディレクトリの symlink も無視される
  android/app/signingConfigs
  # Gradle の selectGoogleServicesJson が flavor に応じて android/app/ へコピーする元
  android/app/src/development/google-services.json
  android/app/src/production/google-services.json
  # Xcode のビルドフェーズが flavor に応じて ios/Runner/ へコピーする元。
  # ディレクトリごと張ると .gitignore（ファイル名まで指定）に一致せず untracked に見えるため、ファイル単位で張る
  ios/development/GoogleService-Info.plist
  ios/production/GoogleService-Info.plist
)

if [ "$ROOT" = "$MAIN" ]; then
  echo "--> 本体のチェックアウトなので symlink はスキップ"
else
  missing=()
  for path in "${LINKS[@]}"; do
    if [ -e "$path" ]; then
      echo "--> $path は既に存在"
    elif [ -e "$MAIN/$path" ]; then
      # 上の -e は壊れた symlink（本体を移動した後など）で false になるためここに来る。-f で張り直す。
      # -n は、既存のディレクトリ symlink を辿ってその中に作ってしまうのを防ぐ。
      mkdir -p "$(dirname "$path")"
      ln -sfn "$MAIN/$path" "$path"
      echo "--> $path を本体から symlink した"
    else
      missing+=("$path")
    fi
  done
  if [ ${#missing[@]} -gt 0 ]; then
    echo "!!! 本体のチェックアウト（$MAIN）に以下が見つかりません。本体側に配置してから再実行してください。" >&2
    printf '!!!   %s\n' "${missing[@]}" >&2
    exit 1
  fi
fi

# 2. Flutter SDK を .fvmrc のバージョンに固定する。
#    fvm install は引数なしで .fvmrc のバージョンを読み、.fvm/flutter_sdk を張る。
#    --skip-pub-get は次の手順で明示的に行うため。
echo "==> Flutter SDK（.fvmrc のバージョン）"
fvm install --skip-pub-get

# 3. 依存関係
echo "==> pub get"
fvm flutter pub get

# 4. コード生成。.freezed.dart / .g.dart は gitignore されているため必ず必要。
#    コード生成はパッケージ単位で走るため、packages/ 配下の各パッケージで実行する。
#    app は domain の型を解析するので、依存される側（domain → data → app）から順に生成する。
for package in packages/domain packages/data packages/app; do
  echo "==> $package: pub get / build_runner"
  (cd "$package" && fvm flutter pub get && fvm dart run build_runner build --delete-conflicting-outputs)
done

# 5. iOS。ios/Pods/ は gitignore されているため pod install が必要。
#    --config-only は Xcode 用のビルド設定（Generated.xcconfig）の生成と pod install だけを行い、ビルドはしない。
#    Xcode から直接ビルドすると Generated.xcconfig の DART_DEFINES がスキームの Pre-action で
#    Dart-Defines.xcconfig に書き出され、flavor が決まる。ここでは development を入れておく。
#    Android Studio から実行した場合は、そのたびに実行構成の env で上書きされる。
if [ "$(uname)" = "Darwin" ]; then
  echo "==> iOS（pod install と Xcode 用のビルド設定）"
  # CocoaPods は端末が UTF-8 でないと警告を出し、環境によっては失敗する
  export LANG=en_US.UTF-8
  fvm flutter build ios --config-only --debug --no-codesign --dart-define-from-file=dart_defines/development.env

  # Pod の構成を変えていなければ Podfile.lock は変わらないはず。
  if ! git diff --quiet -- ios/Podfile.lock; then
    echo "!!! ios/Podfile.lock に差分が出ました。Pod を変更していないなら想定外なので git diff で確認してください。" >&2
  fi
else
  echo "--> macOS ではないので iOS はスキップ"
fi

echo ""
echo "==> 完了。Android Studio で以下を開けます:"
echo "    $ROOT"
echo "    Xcode で開く場合: $ROOT/ios/Runner.xcworkspace"
