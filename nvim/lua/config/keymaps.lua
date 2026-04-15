-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- 현재 파일 절대 경로를 클립보드에 복사
vim.keymap.set("n", "<leader>fp", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.notify("Copied: " .. path)
end, { desc = "Copy file path to clipboard" })

-- Markdown → PDF 변환 (pandoc + xelatex + 한글)
-- 고정 출력 디렉터리(~/SynologyDrive/PublicShare/pdfs)로 저장 후 Finder에서 하이라이트
local PDF_OUTPUT_DIR = "/Users/hoosiki/SynologyDrive/PublicShare/pdfs"
vim.keymap.set("n", "<leader>cP", function()
  if vim.bo.filetype ~= "markdown" then
    vim.notify("Markdown 파일이 아닙니다", vim.log.levels.ERROR)
    return
  end
  if vim.bo.modified then
    vim.notify("저장되지 않은 변경사항이 있습니다. 먼저 :w 해주세요.", vim.log.levels.ERROR)
    return
  end
  local fullname = vim.api.nvim_buf_get_name(0)
  if fullname == "" then
    vim.notify("이름 없는 버퍼는 변환할 수 없습니다", vim.log.levels.ERROR)
    return
  end
  local file_dir = vim.fn.fnamemodify(fullname, ":h")
  local basename = vim.fn.fnamemodify(fullname, ":t:r")
  local pdf_path = PDF_OUTPUT_DIR .. "/" .. basename .. ".pdf"

  vim.notify("PDF 변환 시작... → " .. pdf_path, vim.log.levels.INFO)
  vim.system({
    "pandoc",
    "-d", "pdf-korean",
    "--resource-path=" .. file_dir,
    fullname,
    "--output=" .. pdf_path,
  }, { text = true }, function(obj)
    vim.schedule(function()
      if obj.code == 0 then
        vim.notify("PDF 변환 완료: " .. basename .. ".pdf", vim.log.levels.INFO)
        vim.system({ "open", "-R", pdf_path })
      else
        vim.notify("PDF 변환 실패:\n" .. (obj.stderr or ""), vim.log.levels.ERROR)
      end
    end)
  end)
end, { desc = "Markdown to PDF (한글, → SynologyDrive/pdfs)" })
