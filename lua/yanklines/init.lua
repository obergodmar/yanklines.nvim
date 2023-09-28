local M = {}

M.yank_lines = function()
  local last_search = vim.fn.getreg('/')
  local cmd = "let @a='' | %s/" .. last_search .. "/\\=setreg('A', submatch(0) . '\\n')/n"
  print(last_search)
  print(cmd)
  vim.cmd(cmd)

  print(vim.fn.getreg('a'))
end

return M
