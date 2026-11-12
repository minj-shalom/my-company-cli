#!/usr/bin/env bash
# company/project.md 의 설정으로 프로젝트 개발 서버를 tmux 세션에서 실행한다.
# 세션이 있으면 attach만 한다. 먼저 scripts/init.sh 를 실행해야 한다.
# Windows는 WSL에서 실행한다.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROJECT_MD="$ROOT/company/project.md"

get() { sed -n "s/^- $1: *//p" "$PROJECT_MD" | head -1; }

PROJECT_DIR="$(get project_dir)"
DEV_COMMAND="$(get dev_command)"
SESSION="$(get dev_session)"
SESSION="${SESSION:-dev}"

for v in "$PROJECT_DIR" "$DEV_COMMAND"; do
  if [ -z "$v" ] || [ "$v" = "(미설정)" ]; then
    echo "company/project.md 가 설정되지 않았습니다. 먼저 scripts/init.sh 를 실행하세요." >&2
    exit 1
  fi
done

case "$PROJECT_DIR" in /*) APP_DIR="$PROJECT_DIR" ;; *) APP_DIR="$ROOT/$PROJECT_DIR" ;; esac

if ! command -v tmux >/dev/null 2>&1; then
  echo "tmux가 설치되어 있지 않습니다. (macOS: brew install tmux / WSL: sudo apt install tmux)" >&2
  exit 1
fi

if ! tmux has-session -t "$SESSION" 2>/dev/null; then
  if [ ! -f "$APP_DIR/package.json" ]; then
    echo "$APP_DIR/package.json 이 없습니다. 프로젝트 초기화 티켓을 먼저 완료하세요." >&2
    exit 1
  fi
  tmux new-session -d -s "$SESSION" -c "$APP_DIR" "$DEV_COMMAND"
  echo "새 세션 '$SESSION'을 만들었습니다. 출력된 주소를 브라우저에서 여세요."
else
  echo "기존 세션 '$SESSION'에 attach 합니다."
fi

if [ -n "${TMUX:-}" ]; then
  tmux switch-client -t "$SESSION"
else
  tmux attach-session -t "$SESSION"
fi
