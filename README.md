# MyConfig

> **Version**: v1.9.0 · **Last updated**: 2026-10-01

macOS 터미널에서 한글 문서 작업과 AI 페어 프로그래밍을 끊김 없이 하기 위한 개발 환경 설정 모음입니다. Neovim·tmux·Ghostty·Claude Code를 하나의 키맵·테마·세션 체계로 묶어, clone 후 심볼릭 링크를 걸고 Claude Code 설정만 한 번 생성하면 같은 환경이 그대로 재현됩니다.

## 왜 이 저장소인가

네 도구를 각각 설정하면 키맵이 서로 어긋나고, 한글 PDF 변환이나 TUI 렌더링처럼 조합에서만 드러나는 문제는 개별 문서 어디에도 없습니다. 이 저장소는 그 접점만 모아 둔 것입니다 — iTerm2 키바인딩의 Ghostty 이식, tmux 안에서 Claude Code가 깨지지 않게 하는 설정, 키맵 하나로 끝나는 한글 Markdown → PDF 경로.

## 특징

- **한글 친화 Markdown 워크플로우** — 인라인 렌더링, 브라우저 미리보기, `pandoc` + xelatex 기반 한글 PDF 변환을 Neovim 키맵 하나로 실행
- **Claude Code 통합** — LazyVim `claudecode` extra, Claude Code + Neovim을 한 번에 띄우는 tmuxp 세션 런처, Claude Code 권한 정책을 공통층 + OS별 층으로 나눠 버전 관리
- **iTerm2 → Ghostty 키바인딩 1:1 이식** — macOS 표준 키 조합(`Cmd+E`, `Cmd+/` 등)으로 LazyVim 기능 호출
- **일관된 터미널 경험** — Neovim·Ghostty Tokyo Night 테마 통일, tmux 동기화 출력(DEC 2026) 패스스루로 TUI 화면 찢김 방지

## 목차

