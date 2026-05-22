return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      delay = 0,
      icons = { mappings = false },
      spec = {
        { "<leader>f", group = "find" },
        { "<leader>c", group = "code" },
        { "<leader>r", group = "rename/refactor" },
        { "<leader>g", group = "git" },
        { "<leader>b", group = "buffer" },
        { "<leader>w", group = "window" },
        { "<leader>x", group = "diagnostics/trouble" },
      },
    },
    keys = {
      {
        "<leader>?",
        function() require("which-key").show({ global = false }) end,
        desc = "Buffer keymaps",
      },
    },
  },
}
