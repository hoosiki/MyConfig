# About This Repository

## Overview

이 레포지토리는 [LazyVim](https://github.com/LazyVim/LazyVim) starter template를 기반으로 한 개인 Neovim 설정입니다.
LazyVim starter template의 기본 구조 위에 개인 커스터마이징(키맵, 플러그인 설정 등)을 추가하여 관리합니다.

## License

### 원본 라이센스

LazyVim starter template은 **Apache License 2.0**으로 배포되며, 이 레포지토리에 포함된 `LICENSE` 파일이 해당됩니다.

### Apache 2.0이 허용하는 것

| 항목 | 허용 여부 |
|------|----------|
| 수정 및 커스터마이징 | 허용 |
| 개인 레포지토리에 업로드 | 허용 |
| 공개(public) 레포지토리로 배포 | 허용 |
| 상업적 사용 | 허용 |
| 자신이 추가한 코드에 별도 라이센스 적용 | 허용 |

### 준수해야 할 조건 (Apache 2.0 제4조)

1. **LICENSE 파일 유지** — `LICENSE` 파일을 삭제하지 않을 것
2. **수정 표시** — 원본에서 수정한 파일에 변경 사실을 표시 (권장)
3. **저작권 고지 유지** — 원본의 copyright, patent, trademark 고지를 제거하지 않을 것
4. **NOTICE 파일 포함** — NOTICE 파일이 있는 경우 함께 배포 (이 template에는 없음)

## 파일 구조 및 저작권 구분

```
.config/nvim/
├── LICENSE              ← LazyVim (Apache 2.0) — 삭제 금지
├── README.md            ← LazyVim template 원본 → 수정 가능
├── AboutRepository.md   ← 이 파일 (개인 작성)
├── init.lua             ← LazyVim template 원본
├── lazy-lock.json       ← 자동 생성 (플러그인 버전 lock)
├── lazyvim.json         ← LazyVim extras 설정
├── stylua.toml          ← LazyVim template 원본
└── lua/
    ├── config/          ← 개인 작성 설정
    │   ├── autocmds.lua
    │   ├── keymaps.lua
    │   ├── lazy.lua
    │   └── options.lua
    └── plugins/         ← 개인 작성 플러그인 설정
        ├── auto-session.lua
        ├── lsp.lua
        ├── markdown.lua
        ├── neo-tree.lua
        ├── python.lua
        ├── telescope.lua
        └── treesitter.lua
```

### 구분 기준

- **LazyVim template 유래**: `LICENSE`, `init.lua`, `stylua.toml`, `README.md` — Apache 2.0 적용
- **개인 작성 코드**: `lua/config/*.lua`, `lua/plugins/*.lua` — 자유롭게 사용 가능
- **자동 생성**: `lazy-lock.json` — 저작권 대상 아님

## 참고

- LazyVim starter template은 사용자가 fork하여 자신만의 설정을 구성하도록 설계된 프로젝트입니다.
- GitHub에 다수의 LazyVim 기반 dotfiles 레포지토리가 동일한 방식으로 공개되어 있으며, 이는 일반적인 관행입니다.
- Apache 2.0은 OSI 인증 오픈소스 라이센스 중 가장 관대한 라이센스 중 하나입니다.
