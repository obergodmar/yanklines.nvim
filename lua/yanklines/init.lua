local M = {}

local function clean_reg()
  vim.fn.setreg('a', '')
end

M.yank_lines = function()
  clean_reg()

  local last_search = vim.fn.getreg('/')
  local cmd = '%s/' .. last_search .. [[/\\=setreg('A', submatch(0)
)/n]]

  vim.cmd(cmd)

  local result = vim.fn.getreg('a')
  vim.fn.setreg('+y', result)

  clean_reg()
end

return M
