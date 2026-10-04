#!/bin/bash
# app が約束どおりに書かれているかを見る。flutter analyze では見つからないもの。
#
# - 見た目はデザインシステムから選ぶ。画面で Text・TextStyle・Color を直接作らない
# - View・ViewData・widget は domain を知らない。domain の値を表示の形にするのは mapper
# - ViewModel は他の ViewModel を読まない。画面をまたぐ状態は UseCase の watch で共有する
#
# 動かせない事情があるところは、その行の直前に `// ignore: <ルール名>` と理由を書く。
#
# 引数にファイルを渡せる（lefthook が変更されたものだけを渡す）。無ければ
# app のすべてを見る。
set -uo pipefail

cd "$(dirname "$0")/.." || exit 1

if [ "$#" -gt 0 ]; then
  all=$(printf '%s\n' "$@" | grep -E '^packages/app/lib/.*\.dart$')
else
  all=$(find packages/app/lib -name '*.dart')
fi
all=$(printf '%s\n' "$all" | grep -v '\.g\.dart$' | grep -v '\.freezed\.dart$' \
  | grep -v '/gen/')

# 見た目そのものを定義しているファイルは、デザインシステムの検査から外す。
design_targets=$(printf '%s\n' "$all" \
  | grep -Ev 'app_text\.dart|app_colors\.dart|app_theme\.dart')
# カード画像は Flutter の画像の仕組みで読むため、ここだけは UseCase を知っている。
view_targets=$(printf '%s\n' "$all" \
  | grep -E '/(view|view_data|widget)/' | grep -v 'card_image_provider\.dart')
view_model_targets=$(printf '%s\n' "$all" | grep -E '/view_model/')

found=0

# check <ルール名> <対象のファイル> <探す正規表現> <出す文言> [見逃す正規表現]
check() {
  local rule=$1 targets=$2 pattern=$3 message=$4 allow=${5:-}
  local file line text previous
  for file in $targets; do
    [ -f "$file" ] || continue
    while IFS=: read -r line text; do
      [ -n "$line" ] || continue
      # Dart の `// ignore:` は次の行に効く。
      previous=$(sed -n "$((line - 1))p" "$file")
      case "$previous" in
        *"ignore: $rule"*) continue ;;
      esac
      case "$text" in
        *"ignore: $rule"*) continue ;;
      esac
      if [ -n "$allow" ] && printf '%s' "$text" | grep -qE "$allow"; then
        continue
      fi
      echo "  $file:$line • $message • $rule"
      found=1
    done < <(grep -nE "$pattern" "$file")
  done
}

check use_app_text "$design_targets" '(^|[^A-Za-z0-9_.])Text\(' \
  'Text ではなく AppText を使う。見た目は AppText に並べたものから選ぶ。'
check use_text_theme "$design_targets" '(^|[^A-Za-z0-9_.])TextStyle\(' \
  'TextStyle を直接作らない。テーマの型スケールから選ぶ。'
check use_color_token "$design_targets" '(^|[^A-Za-z0-9_.])Color\(' \
  '色を直接作らない。colors.xml に名前を付けて、Theme か AppColors から引く。'
# Colors.transparent は色ではなく「塗らない」なので見逃す。
check use_color_token "$design_targets" '(^|[^A-Za-z0-9_.])Colors\.[a-z]' \
  'Material のパレット（Colors.xxx）を使わない。Theme か AppColors から引く。' \
  'Colors\.transparent'
check no_domain_in_view "$view_targets" "^import 'package:domain/" \
  'View・ViewData・widget は domain を知らない。表示の形にするのは mapper で、ViewModel が ViewData にして渡す。'
check independent_view_model "$view_model_targets" "^import '.*_view_model\.dart';" \
  'ViewModel は他の ViewModel を読まない。画面をまたぐ状態は UseCase の watch で共有する。'

if [ "$found" -eq 1 ]; then
  echo ""
  echo "app の約束から外れています。CLAUDE.md の app の節を参照。"
  exit 1
fi
echo "app の約束: 問題なし"
