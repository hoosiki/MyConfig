return {
  -- render-markdown.nvim: Obsidian 스타일 마크다운 렌더링
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    ft = { "markdown", "norg", "rmd", "org" },
    opts = {
      -- Obsidian 프리셋: Obsidian UI를 최대한 모방
      preset = "obsidian",
      -- 렌더링 모드: normal, command, terminal 모드에서 렌더링
      render_modes = { "n", "c", "t" },
      -- 헤딩 설정
      heading = {
        enabled = true,
        sign = false,
        -- Obsidian 스타일 아이콘
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
        width = "full",
        border = true,
        border_virtual = true,
      },
      -- 코드 블록
      code = {
        enabled = true,
        sign = false,
        width = "block",
        right_pad = 1,
        language_pad = 1,
        border = "thick",
        above = "▄",
        below = "▀",
      },
      -- 체크박스: Obsidian 스타일
      checkbox = {
        enabled = true,
        unchecked = { icon = "󰄱 " },
        checked = { icon = "󰱒 " },
        custom = {
          todo = { raw = "[-]", rendered = "󰥔 ", highlight = "RenderMarkdownTodo" },
          important = { raw = "[!]", rendered = "󰀪 ", highlight = "DiagnosticWarn" },
          canceled = { raw = "[~]", rendered = "󰰱 ", highlight = "RenderMarkdownChecked" },
        },
      },
      -- 블록 인용 & Callout
      quote = {
        enabled = true,
        icon = "▋",
        repeat_linebreak = true,
      },
      -- 대시/불릿
      bullet = {
        enabled = true,
        icons = { "●", "○", "◆", "◇" },
      },
      -- 링크
      link = {
        enabled = true,
        hyperlink = "󰌹 ",
        wiki = { icon = "󱗖 " },
      },
      -- 테이블
      pipe_table = {
        enabled = true,
        preset = "round",
        border = {
          "╭", "┬", "╮",
          "├", "┼", "┤",
          "╰", "┴", "╯",
          "│", "─",
        },
      },
      -- 수평선
      dash = {
        enabled = true,
        icon = "─",
        width = "full",
      },
      -- 인라인 코드
      inline_code = {
        enabled = true,
      },
      -- win_options: 줄바꿈 시 렌더링 유지
      win_options = {
        showbreak = { default = "", rendered = "  " },
        breakindent = { default = false, rendered = true },
        breakindentopt = { default = "", rendered = "" },
      },
    },
    keys = {
      { "<leader>um", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle Markdown Render" },
    },
  },

  -- markdown lint 비활성화
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        markdown = {},
      },
    },
  },

  -- markdown format-on-save 비활성화 (prettier가 _를 *로 변환하는 문제 방지)
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        markdown = {},
        ["markdown.mdx"] = {},
      },
    },
  },

  -- markdown-preview.nvim: 브라우저 미리보기 (레거시, <leader>cP 에서 PDF용으로 유지)
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      require("lazy").load({ plugins = { "markdown-preview.nvim" } })
      vim.fn["mkdp#util#install"]()
    end,
    keys = {
      { "<leader>cm", "<cmd>MarkdownPreviewToggle<cr>", ft = "markdown", desc = "Markdown Preview (mkdp)" },
    },
  },

  -- live-preview.nvim: 순수 Lua 브라우저 미리보기 (최신 Mermaid, Node 불필요)
  -- build hook이 설치/업데이트 시마다 mermaid.min.js를 최신 버전으로 교체
  {
    "brianhuster/live-preview.nvim",
    dependencies = { "brianhuster/autosave.nvim" },
    lazy = true,
    cmd = { "LivePreview", "StopPreview" },
    build = function()
      local plugin_dir = vim.fn.stdpath("data") .. "/lazy/live-preview.nvim"
      local target = plugin_dir .. "/static/mermaid/mermaid.min.js"
      local url = "https://cdn.jsdelivr.net/npm/mermaid@latest/dist/mermaid.min.js"
      -- 1) 최신 mermaid 다운로드
      vim.system({ "curl", "-sL", "-o", target, url }, {}, function(obj)
        if obj.code == 0 then
          -- 2) git이 이 파일 변경을 무시하도록 설정 (Lazy sync 충돌 방지)
          vim.system({ "git", "-C", plugin_dir, "update-index", "--assume-unchanged", "static/mermaid/mermaid.min.js" }, {}, function()
            vim.schedule(function() vim.notify("Mermaid updated to latest", vim.log.levels.INFO) end)
          end)
        else
          vim.schedule(function() vim.notify("Mermaid update failed", vim.log.levels.WARN) end)
        end
      end)
    end,
    keys = {
      { "<leader>cp", "<cmd>LivePreview start<cr>", ft = "markdown", desc = "Markdown Preview (Live)" },
    },
    opts = {
      port = 5500,
      browser = "default",
      sync_scroll = true,
      picker = nil,
    },
  },
}
