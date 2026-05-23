return {
  {
    "akinsho/toggleterm.nvim",
    cmd = "ToggleTerm",
    keys = {
      {
        ";b",
        function()
          if not _G._bacon_term then
            _G._bacon_term = require("toggleterm.terminal").Terminal:new({
              count = 99,
              cmd = "bacon",
              direction = "vertical",
              close_on_exit = false,
              hidden = true,
              on_open = function(term)
                vim.cmd("vertical resize " .. math.floor(vim.o.columns * 0.2))
                vim.api.nvim_set_current_win(term.window)
              end,
            })
          end
          _G._bacon_term:toggle()
        end,
        desc = "Toggle bacon",
      },
    },
    opts = {
      direction = "float",
      float_opts = { border = "rounded" },
      shade_terminals = true,
      start_in_insert = true,
    },
  },
}
