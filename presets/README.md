# 프리셋

프리셋은 **선택 사항**이다. 코어(`pm`, `developer`, `reviewer-qa`)만으로 어떤 프로젝트든 시작할 수 있고,
프리셋은 특정 스택에 맞는 전문 직원과 규칙을 추가한다.

```
scripts/init.sh --name "My App" --dir ../my-app                      # 프리셋 없이
scripts/init.sh --name "My App" --dir ../my-app --preset <이름>      # 프리셋 적용
```

## 제공 프리셋
- `electron`: Electron + React + TypeScript 데스크톱 앱
- `web`: 웹 앱 (프론트엔드 + 백엔드)

`--preset`은 여러 번 쓸 수 있다 (`--preset web --preset electron`). 같은 이름의 파일은 뒤에 적은 프리셋이 덮어쓴다.

## 새 프리셋 만들기
1. `presets/_template/`을 `presets/<이름>/`으로 복사한다.
2. `agents/`에 전문 직원(서브에이전트 `.md`), `rules/`에 스택별 규칙(보안, 스타일 등)을 둔다. 스타일 문서는 공통 `code-style.md`를 덮어쓰지 않도록 `<스택>-style.md`로 이름 짓는다.
3. `defaults`에 `dev_command: ...` 기본값을 적는다 (개발 서버가 없으면 비워 둔다).
   `allow`에는 이 스택에서 자율 실행 중 승인 없이 허용할 명령을 한 줄에 하나씩 적는다 (예: `Bash(pytest*)`, `Bash(go test *)`). `init.sh`가 `.claude/settings.json`의 allow 목록에 병합한다. 허용 명령은 최소한으로 한다.
4. 문서 안의 프로젝트 경로는 `<project_dir>`로 쓴다 (`company/project.md`의 값).

기여는 PR로 환영한다. 프리셋에는 프로젝트별 내용(미션, 티켓)을 넣지 않는다.
