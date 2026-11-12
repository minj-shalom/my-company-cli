# IPC / Electron 보안 규칙

main, preload, renderer 코드를 건드리는 모든 작업에 적용한다. reviewer-qa는 이 문서로 검수한다.

## 필수 설정
- `nodeIntegration: false` (켜는 것 금지).
- `contextIsolation: true` (필수).
- 가능하면 `sandbox: true`, `webSecurity` 비활성화 금지.
- `BrowserWindow`의 `webPreferences`는 한 곳에서 생성하고 리뷰 대상으로 삼는다.
- 외부 URL 로드, `window.open`, 네비게이션은 허용 목록으로 제한한다. 원격 코드를 로드하지 않는다.

## preload
- `contextBridge.exposeInMainWorld`로 **필요한 최소한의 API만** 노출한다.
- `ipcRenderer` 객체나 범용 `invoke(channel, ...)`를 그대로 노출하지 않는다. 채널별 함수로 감싼다.
- 노출 API의 타입은 `<project_dir>/src/shared/`의 `window.api` 인터페이스와 일치시킨다.

## renderer
- renderer에서 파일 시스템, 프로세스 실행, Node/Electron API 직접 접근 금지.
- 모든 부수 효과는 `window.api` → IPC → main을 거친다.
- 브라우저 개발 모드에서는 `window.api` mock을 주입한다. mock은 프로덕션 번들에 포함하지 않는다.
- HTML 직접 삽입(`dangerouslySetInnerHTML`) 금지. 마크다운은 sanitize 후 렌더링한다.

## main (IPC 핸들러)
- 모든 IPC 입력은 **신뢰하지 않고 검증**한다 (타입, 길이, 범위, 허용 값). 스키마 검증 사용을 권장한다.
- 파일 경로는 회사 폴더 기준으로 정규화하고 경로 탈출(`..`, 심볼릭 링크)을 차단한다.
- CLI 실행은 `spawn` + 인자 배열로 한다. 셸 문자열 조합, `shell: true` 금지.
- IPC 발신자(`event.senderFrame`)가 앱 자신의 페이지인지 확인한다.
- 에러 메시지에 내부 경로나 민감 정보를 그대로 노출하지 않는다.

## 인증/토큰
- 앱은 사용자의 토큰·로그인 정보를 읽거나 저장하거나 전달하지 않는다.
- `~/.claude/**` 등 CLI 인증 파일에 접근하는 코드를 작성하지 않는다. 인증은 CLI가 처리한다.
- 로그에 환경변수, 인증 헤더를 남기지 않는다.
