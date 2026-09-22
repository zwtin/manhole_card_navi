#!/bin/bash
# 画面が見た目を自分で決めていないかを見る。
#
# 文字は AppText、色は Theme か AppColors から引く決まりで、画面で Text・
# TextStyle・Color を直接作らない。動かせない事情があるところは、その行の
# 直前に `// ignore: <ルール名>` と理由を書く。
#
# 引数にファイルを渡せる（lefthook が変更されたものだけを渡す）。無ければ
# app のすべてを見る。
set -uo pipefail

cd "$(dirname "$0")/.." || exit 1

# 見た目そのものを定義しているファイルは対象外。
exclude='app_text\.dart|app_colors\.dart|app_theme\.dart'

if [ "$#" -gt 0 ]; then
  targets=$(printf '%s\n' "$@" | grep -E '^packages/app/lib/.*\.dart$')
else
  targets=$(find packages/app/lib -name '*.dart')
fi
targets=$(printf '%s\n' "$targets" | grep -Ev "$exclude" | grep -v '\.g\.dart$' \
  | grep -v '\.freezed\.dart$' | grep -v '/gen/')

found=0

# check <ルール名> <探す正規表現> <出す文言> [見逃す正規表現]
check() {
  local rule=$1 pattern=$2 message=$3 allow=${4:-} file line text previous
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

check use_app_text '(^|[^A-Za-z0-9_.])Text\(' \
  'Text ではなく AppText を使う。見た目は AppText に並べたものから選ぶ。'
check use_text_theme '(^|[^A-Za-z0-9_.])TextStyle\(' \
  'TextStyle を直接作らない。テーマの型スケールから選ぶ。'
check use_color_token '(^|[^A-Za-z0-9_.])Color\(' \
  '色を直接作らない。colors.xml に名前を付けて、Theme か AppColors から引く。'
# Colors.transparent は色ではなく「塗らない」なので許す。
# Colors.transparent は色ではなく「塗らない」なので見逃す。
check use_color_token '(^|[^A-Za-z0-9_.])Colors\.[a-z]' \
  'Material のパレット（Colors.xxx）を使わない。Theme か AppColors から引く。' \
  'Colors\.transparent'

if [ "$found" -eq 1 ]; then
  echo ""
  echo "デザインシステムから外れています。CLAUDE.md の「見た目はデザインシステムから選ぶ」を参照。"
  exit 1
fi
echo "デザインシステム: 問題なし"
