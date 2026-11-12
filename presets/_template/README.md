# 프리셋: <이름>

<어떤 종류의 프로젝트를 위한 프리셋인지 한 줄>

## 포함
- `agents/`: 전문 직원 (frontmatter: name, description, tools, model)
- `rules/`: 스택별 규칙 (예: 보안, 코드 스타일)
- `defaults`: `dev_command` 기본값

## 적용
```
scripts/init.sh --name "My App" --dir ../my-app --preset <이름>
```
