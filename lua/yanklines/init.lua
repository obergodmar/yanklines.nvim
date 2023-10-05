local M = {}

---@return string|nil
local function get_last_search()
  local last_search = vim.fn.getreg('/')
  if not last_search then
    print('There is now last search')

    return nil
  end

  return last_search
end

local function clean_reg()
  pcall(vim.fn.setreg, 'a', '')
end

---@param last_search string
---@param v_mode boolean
local function write_matched_text(last_search, v_mode)
  -- If we are in V-Block write matched text only from selected region
  -- otherwise write from hole buffer
  local cmd_special = v_mode and "'<,'>" or '%'

  -- To divide match searches by a new line it is mandatory to write into
  -- different reg rather then just to +y.
  local cmd = cmd_special .. 's/' .. last_search .. "/\\=setreg('A', submatch(0) . '\\n')/n"

  local success, error = pcall(vim.api.nvim_command, cmd)
  if not success then
    print("Can't write to reg a", error)
  end
end

local function read_text_from_reg()
  local escaped_result = vim.fn.getreg('a')
  if not escaped_result then
    print("Can't read reg a")
  end

  -- In order to use copied lines we need to unescape the result back
  -- to print text without \/n
  local unescaped_result = escaped_result:gsub('\\n', '\n')
  pcall(vim.fn.setreg, '+y', unescaped_result)
end

---@param v_mode boolean
M.yank_lines = function(v_mode)
  -- Make sure that's the a reg doesn't contain anything
  clean_reg()

  local last_search = get_last_search()
  if last_search == nil then
    return
  end

  v_mode = v_mode or false
  if v_mode then
    -- Exit V-Block mode in order to get last region
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<esc>', true, false, true), 'x', true)
  end
  write_matched_text(last_search, v_mode)
  read_text_from_reg()

  -- Cleaning reg after manipulation 
  clean_reg()
end

return M
