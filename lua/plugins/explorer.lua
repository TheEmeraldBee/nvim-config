return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    cmd = "Neotree",
    keys = {
      { "<leader>fE", "<cmd>Neotree toggle<cr>", desc = "Explorer" },
      { "<leader>fe", "<cmd>Neotree reveal<cr>", desc = "Reveal file" },
    },
    opts = {
      close_if_last_window = true,
      filesystem = {
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = true,
        },
      },
      window = {
        width = 32,
        mappings = {
          ["<space>"] = "none",
          ["l"] = "open",
          ["h"] = "close_node",
        },
      },
    },
  },
  {
    "mikavilpas/yazi.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ft", function() require("yazi").yazi() end, desc = "Yazi (cwd of file)" },
      { "<leader>fT", function() require("yazi").yazi(nil, vim.fn.getcwd()) end, desc = "Yazi (cwd)" },
    },
    opts = {
      open_for_directories = false,
      keymaps = {
        show_help = "<f1>",
      },
    },
  },
}
