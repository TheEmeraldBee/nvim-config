vim.diagnostic.config({
  virtual_lines = { current_line = true },
  virtual_text = false,
  underline = true,
  severity_sort = true,
  float = { border = "rounded", source = "if_many" },
})
