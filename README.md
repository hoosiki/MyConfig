# MyConfig

macOS 개발 환경을 위한 Neovim + tmux 설정 파일 모음입니다.

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
└── tmux/                  # tmux 설정
    ├── tmux.conf          # tmux 메인 설정 파일
    ├── tmux_init_example.yaml  # tmuxp 세션 템플릿 (예시)
    └── claude-research    # tmuxp 세션 런처 스크립트
```

## Neovim

[LazyVim](https://github.com/LazyVim/LazyVim) starter template 기반에 개인 커스터마이징을 추가한 구성입니다.

### 활성화된 LazyVim Extras

- **언어**: Python, TypeScript, JSON, YAML, TOML, Markdown, SQL, Tailwind, CMake, Git
- **에디터**: Neo-tree, FZF, Outline, Dial
- **코딩**: Yanky

### 주요 커스텀 플러그인

| 파일 | 설명 |
|------|------|
| `plugins/lsp.lua` | LSP 설정 |
| `plugins/python.lua` | Python 개발 환경 |
| `plugins/telescope.lua` | Telescope 검색 설정 |
| `plugins/neo-tree.lua` | 파일 탐색기 설정 |
| `plugins/markdown.lua` | Markdown 미리보기/편집 |
| `plugins/auto-session.lua` | 세션 자동 저장/복원 |
| `plugins/treesitter.lua` | Treesitter 구문 강조 |

### 주요 커스텀 옵션

- 맞춤법 검사 비활성화 (한국어 환경 대응)
- 시스템 클립보드 연동 (`unnamedplus`)
- SSH 원격 환경에서 OSC 52를 통한 클립보드 지원
- `<leader>fp`: 현재 파일 경로를 클립보드에 복사

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

tmux 3.6+ 대상 설정입니다. Solarized 256 테마를 기반으로 합니다.

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

### 비활성 Pane 구분

- 활성 pane: 밝은 파란색 테두리 (`colour39`), 기본 배경
- 비활성 pane: 어두운 테두리 (`colour238`), 어두운 배경
- `focus-events on`으로 Neovim 포커스 감지 연동

### tmuxp 세션 런처

`claude-research` 스크립트로 Claude Code + Neovim 개발 환경을 한 번에 시작할 수 있습니다.

```bash
# 세션 생성 또는 기존 세션에 attach
./tmux/claude-research

# 백그라운드에서 세션 생성
./tmux/claude-research -d

# 기존 세션 종료 후 새로 생성
./tmux/claude-research -k
```

`tmux_init_example.yaml`을 자신의 프로젝트 경로에 맞게 수정하여 사용하세요.

### 설치

```bash
# tmux.conf 심볼릭 링크
ln -s /path/to/MyConfig/tmux/tmux.conf ~/.tmux.conf

# tmuxp 세션 설정 (선택)
mkdir -p ~/.config/tmux
ln -s /path/to/MyConfig/tmux/tmux_init_example.yaml ~/.config/tmux/tmux_init.yaml
ln -s /path/to/MyConfig/tmux/claude-research ~/.config/tmux/claude-research
```

## 의존성

- [Neovim](https://neovim.io/) >= 0.10
- [tmux](https://github.com/tmux/tmux) >= 3.6
- [tmuxp](https://github.com/tmux-python/tmuxp) (세션 런처 사용 시)
- [Claude Code](https://claude.ai/claude-code) (세션 런처에서 사용)

## License

- `nvim/`: LazyVim starter template 유래 파일은 [Apache License 2.0](nvim/LICENSE) 적용. 개인 작성 코드(`lua/config/`, `lua/plugins/`)는 자유롭게 사용 가능.
- `tmux/`: 자유롭게 사용 가능.

자세한 라이선스 정보는 [nvim/AboutRepository.md](nvim/AboutRepository.md)를 참고하세요.