- [빠른 시작](#빠른-시작)
- [설정 적용 방법](#설정-적용-방법)
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

각 도구는 서로 독립적이므로 필요한 것만 골라 적용할 수 있습니다. 설정 파일은 복사하지 않고, **기존 파일을 백업한 뒤 그 자리에 저장소 파일을 가리키는 심볼릭 링크를 거는** 방식으로 적용합니다 — 한 번에 적용하는 방법과 주의할 점은 [설정 적용 방법](#설정-적용-방법), 플러그인 설치 같은 도구별 후속 단계는 각 섹션의 **설치** 항목을 보세요. 예시의 `/path/to/MyConfig`는 clone한 경로로 바꿔 읽습니다.

## 설정 적용 방법

설정 파일을 홈 디렉터리로 **복사하지 않습니다.** 원래 자리에 있던 파일·디렉터리는 백업해 두고, 그 자리에 이 저장소의 파일을 가리키는 심볼릭 링크를 만듭니다.

- **어느 쪽을 고쳐도 같은 파일입니다** — `~/.config/nvim/...` 을 고치든 저장소 쪽을 고치든 바로 `git diff` 에 나타납니다. 복사본을 쓰면 두 쪽이 조용히 갈라집니다.
- **`git pull` 이 곧 적용입니다** — 다른 머신에서 바꾼 설정을 받아오면 링크를 다시 걸 필요가 없습니다.
- 대신 도구가 스스로 쓰는 파일도 저장소에 기록됩니다. `:Lazy update` 가 고치는 `nvim/lazy-lock.json` 이 `git status` 에 뜨는 것은 정상이며, 커밋하거나 `git checkout` 으로 되돌리면 됩니다.
- **Claude Code 설정만 예외로 링크하지 않습니다.** 두 머신의 플러그인 구성이 실제로 다르고, Claude Code 에는 사용자 전역 설정을 덮어쓸 오버라이드 레이어가 없기 때문입니다 — 저장소에 공통층과 OS별 층을 따로 두고 스크립트로 합성합니다. [Claude Code](#claude-code) 참고.

### 링크 대상

| 저장소 경로 | 링크를 만들 위치 | 단위 | 비고 |
|-------------|------------------|------|------|
| `nvim/` | `~/.config/nvim` | 디렉터리 | 플러그인·상태 데이터(`~/.local/share/nvim`, `~/.local/state/nvim`, `~/.cache/nvim`)도 백업하면 깨끗한 상태에서 플러그인이 새로 설치됩니다 (선택) |
| `tmux/tmux.conf` | `~/.tmux.conf` | 파일 | `~/.config/tmux/tmux.conf` 가 아니라 여기여야 합니다 — 설정 리로드(`prefix+r`)가 `~/.tmux.conf` 를 다시 읽습니다 |
| `ghostty/` | `~/.config/ghostty` | 디렉터리 | macOS 전용 경로의 설정이 이 파일을 덮어쓸 수 있습니다 (아래 주의할 점) |
| `tmux/claude-research` | `~/.local/bin/claude-research` | 파일 | 선택 — 런처를 PATH에서 실행하고 싶을 때만 |

`claude/` 는 링크 대상이 아닙니다. `~/.claude/settings.json` 은 `claude/build-settings.py` 로 **생성**합니다 — [Claude Code](#claude-code) 참고.

`tmux/tmux_init.yaml` 은 링크하지 않습니다. 저장소 안에서 예제를 복사해 만드는 개인 파일(gitignore 대상)입니다 — [tmuxp 세션 런처](#tmuxp-세션-런처) 참고.

### 한 번에 적용하기

아래를 셸에 그대로 붙여 넣으면 대상마다 **이미 이 저장소로 연결됨 → 건너뜀 · 다른 곳을 가리키는 링크 → 교체 · 실제 파일·디렉터리 → `<이름>.bak-<타임스탬프>` 로 백업** 한 뒤 링크를 만듭니다. 저장소에 없는 경로를 적으면 아무것도 건드리지 않고 `missing` 만 출력합니다. 여러 번 실행해도 안전하며(macOS bash 3.2·zsh에서 확인), 쓰지 않을 도구의 `link` 줄은 지우고 실행하세요. `REPO` 는 링크가 가리킬 절대 경로가 됩니다.

```bash
REPO="$(cd /path/to/MyConfig && pwd)"
TS=$(date +%Y%m%d-%H%M%S)

link() {
  local src="$REPO/$1" dst="$2"
  if [ ! -e "$src" ]; then
    echo "missing $src"; return 1
  fi
  if [ "$(readlink "$dst")" = "$src" ]; then
    echo "skip    $dst"; return 0
  fi
  mkdir -p "$(dirname "$dst")"
  if [ -L "$dst" ]; then
    echo "relink  $dst (was -> $(readlink "$dst"))"; rm "$dst"
  elif [ -e "$dst" ]; then
    echo "backup  $dst -> $dst.bak-$TS"; mv "$dst" "$dst.bak-$TS"
  fi
  ln -s "$src" "$dst" && echo "link    $dst -> $src"
}

link nvim                 ~/.config/nvim
link tmux/tmux.conf       ~/.tmux.conf
link ghostty              ~/.config/ghostty
link tmux/claude-research ~/.local/bin/claude-research

python3 "$REPO/claude/build-settings.py"
```

> 스니펫 안에 `#` 주석을 넣지 않은 것은 의도입니다. zsh 대화형 셸은 기본값(`interactivecomments` 꺼짐)에서 `#` 를 주석으로 보지 않아, 붙여 넣으면 오류가 납니다.

손으로 하나씩 하고 싶다면 각 섹션의 **설치** 항목에 같은 작업을 도구별로 나눈 명령이 있습니다.

적용 결과는 다음으로 확인합니다. 각 줄이 `-> /path/to/MyConfig/...` 로 끝나면 정상입니다.

```bash
ls -l ~/.config/nvim ~/.tmux.conf ~/.config/ghostty
```

Claude Code 설정은 링크가 아니라 생성된 파일이므로, 다시 실행해 `already up to date` 가 나오면 정상입니다.

```bash
python3 /path/to/MyConfig/claude/build-settings.py
```

### 되돌리기

링크를 지우고 백업을 제자리로 옮기면 됩니다. 링크를 지워도 저장소 파일은 그대로 남습니다.

```bash
rm ~/.config/nvim
mv ~/.config/nvim.bak-<타임스탬프> ~/.config/nvim
```

### 주의할 점

- **링크를 지울 때 경로 끝에 `/` 를 붙이지 마세요.** `rm -rf ~/.config/nvim/` 은 링크가 아니라 링크가 가리키는 **저장소의 `nvim/` 디렉터리를 지우고**, 링크는 그대로 남깁니다 (macOS에서 확인). 링크는 항상 `rm ~/.config/nvim` 처럼 `/` 없이 지웁니다.
- **기존 디렉터리를 치우지 않고 `ln -s` 하면 엉뚱한 곳에 링크가 생깁니다.** `~/.config/nvim` 이 이미 디렉터리면 `ln -s /path/to/MyConfig/nvim ~/.config/nvim` 은 오류 없이 `~/.config/nvim/nvim` 을 만들고 끝납니다. 이미 있는 링크를 `ln -sf` 로 바꾸려 해도 링크가 가리키는 **저장소 디렉터리 안에** 새 링크가 생기므로, 손으로 바꿀 때는 `ln -sfn` 을 쓰세요. 백업(이동)을 먼저 하는 이유가 이것입니다.
- **clone한 저장소를 옮기지 마세요.** 링크는 clone한 절대 경로를 가리키므로 저장소를 옮기거나 이름을 바꾸면 모든 링크가 끊깁니다. 옮겼다면 `REPO` 만 새 경로로 바꿔 위 스니펫을 다시 실행하면 기존 링크가 교체됩니다.
- **Ghostty는 macOS 전용 경로를 나중에 읽습니다.** `~/Library/Application Support/com.mitchellh.ghostty/` 의 `config.ghostty`(또는 `config`)에 내용이 있으면, 링크한 `~/.config/ghostty/config` 의 같은 항목을 덮어씁니다. 그 파일은 비워 두거나 백업한 뒤 지우세요.
- **Claude Code 설정 링크는 저절로 풀릴 수 있습니다** — [Claude Code](#claude-code) 섹션의 주의를 참고하세요.

## 구조

```
MyConfig/
├── nvim/                  # Neovim (LazyVim 기반)
│   ├── init.lua
│   ├── lazy-lock.json
│   ├── lazyvim.json
│   ├── stylua.toml
│   ├── LICENSE            # Apache 2.0 (LazyVim starter template)
│   ├── README.md          # 루트 README·라이선스 문서로 가는 포인터
│   ├── AboutRepository.md # Apache-2.0 / MIT 경계 설명
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
├── claude/                # Claude Code 사용자 설정 (링크 아님 — 합성해서 생성)
│   ├── settings.common.json   # 두 머신 공통 — 권한 정책, hooks, 모델, skillOverrides
│   ├── settings.linux.json    # Linux 전용 — 플러그인·마켓플레이스, tui, theme
│   ├── settings.macos.json    # macOS 전용 — 플러그인·마켓플레이스, tui
│   └── build-settings.py      # 공통 + OS별 → ~/.claude/settings.json
│
└── LICENSE                # MIT (저장소 전체 기본 라이선스)
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
| `plugins/lsp.lua` | marksman 진단 끄기 — Obsidian vault의 번호 파일·번호 디렉터리 공존을 "Ambiguous link"로 오탐하는 문제 회피 |
| `plugins/python.lua` | pyright `typeCheckingMode = "off"` |
| `plugins/telescope.lua` | dotfiles 포함 검색(`hidden`, `--hidden`), `.DS_Store`·`__pycache__`·`*.pyc` 제외 |
| `plugins/neo-tree.lua` | 너비 토글(`<leader>eW`), dotfiles 흐리게 표시·gitignored 숨김, `O` 로 Finder에서 위치 표시 |
| `plugins/markdown.lua` | Markdown 렌더링·미리보기·PDF 변환 도구 모음 (아래 표) |
| `plugins/auto-session.lua` | 세션 자동 저장/복원 (`~`, `~/Downloads`, `/` 는 제외) |
| `plugins/treesitter.lua` | 파서 자동 설치 + `cpp`·`cmake` 기본 포함 |

### Markdown 워크플로우

`plugins/markdown.lua` 에 통합된 마크다운 도구 모음:

| 플러그인 | 용도 | 키맵 |
|----------|------|------|
| `render-markdown.nvim` | Obsidian 스타일 인라인 렌더링 | `<leader>um` (toggle) |
| `live-preview.nvim` | 순수 Lua 브라우저 미리보기 (`localhost:5500`, 설치·업데이트마다 최신 Mermaid를 내려받아 교체) | `<leader>cp` |
| `markdown-preview.nvim` | 레거시 브라우저 미리보기 | `<leader>cm` |
| `follow-md-links.nvim` | `[label](path)` / `[[wiki]]` 링크를 `<CR>` 로 따라가기 | `<CR>` |
| `pandoc` (외부) | Markdown → PDF (한글, xelatex) | `<leader>cP` |
| `nvim-lint` / `conform.nvim` | Markdown에 한해 lint·저장 시 포맷 비활성 (prettier가 `_` 를 `*` 로 바꾸는 문제 회피) | — |

`<leader>cP` 는 pandoc 정의 파일 `pdf-korean` 을 쓰고 결과를 `~/SynologyDrive/PublicShare/pdfs/` 에 저장합니다 (`lua/config/keymaps.lua`). 정의 파일(`~/.local/share/pandoc/defaults/pdf-korean.yaml`)과 출력 디렉터리는 **이 저장소에 포함되어 있지 않으므로 직접 준비해야 하며**, 출력 경로는 파일 상단 `PDF_OUTPUT_DIR` 상수(`~/SynologyDrive/PublicShare/pdfs`)에 있으니 다른 디렉터리를 쓰려면 고쳐 쓰면 됩니다. pandoc은 필터가 실패해도 종료 코드 0으로 끝나기 때문에, 변환이 성공해도 경고가 있으면 건수와 함께 알림에 표시합니다 — mermaid 다이어그램이 코드블록으로 남는 경우를 놓치지 않기 위해서입니다.

### 주요 커스텀 옵션

- 맞춤법 검사 비활성화 (한국어 환경 대응)
- 시스템 클립보드 연동 (`unnamedplus`)
- SSH 원격 환경에서 OSC 52를 통한 클립보드 지원
- `<leader>fp`: 현재 파일 경로를 클립보드에 복사
- `<leader>eW`: Neo-tree 너비 토글 (30 ↔ 160)
- 플러그인 업데이트를 주기적으로 확인하되 알림은 띄우지 않음 (`lua/config/lazy.lua` 의 `checker`)

### 설치

```bash
# 기존 nvim 설정 백업
mv ~/.config/nvim ~/.config/nvim.bak

# (선택) 플러그인·상태 데이터도 백업해 깨끗한 상태에서 시작
mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.local/state/nvim ~/.local/state/nvim.bak
mv ~/.cache/nvim ~/.cache/nvim.bak

# 심볼릭 링크 생성
ln -s /path/to/MyConfig/nvim ~/.config/nvim

# Neovim 실행 시 플러그인 자동 설치
nvim
```

## tmux

tmux 3.4+ 대상, macOS / Ubuntu 공용 설정입니다. Solarized 256 테마를 기반으로 하며, 플러그인은 TPM으로 `tmux-sensible` · `tmux-yank` 둘만 씁니다.

### 주요 설정

| 항목 | 설정 |
|------|------|
| Prefix | `Ctrl-k` (기본 `Ctrl-b` 해제) |
| Pane 이동 | `h/j/k/l` (Vi-style) |
| Pane 크기 조절 | `H/J/K/L` (5칸 단위, 반복 가능) |
| 마지막 pane | `prefix+w` 또는 `Alt+W` |
| Pane 번호 표시 | `Alt+q` (prefix 없이) |
| 윈도우 전환 | `Alt+1~9` (prefix 없이) |
| 윈도우 순환 | `prefix+Ctrl-h` / `prefix+Ctrl-l` (반복 가능) |
| 윈도우를 1번으로 | `prefix+T` |
| 화면 분할 | `\|` 또는 `\\` (수평), `-` (수직) |
| Copy mode | Vi-style (`v` 선택, `y` 복사 → OSC 52로 시스템 클립보드 전달) |
| 설정 리로드 | `prefix+r` |
| F12 | 중첩 tmux 세션용 prefix 토글 |

이 밖에 마우스 지원, 스크롤백 50,000줄, 상태바 상단 가운데 정렬, 다른 윈도우 활동 감지(`monitor-activity`)가 켜져 있고, 기본 셸은 `$SHELL` 을 따라갑니다 (macOS는 zsh, Ubuntu는 bash).

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
- 테두리는 굵은 선(`pane-border-lines heavy`)에 방향 표시(`pane-border-indicators both`)
- `focus-events on`으로 Neovim 포커스 감지 연동

### tmuxp 세션 런처

`claude-research` 스크립트로 Claude Code + Neovim 개발 환경을 한 번에 시작할 수 있습니다. 스크립트는 자기 위치(`tmux/`)의 `tmux_init.yaml`을 읽으며, 심볼릭 링크를 통해 실행해도 실제 경로를 따라갑니다(`readlink -f`). 로드 전에 각 윈도우의 Claude Code pane 명령 끝에 `--rc '<window_name>'`을 덧붙인 임시 YAML을 만들어 사용하므로, Remote Control이 세션 시작과 함께 켜지고 claude.ai/code에 표시되는 세션 이름이 tmux 윈도우 이름과 같아집니다(`/rc` 슬래시 명령의 대화형 패널 없음). 세션 생성 후에는 각 윈도우의 첫 pane에 `/sc:load`를 자동 전송합니다.

```bash
# 1) 세션 템플릿을 복사해 자신의 프로젝트 경로에 맞게 수정 (tmux_init.yaml 은 gitignore 대상)
cp tmux/tmux_init_example.yaml tmux/tmux_init.yaml

# 2) 세션 생성 또는 기존 세션에 attach
./tmux/claude-research

# 백그라운드에서 세션 생성
./tmux/claude-research -d

# 기존 세션 종료 후 새로 생성
./tmux/claude-research -k

# Remote Control 이름 주입 없이 YAML 그대로 로드
./tmux/claude-research -R

# --rc 주입 결과만 diff로 확인 (세션 생성 안 함)
./tmux/claude-research --dry-run
```

템플릿은 윈도우마다 `even-horizontal` 레이아웃으로 왼쪽에 Claude Code, 오른쪽에 `nvim -c "'0"`(마지막 편집 위치로 복귀) pane을 두는 형태이며, 예시 파일에는 윈도우 3개가 들어 있습니다. 런처는 Claude CLI 기동을 5초 기다린 뒤 각 윈도우의 1번 pane에 `/sc:load` 를 보냅니다.

### 설치

```bash
# tmux.conf 심볼릭 링크
ln -s /path/to/MyConfig/tmux/tmux.conf ~/.tmux.conf

# TPM 설치 — tmux.conf 마지막 줄이 이 경로를 실행하므로 필수
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# tmux를 띄운 뒤 prefix + I 로 플러그인 설치 (tmux-sensible, tmux-yank)
tmux

# (선택) 런처를 어디서든 실행할 수 있게 PATH 상의 디렉터리에 링크
ln -s /path/to/MyConfig/tmux/claude-research ~/.local/bin/claude-research
```

> macOS에서는 `tmux-256color` terminfo가 없어 색이 깨질 수 있습니다. `infocmp tmux-256color` 가 실패하면 `tic -xe tmux-256color,tmux <(infocmp -x tmux-256color)` 로 설치하세요 (`tmux.conf` 상단 주석에 같은 안내가 있습니다).

## Ghostty

[Ghostty](https://ghostty.org/) 터미널 설정 파일입니다. iTerm2 Default 프로파일의 키바인딩을 Ghostty 문법으로 1:1 이식하고, 폰트·테마·알림·macOS UI 설정을 통합한 구성입니다.

### 폰트

| 항목 | 값 |
|------|-----|
| Primary | JetBrainsMono Nerd Font (영문, ligature 풍부) |
| Fallback | Apple SD Gothic Neo (CJK, macOS 시스템 통합) |
| Size | 14 |
| Ligature | `+calt`, `+liga` 활성 (`=>`, `!=`, `>=`, `===`, `\|>` 등) |
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

> macOS에서는 `~/Library/Application Support/com.mitchellh.ghostty/config.ghostty`(또는 `config`)가 위 파일보다 나중에 읽혀 같은 항목을 덮어씁니다. 이 저장소의 설정이 적용되지 않는 것 같다면 그 파일이 비어 있는지 먼저 확인하세요.

## Claude Code

[Claude Code](https://claude.ai/claude-code)의 사용자 전역 설정(`~/.claude/settings.json`)을 저장소에서 관리합니다. 다른 설정과 달리 **심볼릭 링크를 쓰지 않고, 저장소의 층을 합성해 생성**합니다.

```
claude/settings.common.json    두 머신 공통
claude/settings.linux.json  ┐  OS별 차이 (플러그인 구성, tui, theme 등)
claude/settings.macos.json  ┘
            │
            ├─ python3 claude/build-settings.py
            ▼
   ~/.claude/settings.json     생성된 실제 파일 (추적하지 않음)
```

**왜 링크가 아닌가.** 두 머신의 플러그인·마켓플레이스 구성이 실제로 다릅니다(Linux 에는 mattpocock, macOS 에는 langchain·tavily). 한 파일을 공유하면 어느 한쪽이 반드시 깨집니다. 그리고 Claude Code 에는 사용자 전역 설정을 덮어쓸 오버라이드 레이어가 **없습니다** — `settings.local.json` 은 프로젝트 스코프 전용이고(우선순위는 user → project → local), `~/.claude/settings.local.json` 에 둔 값은 읽히지 않습니다. 그래서 "공통 + 머신별" 을 설정 파일 계층으로 표현할 수 없고, 합성이라는 우회가 필요합니다.

부수 효과로 이전의 "링크가 저절로 풀린다" 는 문제도 사라집니다. Claude Code 가 `/config` 로 파일을 통째로 새로 써도 깨질 링크가 없습니다.

**병합 규칙**

| 대상 | 규칙 |
|------|------|
| `permissions.allow` / `deny` / `ask` / `additionalDirectories` | 합집합 (공통 먼저, 중복 제거) |
| 객체 (`modelSettings`, `skillOverrides`, `hooks`, `enabledPlugins`, `extraKnownMarketplaces` …) | 재귀 병합 |
| 스칼라 (`tui`, `theme`, `model` …) | OS별 층이 이김 |

**사용법**

```bash
python3 claude/build-settings.py              # 이 머신용으로 생성 (OS 자동 판별)
python3 claude/build-settings.py --dry-run     # 적용 전 diff 확인
python3 claude/build-settings.py --os macos    # 다른 머신 설정 미리보기
```

덮어쓰기 전에 `~/.claude/settings.json.bak.<타임스탬프>` 로 백업하고, 내용이 같으면 쓰지 않습니다(멱등).

**설정을 바꿀 때.** `/config` 나 권한 프롬프트의 "always allow" 는 생성된 `~/.claude/settings.json` 을 고치므로 저장소에 반영되지 않습니다. 남기려면 해당 변경을 공통층이나 OS별 층에 손으로 옮긴 뒤 스크립트를 다시 돌리세요. `--dry-run` 으로 홈 쪽에만 있는 변경을 찾을 수 있습니다.

### 담고 있는 것

| 블록 | 내용 |
|------|------|
| `permissions.allow` | 확인 없이 실행할 명령 — 조회(`grep`/`ls`/`cat`/`find`/`tree`), **파일 조작**(`mv`/`mkdir`/`touch`, `Edit(*.py)`·`*.docx`·`*.pptx`), `push`/`reset`/`rebase` 를 뺀 대부분의 git 하위 명령과 `gh`, `python`/`pytest`/`ruff`/`pip install`, `docker compose`, `npm init`/`install`, document-skills 계열 스킬, `WebSearch`·`WebFetch(docs.anthropic.com, github.com)`, airis MCP 게이트웨이 |
| `permissions.deny` | 파괴적·민감 작업 차단 — `sudo`, `git push/reset/rebase`, `npm uninstall`/`npm remove`, SSH 키·`*token*` 읽기, `secrets/` 편집 · **Linux 층에서 추가로** `rm`/`rm -rf`, `.env*`·`.envs/**` 읽기·편집까지 차단 |
| `hooks` | 8개 라이프사이클 이벤트(SessionStart/SessionEnd, UserPromptSubmit, Stop/StopFailure, PostToolUse/PostToolUseFailure, PermissionRequest)에서 [Superset](https://github.com/superset-sh/superset) 에이전트 상태 알림 스크립트 호출. `$SUPERSET_HOME_DIR`가 없으면 아무 일도 하지 않음(no-op) |
| `enabledPlugins` / `extraKnownMarketplaces` | **OS별로 다름** — 공통 활성: document-skills(anthropics/skills), lazy2work(개인 마켓플레이스), ui-ux-pro-max · Linux 추가: mattpocock-skills(로컬 디렉터리 소스) · macOS 추가: tavily, 비활성 상태의 langchain-skills·frontend-design |
| 기타 | 공통 — `model`, `effortLevel`과 모델별 오버라이드(`modelSettings`), `editorMode = vim`, 끈 내장 스킬 14개(`skillOverrides`) · OS별 — `tui`(Linux `fullscreen` / macOS `default`), `theme`(Linux 전용) |

> **주의 — 복사해 쓰기 전에 검토하세요.** 이 파일은 `"defaultMode": "auto"`와 `"skipDangerousModePermissionPrompt": true`로 권한 확인을 최소화한 **개인용 설정**입니다. 위 `deny` 목록이 안전망 역할을 하지만, 그대로 가져다 쓰면 같은 수준의 자동 실행 권한을 에이전트에 부여하게 됩니다. `permissions`를 본인 환경에 맞게 조정한 뒤 사용하세요.

### 저장소에 포함되지 않는 것

`claude/` 안의 **세 층과 생성 스크립트만** 추적합니다. 생성 결과물인 `~/.claude/settings.json` 은 추적하지 않습니다. 아래도 비밀값·개인 이력이 들어 있으므로 커밋하지 않습니다.

- `~/.claude/.credentials.json` — OAuth 자격증명
- `~/.claude.json` — MCP 서버 설정(API 키 포함), 계정 정보
- `~/.mcp.json` — 프로젝트 스코프 MCP 설정(API 키 포함)
- `~/.claude/settings.local.json` — 과거 세션 잔재. Claude Code 는 이 경로를 **읽지 않습니다**(`settings.local.json` 은 프로젝트 스코프 전용)
- `~/.claude/projects/`, `history.jsonl`, `shell-snapshots/` — 세션 전사본·프롬프트 이력·셸 환경 스냅샷

### 설치

```bash
python3 /path/to/MyConfig/claude/build-settings.py --dry-run
python3 /path/to/MyConfig/claude/build-settings.py
```

첫 명령으로 기존 설정과의 diff 를 먼저 확인하고, 두 번째로 실제 생성합니다. 덮어쓰기 전 백업은 자동입니다.

> **예전 방식에서 넘어올 때 (macOS).** `~/.claude/settings.json` 이 저장소의 `claude/settings.json` 을 가리키는 심볼릭 링크였다면, 그 파일은 세 층으로 쪼개져 더 이상 없습니다. `git pull` 후 링크가 끊어지므로 아래로 한 번 정리하세요.
>
> ```bash
> [ -L ~/.claude/settings.json ] && rm ~/.claude/settings.json
> python3 /path/to/MyConfig/claude/build-settings.py
> ```

## 의존성

- [Neovim](https://neovim.io/) >= 0.10
- [tmux](https://github.com/tmux/tmux) >= 3.4 + [TPM](https://github.com/tmux-plugins/tpm) (`tmux.conf` 마지막 줄이 TPM을 실행합니다)
- [tmuxp](https://github.com/tmux-python/tmuxp) (세션 런처 사용 시)
- [Ghostty](https://ghostty.org/) >= 1.3 (선택; 키바인딩·`bell-features` 사용 시)
- JetBrainsMono Nerd Font (Ghostty 기본 폰트; CJK fallback인 Apple SD Gothic Neo는 macOS 기본 제공)
- [Claude Code](https://claude.ai/claude-code) (nvim `claudecode` extra, 세션 런처, `claude/` 설정)
- [Superset](https://github.com/superset-sh/superset) (선택; 없으면 Claude Code hooks는 no-op)
- [pandoc](https://pandoc.org/) + xelatex (선택; Markdown → PDF 변환 시). `pdf-korean` 정의 파일은 저장소에 없으므로 `~/.local/share/pandoc/defaults/pdf-korean.yaml` 에 직접 두어야 합니다

## License

[MIT](LICENSE) — 단, `nvim/`의 LazyVim starter template 유래 파일은 [Apache License 2.0](nvim/LICENSE)을 따릅니다. 개인 작성 부분(`nvim/lua/config/`, `nvim/lua/plugins/`, `tmux/`, `ghostty/`, `claude/`)은 MIT입니다.

두 라이선스의 경계에 대한 배경은 [nvim/AboutRepository.md](nvim/AboutRepository.md)를 참고하세요.
