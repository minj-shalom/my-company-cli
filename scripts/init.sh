#!/usr/bin/env bash
# 프로젝트를 설정한다: company/project.md 채우기, 프리셋 적용, settings.json 경로 치환.
# 사용법:
#   scripts/init.sh --name "My App" --dir ../my-app [--preset web] [--preset electron] [--dev-command "npm run dev"]
# 권장: 템플릿을 클론한 뒤 `git switch -c develop` 한 다음 실행한다 (master는 깨끗하게 유지).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROJECT_MD="$ROOT/company/project.md"
SETTINGS="$ROOT/.claude/settings.json"

NAME="" DIR="" PRESETS="" DEV_CMD=""

usage() { sed -n '2,5p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'; exit 1; }

while [ $# -gt 0 ]; do
  case "$1" in
    --name) NAME="${2:-}"; shift 2 ;;
    --dir) DIR="${2:-}"; shift 2 ;;
    --preset) PRESETS="$PRESETS ${2:-}"; shift 2 ;;
    --dev-command) DEV_CMD="${2:-}"; shift 2 ;;
    -h|--help) usage ;;
    *) echo "알 수 없는 옵션: $1" >&2; usage ;;
  esac
done

[ -n "$NAME" ] && [ -n "$DIR" ] || { echo "--name 과 --dir 은 필수입니다." >&2; usage; }

# project.md 의 "- 키: 값" 줄을 교체한다.
set_field() {
  local key="$1" val="$2" tmp
  tmp="$(mktemp)"
  awk -v k="$key" -v v="$val" 'BEGIN{p="- " k ": "} index($0,p)==1{print p v; next} {print}' "$PROJECT_MD" > "$tmp"
  mv "$tmp" "$PROJECT_MD"
}

# settings.json 의 allow 목록에 권한 한 줄을 추가한다 (이미 있으면 건너뜀).
add_allow() {
  local entry="$1" tmp
  grep -qF "\"$entry\"" "$SETTINGS" && return 0
  tmp="$(mktemp)"
  awk -v e="$entry" '{print} index($0,"\"Bash(gh pr list*)\",")>0 {print "      \"" e "\","}' "$SETTINGS" > "$tmp"
  mv "$tmp" "$SETTINGS"
}

# 프리셋 적용 (여러 개 가능, 뒤에 적은 것이 같은 이름 파일을 덮어쓴다)
for PRESET in $PRESETS; do
  P="$ROOT/presets/$PRESET"
  [ -d "$P" ] || { echo "프리셋이 없습니다: $PRESET" >&2; exit 1; }
  [ -d "$P/agents" ] && cp "$P"/agents/*.md "$ROOT/.claude/agents/"
  [ -d "$P/rules" ] && cp "$P"/rules/*.md "$ROOT/.claude/rules/"
  if [ -f "$P/allow" ]; then
    while IFS= read -r line || [ -n "$line" ]; do
      case "$line" in ''|'#'*) continue ;; esac
      add_allow "$line"
    done < "$P/allow"
  fi
  if [ -z "$DEV_CMD" ] && [ -f "$P/defaults" ]; then
    DEV_CMD="$(sed -n 's/^dev_command: *//p' "$P/defaults" | head -1)"
  fi
  echo "프리셋 '$PRESET' 적용 완료 (agents, rules, allow)"
done

# project.md 채우기
set_field project_name "$NAME"
set_field project_dir "$DIR"
[ -n "$DEV_CMD" ] && set_field dev_command "$DEV_CMD"

# settings.json 경로 치환 (한 번만 가능)
if grep -q "__PROJECT_DIR__" "$SETTINGS"; then
  esc="$(printf '%s' "$DIR" | sed 's/[&|\\]/\\&/g')"
  sed -i.bak "s|__PROJECT_DIR__|$esc|g" "$SETTINGS" && rm -f "$SETTINGS.bak"
  echo "settings.json 에 프로젝트 경로를 반영했습니다."
else
  echo "settings.json 은 이미 초기화되어 있어 경로는 건드리지 않았습니다. 바꾸려면 직접 수정하세요."
fi

# 프로젝트 레포 준비 (없으면 생성, git 레포가 아니면 초기화. 커밋은 하지 않음)
case "$DIR" in /*) ABS="$DIR" ;; *) ABS="$ROOT/$DIR" ;; esac
mkdir -p "$ABS"
if [ ! -d "$ABS/.git" ]; then
  git -C "$ABS" init -b master >/dev/null
  echo "프로젝트 레포를 초기화했습니다: $ABS (커밋 없음)"
fi

cat <<EOF

완료. 다음 단계:
  1. company/mission.md, company/architecture.md 를 채운다.
  2. scripts/start.sh 로 Claude 를 실행한다.
EOF
