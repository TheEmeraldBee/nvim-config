local map = vim.keymap.set

map("n", ";w", "<cmd>write<cr>", { desc = "Write file" })
map("n", ";q", function()
  require("mini.bufremove").delete(0, false)
end, { desc = "Close buffer (keep window)" })
map("n", ";Q", "<cmd>q<cr>", { desc = "Quit window" })
map("n", ";<C-q>", "<cmd>qall<cr>", { desc = "Quit all" })
map("n", ";<C-r>", function()
  for name, _ in pairs(package.loaded) do
    if name:match("^config") or name:match("^plugins") then
      package.loaded[name] = nil
    end
  end
  vim.cmd("source $MYVIMRC")
  local ok, lazy = pcall(require, "lazy")
  if ok then
    for _, p in ipairs(lazy.plugins()) do
      pcall(lazy.reload, { plugins = { p.name } })
    end
  end
  vim.notify("Config reloaded", vim.log.levels.INFO)
end, { desc = "Reload config" })
map("n", ";s", "<cmd>1ToggleTerm direction=float<cr>", { desc = "Toggle terminal" })
map("t", "<C-\\><C-n>", "<C-\\><C-n>", { desc = "Terminal: normal mode" })

for _, k in ipairs({ "h", "j", "k", "l" }) do
  map("n", "<M-" .. k .. ">", "<C-w>" .. k, { desc = "Window: move " .. k })
  map("t", "<M-" .. k .. ">", "<C-\\><C-n><C-w>" .. k, { desc = "Window: move " .. k })
  map("i", "<M-" .. k .. ">", "<Esc><C-w>" .. k, { desc = "Window: move " .. k })
  map("v", "<M-" .. k .. ">", "<Esc><C-w>" .. k, { desc = "Window: move " .. k })
end

-- Alt+Shift+hjkl: resize the edge the key points at by 1% per press.
-- Grows into a neighbor if there is one, shrinks when against the screen edge.
local function resize(dir)
  return function()
    local horizontal = dir == "h" or dir == "l"
    local total = horizontal and vim.o.columns or vim.o.lines
    local step = math.max(1, math.floor(total * 0.05))
    local sign = vim.fn.winnr(dir) ~= vim.fn.winnr() and "+" or "-"
    vim.cmd((horizontal and "vertical " or "") .. "resize " .. sign .. step)
  end
end
map("n", "<M-H>", resize("h"), { desc = "Resize window: left edge" })
map("n", "<M-L>", resize("l"), { desc = "Resize window: right edge" })
map("n", "<M-J>", resize("j"), { desc = "Resize window: bottom edge" })
map("n", "<M-K>", resize("k"), { desc = "Resize window: top edge" })

map("n", "<M-c>", "<cmd>ClaudeCode<cr>", { desc = "Toggle Claude Code" })
map("t", "<M-c>", "<C-\\><C-n><cmd>ClaudeCode<cr>", { desc = "Toggle Claude Code" })
map("i", "<M-c>", "<Esc><cmd>ClaudeCode<cr>", { desc = "Toggle Claude Code" })

map("n", "<leader>/", function()
  require("telescope.builtin").live_grep()
end, { desc = "Global regex search" })

map("n", "<leader>k", function()
  vim.lsp.buf.hover({ border = "rounded", max_width = 100, max_height = 30 })
end, { desc = "Hover" })
map({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action, { desc = "Code action" })

map("n", "<leader>xl", function()
  local cfg = vim.diagnostic.config() or {}
  local on = cfg.virtual_lines and cfg.virtual_lines ~= false
  vim.diagnostic.config({ virtual_lines = not on and { current_line = true } or false })
end, { desc = "Toggle inline diagnostics (current line)" })

map("n", "<leader>xL", function()
  local cfg = vim.diagnostic.config() or {}
  local all = type(cfg.virtual_lines) == "table" and cfg.virtual_lines.current_line == nil
  vim.diagnostic.config({ virtual_lines = not all and true or { current_line = true } })
end, { desc = "Toggle inline diagnostics (all lines)" })

map("n", "U", "<C-r>", { desc = "Redo" })

map("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

map("n", "gn", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "gp", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map({ "n", "v", "o" }, "gh", "^", { desc = "First non-whitespace char" })
map({ "n", "v", "o" }, "gl", "$", { desc = "Last char" })
