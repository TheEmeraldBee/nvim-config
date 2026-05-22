return {
  {
    "mason-org/mason.nvim",
    opts = {},
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = {
        "lua_ls",
        "rust_analyzer",
        "gopls",
        "pyright",
        "clangd",
      },
      automatic_enable = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "saghen/blink.cmp" },
    config = function()
      local ok, blink = pcall(require, "blink.cmp")
      local capabilities = ok and blink.get_lsp_capabilities() or vim.lsp.protocol.make_client_capabilities()
      vim.lsp.config("*", { capabilities = capabilities })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      })

      vim.lsp.config("rust_analyzer", {
        settings = {
          ["rust-analyzer"] = {
            cargo = { allFeatures = true },
            checkOnSave = { command = "clippy" },
          },
        },
      })

      vim.lsp.config("clangd", {
        cmd = { "clangd", "--background-index", "--clang-tidy" },
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local buf = args.buf
          local map = function(lhs, rhs) vim.keymap.set("n", lhs, rhs, { buffer = buf }) end
          map("gd", vim.lsp.buf.definition)
          map("gr", vim.lsp.buf.references)
          map("gi", vim.lsp.buf.implementation)
          map("K", vim.lsp.buf.hover)
          map("<leader>rn", vim.lsp.buf.rename)
          map("<leader>ca", vim.lsp.buf.code_action)
          map("[d", vim.diagnostic.goto_prev)
          map("]d", vim.diagnostic.goto_next)
        end,
      })
    end,
  },
}
