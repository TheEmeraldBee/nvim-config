return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    cmd = "Telescope",
    keys = {
      { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Find files" },
      { "<leader>fg", function() require("telescope.builtin").live_grep() end, desc = "Live grep" },
      { "<leader>fb", function() require("telescope.builtin").buffers() end, desc = "Buffers" },
      { "<leader>fh", function() require("telescope.builtin").help_tags() end, desc = "Help tags" },
      { "<leader>fr", function() require("telescope.builtin").resume() end, desc = "Resume" },
      { "<leader>fd", function() require("telescope.builtin").diagnostics({ bufnr = 0 }) end, desc = "Diagnostics (buffer)" },
      { "<leader>fD", function() require("telescope.builtin").diagnostics() end, desc = "Diagnostics (workspace)" },
      { "<leader>fs", function() require("telescope.builtin").lsp_document_symbols() end, desc = "Doc symbols" },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          path_display = { "smart" },
          mappings = {
            i = {
              ["<C-j>"] = "move_selection_next",
              ["<C-k>"] = "move_selection_previous",
            },
          },
        },
      })
      pcall(telescope.load_extension, "fzf")
    end,
  },
}
