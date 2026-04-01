-- marksman LSP diagnostics 비활성화
-- Obsidian vault의 wiki link 구조(번호 파일 + 번호 디렉토리 공존)를
-- marksman이 "Ambiguous link"로 오탐하는 문제 방지
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        marksman = {
          handlers = {
            ["textDocument/publishDiagnostics"] = function() end,
          },
        },
      },
    },
  },
}
