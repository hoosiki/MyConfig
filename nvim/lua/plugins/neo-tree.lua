-- neo-tree 너비 토글 + 기본 설정
local narrow = 30
local wide = 160

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          visible = true, -- dotfiles를 흐리게 표시 (완전히 숨기지 않음)
          hide_dotfiles = false,
          hide_gitignored = true,
          never_show = {
            ".DS_Store",
            "thumbs.db",
            "__pycache__",
          },
        },
      },
      window = {
        width = narrow,
        mappings = {
          -- neo-tree 안에서 O 키로 Finder에서 해당 파일/폴더 위치 표시
          ["O"] = {
            function(state)
              local node = state.tree:get_node()
              local path = node:get_id()
              vim.system({ "open", "-R", path }) -- -R: Finder에서 선택된 상태로 표시
              vim.notify("Finder: " .. vim.fn.fnamemodify(path, ":t"), vim.log.levels.INFO)
            end,
            desc = "Reveal in Finder",
          },
        },
      },
    },
    keys = {
      {
        "<leader>eW",
        function()
          -- neo-tree 창을 찾아서 너비 토글
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            local ft = vim.bo[buf].filetype
            if ft == "neo-tree" then
              local current_width = vim.api.nvim_win_get_width(win)
              local new_width = current_width < wide and wide or narrow
              vim.api.nvim_win_set_width(win, new_width)
              return
            end
          end
          vim.notify("neo-tree가 열려있지 않습니다", vim.log.levels.WARN)
        end,
        desc = "Neo-tree 너비 토글 (30↔160)",
      },
    },
  },
}
