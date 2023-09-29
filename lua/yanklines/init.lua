local M = {}

local function clean_reg()
  pcall(vim.fn.setreg, 'a', '')
end

M.yank_lines = function()
  clean_reg()

  local last_search = vim.fn.getreg('/')
  if not last_search then
    print('There is now last search')

    return
  end

  local cmd = '%s/' .. last_search .. "/\\=setreg('A', submatch(0) . '\\n')/n"

  local success = pcall(vim.api.nvim_command, cmd)
  if not success then
    print("Can't write to reg a")
  end

  local escaped_result = vim.fn.getreg('a')
  if not escaped_result then
    print("Can't read reg a")
  end

  local unescaped_result = escaped_result:gsub('\\n', '\n')
  pcall(vim.fn.setreg, '+y', unescaped_result)

  clean_reg()
end

return M
