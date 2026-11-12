# Git 워크플로

## 레포와 브랜치
- 독립 레포 두 개를 다룬다. 상위 폴더는 추적하지 않으며 `git init`도 하지 않는다.
  - `my-company-cli` (이 레포): AI 회사 설정, 티켓, 보고서
  - `project_dir` (`company/project.md`): 이 회사가 만드는 프로젝트 소스. 명령은 `git -C <project_dir> ...`로 실행한다.
- **`master`**: 배포용. 이 레포에서는 다른 사용자가 클론해 쓸 수 있는 깨끗한 템플릿이다. 프로젝트 내용(미션, 티켓, 프로젝트용 에이전트)을 넣지 않는다.
- **`develop`**: 사용자의 작업 브랜치. 프로젝트 설정과 티켓, 보고서는 여기에 모인다.
- **`feature/*`**: 모든 변경 단위. `develop`에서 분기하고 PR로 `develop`에 머지한다.
  - 티켓 작업: `feature/T-번호`
  - 티켓 이동, 보고서, 규칙 수정 등 운영 변경: `feature/ops-요약` (예: `feature/ops-report-t-001`)
- 프로젝트 레포도 같은 전략을 쓴다 (`feature/T-번호` → PR → `develop`, `master`는 릴리스용으로 사람이 머지).
- 프로젝트 레포 커밋 메시지의 `T-번호`로 이 레포의 티켓과 연결한다.

## 커밋
- 작은 단위로 자주 커밋한다. 한 커밋은 하나의 논리적 변경.
- 메시지 형식: `T-번호: 요약` (명령형, 한 줄 72자 이내). 운영 변경은 `ops: 요약`.
- 시크릿, `.env*`, 빌드 산출물, `node_modules`는 커밋하지 않는다.

## 푸시, PR, 머지 (사람 컨펌 필수)
1. 작업이 끝나고 reviewer-qa를 통과하면, AI는 `feature/` 브랜치 푸시를 **사람에게 컨펌받은 뒤** 한다.
   - settings.json의 `ask` 권한이 푸시 직전에 승인 요청을 띄운다.
2. 푸시 후 AI가 `gh pr create --base develop`으로 PR을 올린다. 설명에 티켓 번호, 변경 요약, 검수 결과를 적는다.
3. 사람이 PR을 확인하고 컨펌하면, AI가 `gh pr merge`로 `develop`에 머지한다 (`ask` 권한으로 승인 요청).
4. 사람이 컨펌하지 않은 PR은 머지하지 않는다. 컨펌이 필요하면 결정 카드를 `decisions/pending/`에 남기고 다른 티켓으로 넘어간다.
5. `develop` → `master` 머지와 릴리스는 사람이 한다. AI는 하지 않는다.

## 금지
- `master`/`main`/`develop`으로 직접 커밋·푸시 (직접 푸시는 settings.json에서 deny).
- PR의 base를 `master`로 지정하는 것.
- 강제 푸시(`--force`, `-f`), 히스토리 재작성(`reset --hard`, 공유 브랜치 `rebase` 등).
- 사람 컨펌 없는 푸시와 머지.

## 에이전트 작업 순서
1. `develop`에서 `git switch -c feature/T-번호` (이미 있으면 `git switch`)
2. 구현 → 작은 단위로 `git add`, `git commit`
3. reviewer-qa 검수 통과 후 보고서에 브랜치명과 커밋 목록을 기록
4. 푸시 컨펌 → PR 생성 → 사람 컨펌 → 머지
