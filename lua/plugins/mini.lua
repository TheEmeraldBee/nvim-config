-- Skipped (already covered by other plugins):
--   mini.tabline    -> bufferline.nvim
--   mini.statusline -> lualine.nvim
--   mini.notify     -> nvim-notify
--   mini.icons      -> nvim-web-devicons
return {
  {
    "echasnovski/mini.surround",
    version = "*",
    event = "VeryLazy",
    opts = {},
  },
  {
    "echasnovski/mini.bufremove",
    version = "*",
    event = "VeryLazy",
    opts = {},
  },
  {
    "echasnovski/mini.animate",
    version = "*",
    event = "VeryLazy",
    config = function()
      local animate = require("mini.animate")
      animate.setup({
        cursor = {
          enable = true,
          timing = animate.gen_timing.linear({ duration = 80, unit = "total" }),
        },
        scroll = {
          enable = true,
          timing = animate.gen_timing.linear({ duration = 120, unit = "total" }),
        },
        resize = {
          enable = true,
          timing = animate.gen_timing.linear({ duration = 120, unit = "total" }),
        },
        open = {
          enable = true,
          timing = animate.gen_timing.linear({ duration = 150, unit = "total" }),
          winconfig = animate.gen_winconfig.wipe({ direction = "from_edge" }),
          winblend = animate.gen_winblend.linear({ from = 80, to = 100 }),
        },
        close = {
          enable = true,
          timing = animate.gen_timing.linear({ duration = 150, unit = "total" }),
          winconfig = animate.gen_winconfig.wipe({ direction = "to_edge" }),
          winblend = animate.gen_winblend.linear({ from = 80, to = 100 }),
        },
      })
    end,
  },
  {
    "echasnovski/mini.indentscope",
    version = "*",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      symbol = "│",
      options = { try_as_border = true },
      draw = { delay = 50 },
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "help", "alpha", "dashboard", "neo-tree", "Trouble", "trouble",
          "lazy", "mason", "notify", "toggleterm", "lazyterm",
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },
  {
    "echasnovski/mini.hipatterns",
    version = "*",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local hi = require("mini.hipatterns")
      hi.setup({
        highlighters = {
          fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
          hack  = { pattern = "%f[%w]()HACK()%f[%W]",  group = "MiniHipatternsHack" },
          todo  = { pattern = "%f[%w]()TODO()%f[%W]",  group = "MiniHipatternsTodo" },
          note  = { pattern = "%f[%w]()NOTE()%f[%W]",  group = "MiniHipatternsNote" },
          hex_color = hi.gen_highlighter.hex_color(),
        },
      })
    end,
  },
  {
    "echasnovski/mini.cursorword",
    version = "*",
    event = { "BufReadPost", "BufNewFile" },
    opts = { delay = 100 },
  },
  {
    "echasnovski/mini.trailspace",
    version = "*",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },
  {
    "echasnovski/mini.map",
    version = "*",
    event = "VeryLazy",
    config = function()
      local map = require("mini.map")
      map.setup({
        integrations = {
          map.gen_integration.builtin_search(),
          map.gen_integration.diagnostic(),
        },
        symbols = {
          encode = map.gen_encode_symbols.dot("4x2"),
        },
      })
      vim.keymap.set("n", "<leader>mm", map.toggle, { desc = "Toggle minimap" })
      vim.keymap.set("n", "<leader>mf", map.toggle_focus, { desc = "Focus minimap" })
    end,
  },
}
