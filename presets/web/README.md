# 프리셋: Web

웹 앱(프론트엔드 + 백엔드)을 만드는 직원과 규칙 모음. 특정 프레임워크에 묶이지 않는다.

## 포함
- `agents/web-frontend-dev.md`: UI, 상태 관리, API 연동, 접근성
- `agents/web-backend-dev.md`: API, DB, 인증/권한
- `rules/web-security.md`: 입력 검증, 인증/권한, 시크릿, CORS 등
- `rules/web-style.md`: 웹 코드 스타일 (공통 code-style.md에 더해 적용)
- `defaults`: `dev_command: npm run dev`
- `allow`: `npm run *`, `npm install*`, `npx *` 허용

## 적용
```
scripts/init.sh --name "My App" --dir ../my-app --preset web
```
Node 기반이 아니면 `--dev-command`로 개발 서버 명령을 지정하고, 필요한 빌드/테스트 명령은 `allow`에 추가한다.
