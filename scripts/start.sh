#!/usr/bin/env bash
# tmux 세션에서 claude를 실행한다. 세션이 있으면 attach만 한다.
# 세션 이름은 SESSION 환경변수로 바꿀 수 있다 (기본: mycompany).
# Windows는 WSL에서 실행한다.
set -euo pipefail

SESSION="${SESSION:-mycompany}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! command -v tmux >/dev/null 2>&1; then
  echo "tmux가 설치되어 있지 않습니다. (macOS: brew install tmux / WSL: sudo apt install tmux)" >&2
  exit 1
fi

if tmux has-session -t "$SESSION" 2>/dev/null; then
  echo "기존 세션 '$SESSION'에 attach 합니다."
else
  if ! command -v claude >/dev/null 2>&1; then
    echo "claude CLI를 찾을 수 없습니다." >&2
    exit 1
  fi
  tmux new-session -d -s "$SESSION" -c "$ROOT" "claude"
  echo "새 세션 '$SESSION'을 만들었습니다."
fi

if [ -n "${TMUX:-}" ]; then
  tmux switch-client -t "$SESSION"
else
  tmux attach-session -t "$SESSION"
fi
