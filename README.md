# my-company-cli

Claude Code로 돌아가는 **AI 직원 회사** 템플릿. 매니저 역할의 메인 세션이 서브에이전트(PM, 개발자, 리뷰어)에게
티켓을 위임하고, 사람의 판단이 필요하면 결정 카드를 남긴 채 다른 일로 넘어간다.
이 레포를 클론해 원하는 프로젝트(앱, 서비스 등)를 만드는 데 쓴다.

## 요구사항
- [Claude Code CLI](https://claude.com/claude-code) (로그인 완료)
- git, [GitHub CLI(`gh`)](https://cli.github.com/) (PR 생성/머지용)
- tmux (`scripts/start.sh`, `dev.sh`용. Windows는 WSL에서 실행)

## 시작하기
```bash
git clone <이 레포> my-company-cli && cd my-company-cli
git switch -c develop            # master는 깨끗한 템플릿으로 둔다. 작업은 develop에서
scripts/init.sh --name "My App" --dir ../my-app     # 어떤 스택이든 가능. 프리셋은 선택 (--preset <이름>)
scripts/start.sh                 # tmux 세션에서 claude 실행
```
프리셋 없이도 `pm`, `developer`, `reviewer-qa`로 시작할 수 있다. 스택별 전문 직원과 허용 명령이 필요하면 `presets/`를 참고한다 (현재: electron, web).
코어의 허용 명령은 git/gh 등 공통 명령뿐이다. 빌드·테스트 명령은 프리셋의 `allow`가 추가하거나 `.claude/settings.json`에 직접 넣는다.
1. `company/mission.md`, `company/architecture.md`를 채운다.
2. PM에게 티켓 분해를 시키거나 `company/tickets/backlog/`에 티켓을 직접 쓴다.
3. 반복 실행: `.claude/loop.md` 참고.

## 구조
```
CLAUDE.md          매니저 규칙 (메인 세션이 읽음)
.claude/           settings, loop, agents(pm, developer, reviewer-qa), rules
company/           project.md, mission, architecture, tickets, decisions, reports, templates
presets/           선택형 스택별 직원/규칙/허용 명령 (현재 electron, web. 새 프리셋 추가 가능)
scripts/           init.sh, start.sh, dev.sh
```

## 브랜치와 안전장치
- `master`: 배포용 템플릿. `develop`: 사용자 작업. 모든 변경은 `feature/*` → PR → `develop`.
- 푸시와 PR 머지는 사람 컨펌 후에만 한다 (`.claude/settings.json`의 `ask` 권한).
- `.env*`, `~/.ssh`, `~/.claude` 읽기와 `rm -rf`, `sudo`, 강제 푸시는 차단된다.
- 자세한 규칙: `.claude/rules/git-workflow.md`

## 프리셋 추가
`presets/<이름>/`에 `agents/`, `rules/`, `defaults`(`dev_command: ...`)를 두면 `init.sh --preset <이름>`으로 적용된다.

## 라이선스
MIT
