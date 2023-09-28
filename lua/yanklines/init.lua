local M = {}

local function clean_reg()
  vim.fn.setreg('a', '')
end

M.yank_lines = function()
  clean_reg()

  local last_search = vim.fn.getreg('/')
  local cmd = '%s/' .. last_search .. "/\\=setreg('A', submatch(0) . '\\n')/n"

  vim.cmd(cmd)

  local escaped_result = vim.fn.getreg('a')
  local unescaped_result = escaped_result:gsub('\\n', '\n')
  vim.fn.setreg('+y', unescaped_result)

  clean_reg()
end

return M
