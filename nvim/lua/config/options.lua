-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- 맞춤법 검사 비활성화 (한국어 문서에서 빨간 밑줄 방지)
vim.opt.spell = false

-- 시스템 클립보드 연동
vim.opt.clipboard = "unnamedplus"

-- SSH 원격 환경: OSC 52를 통해 iTerm2 클립보드로 yank 전달
if vim.env.SSH_TTY then
  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
      ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
    },
  }
end
