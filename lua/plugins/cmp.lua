return {
  {
    "saghen/blink.cmp",
    version = "*",
    event = { "InsertEnter", "CmdlineEnter" },
    opts = {
      keymap = { preset = "default" },
      cmdline = {
        enabled = true,
        keymap = {
          preset = "cmdline",
          ["<Tab>"] = { "show_and_insert", "select_next" },
          ["<S-Tab>"] = { "show_and_insert", "select_prev" },
          ["<CR>"] = { "accept_and_enter", "fallback" },
        },
        completion = {
          menu = { auto_show = true },
          list = { selection = { preselect = false, auto_insert = true } },
        },
      },
      completion = {
        accept = { auto_brackets = { enabled = true } },
        menu = { auto_show = true, border = "rounded" },
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      signature = { enabled = true },
    },
  },
}
