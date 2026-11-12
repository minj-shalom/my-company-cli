# 반복 실행 지침 (loop)

한 번의 반복(iteration)마다 아래 순서를 따른다.

1. **이어서 하기:** `company/tickets/in-progress/`에 티켓이 있으면 그것을 먼저 이어서 진행한다.
2. **새로 가져오기:** in-progress가 비어 있으면 `company/tickets/backlog/` 최상단(번호가 가장 작은) 티켓을 `in-progress/`로 옮기고 시작한다.
3. **위임:** 티켓의 담당 에이전트에게 구현을 맡기고, 끝나면 reviewer-qa에 검수를 맡긴다.
4. **마무리:** 통과하면 티켓을 `done/`으로 옮기고 `company/reports/`에 요약 보고서를 쓴다 (`templates/report.md`).
   변경은 `feature/` 브랜치에 커밋한다 (`.claude/rules/git-workflow.md`). 푸시와 PR 머지는 사람 컨펌 후에만 한다.
5. **결정이 필요하면:** `company/decisions/pending/`에 결정 카드를 남기고 이번 반복을 종료한다.
   카드가 남은 티켓은 막힌 점을 기록해 두며, 다음 반복에서 다른 티켓을 우선한다.
6. backlog와 in-progress가 모두 비었으면 "할 일 없음"을 보고서에 남기고 종료한다.

## 지킬 것
- 한 반복에서 티켓은 하나만 다룬다.
- 금지사항은 `CLAUDE.md`를 따른다. main 직접 푸시는 하지 않고, 푸시/머지는 사람 컨펌 후에만 한다.
- 불확실한 점은 추측해서 진행하지 말고 결정 카드로 남긴다.
