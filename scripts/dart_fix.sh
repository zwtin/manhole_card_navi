#!/bin/bash
# dart fix をかける。dart fix は「1 つのファイルかディレクトリ」しか受け取れない
# ので、渡されたファイルからパッケージを拾って、パッケージごとに 1 回走らせる。
#
# パッケージ全体が対象になるので、コミットに含めていないファイルも直りうる。
# その場合は git status に出るので、中身を見てから改めてコミットする。
set -uo pipefail

cd "$(dirname "$0")/.." || exit 1

if [ "$#" -eq 0 ]; then
  exit 0
fi

packages=$(printf '%s\n' "$@" \
  | sed -n 's#^\(packages/[^/]*\)/.*#\1#p;s#^\(lib\|test\)/.*#.#p' \
  | sort -u)

status=0
for package in $packages; do
  env -u GIT_DIR fvm dart fix --apply "$package" || status=1
done
exit $status
