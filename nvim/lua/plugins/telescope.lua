return {
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        file_ignore_patterns = {
          "%.DS_Store",
          "__pycache__/",
          "%.pyc",
        },
      },
      pickers = {
        find_files = {
          hidden = true, -- dotfiles 포함
        },
        live_grep = {
          additional_args = { "--hidden" }, -- dotfiles 내용도 grep
        },
      },
    },
  },
}
