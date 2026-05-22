return {
  {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    event = "VeryLazy",
    config = function()
      local mc = require("multicursor-nvim")
      mc.setup()

      local map = vim.keymap.set
      local set = function(modes, lhs, rhs, desc)
        map(modes, lhs, rhs, { desc = desc })
      end

      -- Helix-style: C adds cursor below, <A-C> above
      set({ "n", "v" }, "C", function() mc.lineAddCursor(1) end, "MC: add cursor below")
      set({ "n", "v" }, "<A-C>", function() mc.lineAddCursor(-1) end, "MC: add cursor above")

      -- Skip current, add next/prev match (Helix: */n style)
      set({ "n", "v" }, "<leader>n", function() mc.matchAddCursor(1) end, "MC: add cursor at next match")
      set({ "n", "v" }, "<leader>N", function() mc.matchAddCursor(-1) end, "MC: add cursor at prev match")
      set({ "n", "v" }, "<leader>s", function() mc.matchSkipCursor(1) end, "MC: skip current, next match")
      set({ "n", "v" }, "<leader>S", function() mc.matchSkipCursor(-1) end, "MC: skip current, prev match")

      -- Helix s: select all regex matches inside selection
      set("v", "s", mc.matchCursors, "MC: select all matches in selection")
      -- Helix S: split selection on regex
      set("v", "S", mc.splitCursors, "MC: split selection on regex")
      -- Helix &: align cursor columns
      set("v", "&", mc.alignCursors, "MC: align cursors")

      -- Helix ,: keep primary / remove others
      set({ "n", "v" }, ",", function()
        if mc.hasCursors() then
          mc.clearCursors()
        else
          -- preserve normal-mode `,` as no-op when no cursors
        end
      end, "MC: keep primary cursor")

      -- Helix <A-,>: remove primary cursor (keep others)
      set({ "n", "v" }, "<A-,>", mc.deleteCursor, "MC: delete primary cursor")

      -- Disable cursors temporarily (Helix-ish escape)
      set({ "n", "v" }, "<esc>", function()
        if not mc.cursorsEnabled() then
          mc.enableCursors()
        elseif mc.hasCursors() then
          mc.clearCursors()
        else
          vim.cmd("nohlsearch")
        end
      end, "MC: clear / re-enable cursors")

      -- Toggle cursor at current position (manual add)
      set({ "n", "v" }, "<leader>mt", mc.toggleCursor, "MC: toggle cursor")
      -- Add cursors to all regex matches in buffer
      set("n", "<leader>ma", mc.matchAllAddCursors, "MC: add cursors to all matches in buffer")
      -- Mouse: ctrl-leftclick to add cursor
      set("n", "<c-leftmouse>", mc.handleMouse, "MC: add cursor at mouse")
      set("n", "<c-leftdrag>", mc.handleMouseDrag, "MC: drag cursors")
      set("n", "<c-leftrelease>", mc.handleMouseRelease, "MC: release")

      -- Rotate primary among cursors
      set({ "n", "v" }, "<leader>mn", mc.nextCursor, "MC: next cursor")
      set({ "n", "v" }, "<leader>mp", mc.prevCursor, "MC: prev cursor")

      -- Highlight groups (catppuccin-friendly defaults)
      local hl = vim.api.nvim_set_hl
      hl(0, "MultiCursorCursor", { link = "Cursor" })
      hl(0, "MultiCursorVisual", { link = "Visual" })
      hl(0, "MultiCursorSign", { link = "SignColumn" })
      hl(0, "MultiCursorMatchPreview", { link = "Search" })
      hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
      hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
      hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
    end,
  },
}
