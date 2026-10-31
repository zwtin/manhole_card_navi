#!/bin/sh
# 配布状態の定期更新を操作する。
#
#   tools/card_update.sh on      定期実行を始める
#   tools/card_update.sh off     定期実行を止める（処理中の更新も止まる）
#   tools/card_update.sh status  ON か OFF かと、最後に成功した日時を出す
set -eu

# 接続先。切り替えるときはここを変えて off と on を実行する。
PROJECT=dev

LABEL=com.manholecardnavi.card-update
TOOLS=$(cd "$(dirname "$0")" && pwd)
PLIST="$HOME/Library/LaunchAgents/$LABEL.plist"
SERVICE="gui/$(id -u)/$LABEL"

is_on() {
  launchctl print "$SERVICE" >/dev/null 2>&1
}

write_plist() {
  mkdir -p "$(dirname "$PLIST")"
  # zsh -l で動かすのは、launchd がシェルの環境（~/.zshenv の PATH と API キー）を
  # 引き継がないため。caffeinate は、処理の途中でアイドルスリープしないようにする。
  cat > "$PLIST" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>$LABEL</string>
  <key>ProgramArguments</key>
  <array>
    <string>/bin/zsh</string>
    <string>-lc</string>
    <string>exec caffeinate -i python3 '$TOOLS/card_update.py' run --project $PROJECT</string>
  </array>
  <key>StartCalendarInterval</key>
  <dict>
    <key>Hour</key>
    <integer>4</integer>
    <key>Minute</key>
    <integer>0</integer>
  </dict>
  <key>EnvironmentVariables</key>
  <dict>
    <key>PYTHONUNBUFFERED</key>
    <string>1</string>
  </dict>
  <key>StandardOutPath</key>
  <string>$TOOLS/data/card_update.log</string>
  <key>StandardErrorPath</key>
  <string>$TOOLS/data/card_update.log</string>
</dict>
</plist>
EOF
}

case "${1:-}" in
  on)
    if [ ! -f "$TOOLS/data/card_update_state.json" ]; then
      echo "基準がありません。先に python3 tools/card_update.py baseline を実行してください。" >&2
      echo "（$TOOLS から実行しています。tools/data のあるチェックアウトで実行してください）" >&2
      exit 1
    fi
    if is_on; then
      launchctl bootout "$SERVICE"
    fi
    write_plist
    launchctl enable "$SERVICE"
    launchctl bootstrap "gui/$(id -u)" "$PLIST"
    echo "定期実行を ON にしました（接続先: $PROJECT）"
    ;;
  off)
    if is_on; then
      launchctl bootout "$SERVICE"
    fi
    # 設定ファイルを残したまま、次のログインでも読み込まないようにする。
    launchctl disable "$SERVICE"
    echo "定期実行を OFF にしました"
    ;;
  status)
    if is_on; then
      project=$(sed -n 's/.*--project \([a-z]*\).*/\1/p' "$PLIST")
      echo "定期実行: ON（接続先: $project）"
      if launchctl print "$SERVICE" | grep -q "state = running"; then
        echo "処理中  : はい"
      else
        echo "処理中  : いいえ"
      fi
    else
      echo "定期実行: OFF"
    fi
    if [ -f "$TOOLS/data/card_update_last_success" ]; then
      echo "最後に成功: $(cat "$TOOLS/data/card_update_last_success")"
    else
      echo "最後に成功: まだありません"
    fi
    ;;
  *)
    echo "使い方: $0 on | off | status" >&2
    exit 2
    ;;
esac
