return {
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    config = true,
    cmd = {
      "ClaudeCode",
      "ClaudeCodeFocus",
      "ClaudeCodeSend",
      "ClaudeCodeOpen",
      "ClaudeCodeClose",
      "ClaudeCodeAdd",
      "ClaudeCodeTreeAdd",
    },
    keys = {
      { ";C", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude Code" },
      { ";cf", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { ";cs", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection to Claude" },
      {
        ";cc",
        function()
          local buf = vim.api.nvim_get_current_buf()
          local file = vim.api.nvim_buf_get_name(buf)
          local row = vim.api.nvim_win_get_cursor(0)[1]
          local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
          local cs = vim.bo.commentstring:gsub("%%s", ""):gsub("%s+$", "")
          local is_comment = function(s)
            return cs ~= "" and s:match("^%s*" .. vim.pesc(cs)) ~= nil
          end
          local start_row, end_row = row, row
          if is_comment(lines[row] or "") then
            while start_row > 1 and is_comment(lines[start_row - 1] or "") do
              start_row = start_row - 1
            end
            while end_row < #lines and is_comment(lines[end_row + 1] or "") do
              end_row = end_row + 1
            end
          end
          require("claudecode").send_at_mention(
            file,
            start_row - 1,
            end_row - 1,
            "Complete this code/comment in place. Output only the completion."
          )
        end,
        desc = "Claude: complete at cursor",
      },
    },
  },
}
