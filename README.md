# MyConfig

> **Version**: v1.4.0 · **Last updated**: 2026-08-21

macOS 개발 환경을 위한 Neovim + tmux + Ghostty + Claude Code 설정 파일 모음입니다.

## 특징

- **한글 친화 Markdown 워크플로우** — 인라인 렌더링, 브라우저 미리보기, `pandoc` + xelatex 기반 한글 PDF 변환을 Neovim 키맵 하나로 실행
- **Claude Code 통합** — LazyVim `claudecode` extra, Claude Code + Neovim을 한 번에 띄우는 tmuxp 세션 런처, Claude Code 권한 정책(`settings.json`) 버전 관리
- **iTerm2 → Ghostty 키바인딩 1:1 이식** — macOS 표준 키 조합(`Cmd+E`, `Cmd+/` 등)으로 LazyVim 기능 호출
- **일관된 터미널 경험** — Neovim·Ghostty Tokyo Night 테마 통일, tmux 동기화 출력(DEC 2026) 패스스루로 TUI 화면 찢김 방지

## 목차

- [빠른 시작](#빠른-시작)
- [구조](#구조)
- [Neovim](#neovim)
- [tmux](#tmux)
- [Ghostty](#ghostty)
- [Claude Code](#claude-code)
- [의존성](#의존성)
- [License](#license)

## 빠른 시작

```bash
git clone https://github.com/hoosiki/MyConfig.git
```

각 도구는 서로 독립적이므로 필요한 것만 골라 적용할 수 있습니다. 아래 각 섹션의 **설치** 항목을 따라 심볼릭 링크를 만드세요. 예시의 `/path/to/MyConfig`는 clone한 경로로 바꿔 읽습니다.

## 구조

```
MyConfig/
├── nvim/                  # Neovim (LazyVim 기반)
│   ├── init.lua
│   ├── lazy-lock.json
│   ├── lazyvim.json
│   ├── stylua.toml
│   ├── LICENSE            # Apache 2.0 (LazyVim starter template)
│   └── lua/
│       ├── config/        # 개인 설정 (options, keymaps, autocmds)
│       └── plugins/       # 플러그인 설정
│
├── tmux/                  # tmux 설정
│   ├── tmux.conf          # tmux 메인 설정 파일
│   ├── tmux_init_example.yaml  # tmuxp 세션 템플릿 (예시)
│   └── claude-research    # tmuxp 세션 런처 스크립트
│
├── ghostty/               # Ghostty 터미널 설정
│   └── config             # 키바인딩 (iTerm2 → Ghostty 마이그레이션)
│
└── claude/                # Claude Code 사용자 설정
    └── settings.json      # 권한 정책, hooks, 플러그인 (~/.claude/settings.json 의 실체)
```

## Neovim

[LazyVim](https://github.com/LazyVim/LazyVim) starter template 기반에 개인 커스터마이징을 추가한 구성입니다.

### 활성화된 LazyVim Extras

- **언어**: Python, TypeScript, JSON, YAML, TOML, Markdown, SQL, Tailwind, CMake, Docker, Git
- **에디터**: Neo-tree, FZF, Outline, Dial, Aerial
- **코딩**: Yanky
- **AI**: Claude Code (`claudecode`)

### 주요 커스텀 플러그인

| 파일 | 설명 |
|------|------|
| `plugins/lsp.lua` | LSP 설정 |
| `plugins/python.lua` | Python 개발 환경 |
| `plugins/telescope.lua` | Telescope 검색 설정 |
| `plugins/neo-tree.lua` | 파일 탐색기 설정 |
| `plugins/markdown.lua` | Markdown 렌더링/미리보기/PDF 변환 |
| `plugins/auto-session.lua` | 세션 자동 저장/복원 |
| `plugins/treesitter.lua` | Treesitter 구문 강조 |

### Markdown 워크플로우

`plugins/markdown.lua` 에 통합된 마크다운 도구 모음:

| 플러그인 | 용도 | 키맵 |
|----------|------|------|
| `render-markdown.nvim` | Obsidian 스타일 인라인 렌더링 | `<leader>um` (toggle) |
| `live-preview.nvim` | 순수 Lua 브라우저 미리보기 (최신 Mermaid 자동 갱신) | `<leader>cp` |
| `markdown-preview.nvim` | 레거시 브라우저 미리보기 | `<leader>cm` |
| `follow-md-links.nvim` | `[label](path)` / `[[wiki]]` 링크를 `<CR>` 로 따라가기 | `<CR>` |
| `pandoc` (외부) | Markdown → PDF (한글, xelatex) | `<leader>cP` |

`<leader>cP` 는 `pandoc -d pdf-korean` 정의 파일과 `~/SynologyDrive/PublicShare/pdfs/` 출력 디렉터리를 사용합니다 (`lua/config/keymaps.lua`).

### 주요 커스텀 옵션

- 맞춤법 검사 비활성화 (한국어 환경 대응)
- 시스템 클립보드 연동 (`unnamedplus`)
- SSH 원격 환경에서 OSC 52를 통한 클립보드 지원
- `<leader>fp`: 현재 파일 경로를 클립보드에 복사
- `<leader>cP`: 현재 Markdown 파일을 PDF로 변환 (pandoc + xelatex, 한글 지원)
- `<leader>eW`: Neo-tree 너비 토글 (30 ↔ 160)

### 설치

```bash
# 기존 nvim 설정 백업
mv ~/.config/nvim ~/.config/nvim.bak

# 심볼릭 링크 생성
ln -s /path/to/MyConfig/nvim ~/.config/nvim

# Neovim 실행 시 플러그인 자동 설치
nvim
```

## tmux

tmux 3.4+ 대상, macOS / Ubuntu 공용 설정입니다. Solarized 256 테마를 기반으로 합니다.

### 주요 설정

| 항목 | 설정 |
|------|------|
| Prefix | `Ctrl-k` (기본 `Ctrl-b` 해제) |
| Pane 이동 | `h/j/k/l` (Vi-style) |
| Pane 크기 조절 | `H/J/K/L` (5칸 단위) |
| 윈도우 전환 | `Alt+1~9` (prefix 없이) |
| 화면 분할 | `\|` 또는 `\\` (수평), `-` (수직) |
| Copy mode | Vi-style (`v` 선택, `y` 복사) |
| 마지막 pane | `prefix+w` 또는 `Alt+W` |
| F12 | 중첩 tmux 세션용 prefix 토글 |

### TUI 렌더링

Claude Code 같은 풀스크린 TUI가 tmux 안에서 깨지지 않도록 한 설정입니다.

| 항목 | 설정 | 효과 |
|------|------|------|
| 동기화 출력 | `terminal-features ",*:sync"` | DEC 2026 패스스루 — TUI가 프레임을 원자적으로 그려 글리프 겹침·로그 번짐 방지 |
| ESC 대기 | `escape-time 10` | 키 시퀀스와 리드로우 지연 단축 (tmux-sensible이 0으로 덮지 않도록 TPM 이전에 선언) |
| 창 크기 | `aggressive-resize on` | 실제로 보고 있는 클라이언트 기준으로 리사이즈 — 작은 클라이언트 attach 시 프롬프트 밀림 방지 |
| 패스스루 | `allow-passthrough on` | OSC 52 클립보드, 이미지 프로토콜 |

### 비활성 Pane 구분

- 활성 pane: 밝은 파란색 테두리 (`colour39`), 기본 배경
- 비활성 pane: 어두운 테두리 (`colour238`), 어두운 배경
- 배경 dimming은 hook 없이 `window-style` / `window-active-style`로 tmux가 리드로우 시 네이티브 적용 (이전 `pane-focus-in/out` hook 방식은 `select-pane -P`가 pane을 선택해 버리는 부작용이 있어 제거)
- `focus-events on`으로 Neovim 포커스 감지 연동

### tmuxp 세션 런처

`claude-research` 스크립트로 Claude Code + Neovim 개발 환경을 한 번에 시작할 수 있습니다. 스크립트는 자기 위치(`tmux/`)의 `tmux_init.yaml`을 읽으며, 심볼릭 링크를 통해 실행해도 실제 경로를 따라갑니다(`readlink -f`). 세션 생성 후에는 각 윈도우의 첫 pane에 `/sc:load`를 자동 전송합니다.

```bash
# 1) 세션 템플릿을 복사해 자신의 프로젝트 경로에 맞게 수정 (tmux_init.yaml 은 gitignore 대상)
cp tmux/tmux_init_example.yaml tmux/tmux_init.yaml

# 2) 세션 생성 또는 기존 세션에 attach
./tmux/claude-research

# 백그라운드에서 세션 생성
./tmux/claude-research -d

# 기존 세션 종료 후 새로 생성
./tmux/claude-research -k
```

### 설치

```bash
# tmux.conf 심볼릭 링크
ln -s /path/to/MyConfig/tmux/tmux.conf ~/.tmux.conf

# (선택) 런처를 어디서든 실행할 수 있게 PATH 상의 디렉터리에 링크
ln -s /path/to/MyConfig/tmux/claude-research ~/.local/bin/claude-research
```

## Ghostty

[Ghostty](https://ghostty.org/) 터미널 설정 파일입니다. iTerm2 Default 프로파일의 키바인딩을 Ghostty 문법으로 1:1 이식하고, 폰트·테마·알림·macOS UI 설정을 통합한 구성입니다.

### 폰트

| 항목 | 값 |
|------|-----|
| Primary | JetBrainsMono Nerd Font (영문, ligature 풍부) |
| Fallback | Apple SD Gothic Neo (CJK, macOS 시스템 통합) |
| Size | 14 |
| Ligature | `+calt`, `+liga` 활성 (`=>`, `!=`, `>=`, `===`, `|>` 등) |
| Retina | `font-thicken = true`, `font-thicken-strength = 100` |

### 테마

- nvim의 tokyonight과 통일된 Tokyo Night 테마
- macOS Appearance에 따라 자동 전환: `light:TokyoNight Day,dark:TokyoNight`
- 가벼운 투명 + Blur: `background-opacity = 0.95`, `background-blur-radius = 20`
- 사용 가능한 variants: `TokyoNight`, `TokyoNight Day`, `TokyoNight Moon`, `TokyoNight Night`, `TokyoNight Storm`

### 알림 (Bell)

Ghostty 1.3+ `bell-features` 컴포넌트 기반 — 집 환경 무음 구성.

| 컴포넌트 | 활성 | 설명 |
|---------|------|------|
| `system` | O | macOS Notification Center 알림 |
| `attention` | O | Dock 아이콘 바운스 |
| `title` | O | 탭/창 제목에 시각 표시 |
| `border` | O | 창 테두리 깜빡임 (visual flash) |
| `audio` | X | 시스템 사운드 — 집 환경 무음 |

사운드를 켜려면 `bell-features`에 `audio`를 추가하고 `bell-audio-volume`/`bell-audio-path`를 설정합니다.

### macOS UI

| 항목 | 설정 |
|------|------|
| 타이틀바 | `macos-titlebar-style = native` |
| 앱 아이콘 | `macos-icon = glass` (Mitchell Hashimoto 디자인) |
| 윈도우 패딩 | 8px 균등 (`window-padding-balance = true`) |
| Option 키 | macOS 기본 동작 (특수문자 입력, `macos-option-as-alt = false`) |
| 윈도우 복원 | `window-save-state = always` (위치/크기/탭) |
| 풀스크린 | Native (별도 Space) |
| Shell integration | `shell-integration-features = no-cursor,sudo,title` — 프롬프트 커서 모양 유지, `sudo`에 Ghostty terminfo 전달, 탭 제목 자동 설정 (자동 보안 입력은 비활성) |

### LazyVim 연동 키바인딩

LazyVim leader 단축키를 터미널 키 입력으로 매핑하여 macOS 표준 키 조합으로 Neovim 기능을 호출할 수 있습니다.

| 키 조합 | 전송 시퀀스 | LazyVim 동작 |
|---------|-------------|--------------|
| `Cmd+Shift+O` | `<leader>fF` | 파일 검색 (현재 디렉터리) |
| `Cmd+E` | `<leader>fb` | 버퍼 검색 |
| `Cmd+Shift+A` | `ESC` + `:` | normal mode → command line |
| `Cmd+/` | `gc` | 주석 토글 (visual mode 포함) |
| `Ctrl+1` | `<leader>E` | 파일 탐색기 (Neo-tree) |
| `Ctrl+7` | `<leader>cs` | 심볼 패널 |
| `Ctrl+9` | `<leader>gG` | LazyGit |

설정 적용은 Ghostty 재시작 또는 `Cmd+Shift+,` (Reload Config)로 가능하며, `ghostty +list-keybinds`로 현재 바인딩을 점검할 수 있습니다.

### 설치

```bash
# 기존 ghostty 설정 백업 (있는 경우)
mv ~/.config/ghostty ~/.config/ghostty.bak

# 디렉터리 단위 심볼릭 링크 생성
ln -s /path/to/MyConfig/ghostty ~/.config/ghostty
```

## Claude Code

[Claude Code](https://claude.ai/claude-code)의 사용자 전역 설정(`~/.claude/settings.json`)을 저장소에서 관리합니다. 홈 디렉터리의 파일은 `claude/settings.json`을 가리키는 심볼릭 링크이므로, `/config`나 직접 편집으로 바뀐 설정이 곧바로 `git diff`에 나타납니다.

### 담고 있는 것

| 블록 | 내용 |
|------|------|
| `permissions.allow` | 읽기 전용·일상 명령 자동 허용 — `grep`/`ls`/`cat`/`find`, `git status/log/diff/add/commit/…`, `gh`, `pytest`/`ruff`, `docker compose`, `npm install`, document-skills 계열 스킬, `WebFetch(docs.anthropic.com, github.com)` |
| `permissions.deny` | 파괴적·민감 작업 차단 — `rm`, `sudo`, `git push/reset/rebase`, `.env*`·SSH 키·`*token*` 읽기, `secrets/` 편집 |
| `hooks` | 모든 라이프사이클 이벤트(SessionStart/End, UserPromptSubmit, Stop, PostToolUse, PermissionRequest 등)에서 [Superset](https://github.com/superset-sh/superset) 에이전트 상태 알림 스크립트 호출. `$SUPERSET_HOME_DIR`가 없으면 아무 일도 하지 않음(no-op) |
| `enabledPlugins` / `extraKnownMarketplaces` | document-skills, tavily, lazy2work(개인 마켓플레이스) 등 플러그인 소스 |
| 기타 | `model`, `effortLevel`, `editorMode = vim`, 비활성화한 내장 스킬(`skillOverrides`) |

> **주의 — 복사해 쓰기 전에 검토하세요.** 이 파일은 `"defaultMode": "auto"`와 `"skipDangerousModePermissionPrompt": true`로 권한 확인을 최소화한 **개인용 설정**입니다. 위 `deny` 목록이 안전망 역할을 하지만, 그대로 가져다 쓰면 같은 수준의 자동 실행 권한을 에이전트에 부여하게 됩니다. `permissions`를 본인 환경에 맞게 조정한 뒤 사용하세요.

### 저장소에 포함되지 않는 것

`settings.json` **한 파일만** 추적합니다. 아래는 비밀값·개인 이력이 들어 있으므로 커밋하지 않습니다.

- `~/.claude/.credentials.json` — OAuth 자격증명
- `~/.claude.json` — MCP 서버 설정(API 키 포함), 계정 정보
- `~/.claude/settings.local.json` — 머신별 로컬 오버라이드 (전역 gitignore 대상)
- `~/.claude/projects/`, `history.jsonl`, `shell-snapshots/` — 세션 전사본·프롬프트 이력·셸 환경 스냅샷

### 설치

```bash
# 기존 설정 백업 (있는 경우)
mv ~/.claude/settings.json ~/.claude/settings.json.bak

# 심볼릭 링크 생성
ln -s /path/to/MyConfig/claude/settings.json ~/.claude/settings.json
```

## 의존성

- [Neovim](https://neovim.io/) >= 0.10
- [tmux](https://github.com/tmux/tmux) >= 3.4
- [tmuxp](https://github.com/tmux-python/tmuxp) (세션 런처 사용 시)
- [Ghostty](https://ghostty.org/) >= 1.3 (선택; 키바인딩·`bell-features` 사용 시)
- [Claude Code](https://claude.ai/claude-code) (nvim `claudecode` extra, 세션 런처, `claude/` 설정)
- [Superset](https://github.com/superset-sh/superset) (선택; 없으면 Claude Code hooks는 no-op)
- [pandoc](https://pandoc.org/) + xelatex (선택; Markdown → PDF 변환 시)

## License

- `nvim/`: LazyVim starter template 유래 파일은 [Apache License 2.0](nvim/LICENSE) 적용. 개인 작성 코드(`lua/config/`, `lua/plugins/`)는 자유롭게 사용 가능.
- `tmux/`: 자유롭게 사용 가능.
- `ghostty/`: 자유롭게 사용 가능.
- `claude/`: 자유롭게 사용 가능.

자세한 라이선스 정보는 [nvim/AboutRepository.md](nvim/AboutRepository.md)를 참고하세요.
