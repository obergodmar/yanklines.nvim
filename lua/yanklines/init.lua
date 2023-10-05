local M = {}

local function clean_reg()
  pcall(vim.fn.setreg, 'a', '')
end

M.yank_lines = function()
  -- Make sure that's the a reg doesn't contain anything
  clean_reg()

  local last_search = vim.fn.getreg('/')
  if not last_search then
    print('There is now last search')

    return
  end

  -- To divide match searches by a new line it is mandatory to write into
  -- different reg rather then just to +y.
  local cmd = '%s/' .. last_search .. "/\\=setreg('A', submatch(0) . '\\n')/n"

  local success = pcall(vim.api.nvim_command, cmd)
  if not success then
    print("Can't write to reg a")
  end

  local escaped_result = vim.fn.getreg('a')
  if not escaped_result then
    print("Can't read reg a")
  end

  -- In order to use copied lines we need to unescape the result back
  -- to print text without \/n
  local unescaped_result = escaped_result:gsub('\\n', '\n')
  pcall(vim.fn.setreg, '+y', unescaped_result)

  clean_reg()
end

return M
