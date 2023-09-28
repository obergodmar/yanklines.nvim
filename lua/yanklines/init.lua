local M = {}

M.yank_lines = function()
  local cmd = "let @a='' | " .. vim.fn.getreg('/') .. "=setreg('A', submatch(0) . '\n')/n"
  vim.cmd(cmd)

  print(vim.fn.getreg('a'))
end

return M
