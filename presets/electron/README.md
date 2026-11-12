# 프리셋: Electron

Electron + React(Vite) + TypeScript 데스크톱 앱을 만드는 직원과 규칙 모음.

## 포함
- `agents/electron-main-dev.md`: main 프로세스, CLI 러너, 스케줄러, SQLite, IPC
- `agents/ui-dev.md`: React UI
- `agents/devops.md`: electron-builder 패키징, 네이티브 모듈 rebuild, macOS/Windows 서명
- `rules/ipc-security.md`: contextIsolation, preload 최소 노출, IPC 검증 (필수)
- `rules/electron-style.md`: TypeScript/React 스타일 (공통 code-style.md에 더해 적용)
- `defaults`: `dev_command` 기본값 (`npm run dev -- --host`)

## 적용
```
scripts/init.sh --name "My App" --dir ../my-app --preset electron
```
에이전트와 규칙이 `.claude/`로 복사된다. 문서의 `<project_dir>`는 `company/project.md`의 `project_dir`를 뜻한다.
