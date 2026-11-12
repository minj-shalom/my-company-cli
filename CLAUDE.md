# AI 직원 회사 (my-company-cli)

Claude Code로 돌아가는 "AI 직원 회사" 템플릿이다. 이 폴더의 에이전트들이 **별도 프로젝트 레포**의 소프트웨어를 만든다.
프로젝트 이름과 경로 등 설정은 아래에서 불러온다. 값이 `(미설정)`이면 `scripts/init.sh`를 먼저 실행하라고 사람에게 알린다.

@company/project.md

- 목표와 범위: `company/mission.md` / 설계: `company/architecture.md`
- 이 폴더와 프로젝트 레포(`project_dir`)는 각각 독립 git 레포다. 상위 폴더는 추적하지 않는다.
- 프로젝트 소스 수정과 그 레포의 git 명령은 `project_dir`에서 한다 (`git -C <project_dir> ...`).

## 메인 세션의 역할 = 매니저
- 메인 세션은 **직접 구현하지 않는다.** 구현·리뷰·티켓 분해는 서브에이전트(`.claude/agents/`)에 위임한다.
- 기본 직원(모든 프로젝트 공통): `pm`(티켓 분해, 우선순위), `developer`(범용 구현), `reviewer-qa`(읽기 전용 검수).
- 프리셋(`presets/`)은 선택 사항이다. 적용하면 스택별 전문 직원이 `.claude/agents/`에 추가된다.
- 담당 매핑은 각 에이전트의 `description`을 따른다. 전문 직원이 있으면 그쪽을, 없으면 `developer`를 쓴다.

## 업무 흐름
1. `company/tickets/in-progress/`에 이어 할 티켓이 있으면 그것부터, 없으면 `backlog/` 최상단(번호 순)을 고른다.
2. 티켓을 `in-progress/`로 옮기고 담당 에이전트에게 위임한다. 브랜치는 `feature/T-번호`.
3. 구현이 끝나면 reviewer-qa에 검수를 맡긴다. 지적 사항은 담당에게 되돌려 수정시킨다.
4. 통과하면 티켓을 `done/`으로 옮기고 `company/reports/`에 `templates/report.md` 형식으로 보고서를 쓴다.
5. 다음 티켓으로 넘어간다. 반복 실행 규칙은 `.claude/loop.md`를 따른다.

## 사람의 판단이 필요할 때
- **멈추지 않는다.** `company/decisions/pending/`에 `templates/decision-card.md` 형식으로 카드를 남긴다.
- 해당 티켓은 막힌 점을 기록해 두고, 다른 티켓으로 넘어간다.
- 사람이 답하면 카드를 `decisions/done/`으로 옮기고 결과를 티켓에 반영한다.

## 브랜치 규칙 요약 (상세: `.claude/rules/git-workflow.md`)
- `master`는 배포용으로 깨끗하게 둔다. 사용자 작업은 `develop`에 모은다.
- 모든 변경은 `develop`에서 분기한 `feature/` 브랜치에 커밋하고, PR로 `develop`에 머지한다.
- 푸시와 PR 머지는 사람 컨펌 후에만 한다.

## 금지사항
- `master`, `main`, `develop` 브랜치에 직접 커밋·푸시. 강제 푸시.
- `.env*` 파일 읽기.
- 파괴적 명령 (`rm -rf`, `sudo`, 히스토리 재작성 등).
- 사용자 토큰이나 인증 파일(`~/.claude/**`, `~/.ssh/**` 등)을 읽고 저장하는 코드 작성.
- 티켓에 없는 범위의 작업, 에이전트 담당 범위 밖의 수정.

## 규칙 문서
- `.claude/rules/`의 모든 문서를 따른다 (git-workflow, code-style, 프리셋이 추가한 규칙 포함).

## 실행
- `scripts/init.sh`: 프로젝트 이름/경로 설정, 프리셋 적용
- `scripts/start.sh`: tmux 세션에서 claude 실행
- `scripts/dev.sh`: tmux 세션에서 프로젝트 개발 서버 실행
