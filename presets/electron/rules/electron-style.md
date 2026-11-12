# Electron 코드 스타일

> 공통 `code-style.md`에 더해 적용한다. 린터/포매터 도입(T-001 이후) 시 실제 설정 파일 기준으로 갱신한다.

## TypeScript
- `strict: true`. `any` 금지 (불가피하면 `unknown` + 좁히기, 이유를 주석으로).
- 외부 입력(IPC, 파일, CLI 출력)은 타입 단언 대신 런타임 검증으로 좁힌다.
- 공유 타입은 `<project_dir>/src/shared/`에 둔다 (main/preload/renderer 공용).
- `async/await` 사용, 에러는 삼키지 말고 처리하거나 위로 전달한다.

## 이름과 구조
- 파일: `kebab-case.ts`, React 컴포넌트 파일: `PascalCase.tsx`.
- 변수/함수 `camelCase`, 타입/컴포넌트 `PascalCase`, 상수 `UPPER_SNAKE_CASE`.
- IPC 채널명: `도메인:동작` (예: `ticket:list`, `run:start`).
- 한 파일은 한 가지 책임. 길어지면 분리한다.

## React
- 함수형 컴포넌트와 hooks만 사용한다.
- renderer는 `window.api`로만 main과 통신한다.
- 상태는 가능한 한 가까운 곳에 둔다. 전역 상태는 필요할 때만.

## 기타
- 주석은 "왜"를 설명한다. 자명한 "무엇"은 쓰지 않는다.
- 사용하지 않는 코드, 디버그용 `console.log`는 남기지 않는다.
- 사용자에게 보이는 문구는 한국어, 코드 식별자와 커밋 접두어는 영문.
