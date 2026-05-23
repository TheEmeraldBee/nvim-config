return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
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
        "bacon-ls",
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
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      if ok then
        capabilities = cmp_lsp.default_capabilities(capabilities)
      end
      vim.lsp.config("*", { capabilities = capabilities })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = {
              checkThirdParty = false,
              library = vim.api.nvim_get_runtime_file("", true),
            },
            completion = { callSnippet = "Replace" },
            telemetry = { enable = false },
          },
        },
      })

      -- rust-analyzer handles semantics/proc-macros; bacon-ls owns
      -- cargo/clippy diagnostics, so disable r-a's flycheck to avoid dupes.
      vim.lsp.config("rust_analyzer", {
        settings = {
          ["rust-analyzer"] = {
            cargo = { allFeatures = true },
            checkOnSave = false,
          },
        },
      })

      -- bacon-ls: inline clippy/cargo diagnostics. Default cargo backend
      -- runs cargo itself (no bacon.toml or separate process needed); the
      -- <leader>cb bacon TUI complements it for live watching.
      -- Defaults are fine: cargo backend, updateOnSave enabled.
      vim.lsp.config("bacon_ls", {})

      vim.lsp.config("clangd", {
        cmd = { "clangd", "--background-index", "--clang-tidy" },
      })

      local hover = function()
        vim.lsp.buf.hover({
          border = "rounded",
          max_width = 100,
          max_height = 30,
          focusable = true,
        })
      end

      local signature = function()
        vim.lsp.buf.signature_help({ border = "rounded" })
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local buf = args.buf
          local map = function(lhs, rhs) vim.keymap.set("n", lhs, rhs, { buffer = buf }) end
          map("gd", vim.lsp.buf.definition)
          map("gr", vim.lsp.buf.references)
          map("gi", vim.lsp.buf.implementation)
          map("K", hover)
          map("<C-k>", signature)
          map("<leader>rn", vim.lsp.buf.rename)
          map("<leader>ca", vim.lsp.buf.code_action)
          map("[d", vim.diagnostic.goto_prev)
          map("]d", vim.diagnostic.goto_next)
          map("<leader>cf", function() vim.lsp.buf.format({ async = true }) end)

          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client:supports_method("textDocument/formatting") then
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = vim.api.nvim_create_augroup("lsp_format_" .. buf, { clear = true }),
              buffer = buf,
              callback = function()
                if vim.g.disable_autoformat or vim.b[buf].disable_autoformat then return end
                vim.lsp.buf.format({ bufnr = buf, timeout_ms = 2000, id = client.id })
              end,
            })
          end
        end,
      })

      vim.api.nvim_create_user_command("FormatDisable", function(args)
        if args.bang then vim.b.disable_autoformat = true else vim.g.disable_autoformat = true end
      end, { bang = true, desc = "Disable LSP format-on-save" })
      vim.api.nvim_create_user_command("FormatEnable", function()
        vim.b.disable_autoformat = false
        vim.g.disable_autoformat = false
      end, { desc = "Re-enable LSP format-on-save" })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function(args)
          local buf = args.buf
          local win = vim.api.nvim_get_current_win()
          local cfg = vim.api.nvim_win_get_config(win)
          if cfg.relative == "" then return end
          vim.wo[win].conceallevel = 2
          vim.wo[win].concealcursor = "n"
          pcall(vim.treesitter.start, buf, "markdown")
        end,
      })
    end,
  },
}
