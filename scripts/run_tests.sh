#!/bin/bash
# 全パッケージのテスト。domain は Flutter に依存しないので dart で回す。
set -euo pipefail

cd "$(dirname "$0")/.." || exit 1

(cd packages/domain && env -u GIT_DIR fvm dart test)
(cd packages/data && env -u GIT_DIR fvm flutter test)
(cd packages/app && env -u GIT_DIR fvm flutter test)
env -u GIT_DIR fvm flutter test
