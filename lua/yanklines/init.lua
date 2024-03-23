---@return string|string[]|nil
local function get_last_search()
  local last_search = vim.fn.getreg('/')
  if not last_search then
    print('There is no last search')

    return nil
  end

  return last_search
end

---@param reg_name string
local function clean_reg(reg_name)
  pcall(vim.fn.setreg, reg_name, '')
end

---@param last_search string|string[]
---@param v_mode boolean
local function read_matched_text(last_search, v_mode)
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

---@return string
local function read_text_from_reg()
  local escaped_result = vim.fn.getreg('a')
  if not escaped_result then
    error("Can't read reg a")
  end

  if type(escaped_result) == 'table' then
    escaped_result = table.concat(escaped_result, '')
  end

  -- In order to use copied lines we need to unescape the result back
  -- to print text without \/n
  local result = escaped_result:gsub('\\n', '\n')

  return result
end

--- v_mode - execute the fn in V-Block neovim mode
--- reg_read_to - register name to read to data from matched text. Default is 'a'.
--- reg_write_to - register name to write to data. Default is '+y' which is the system clipboard.
---@param opts { v_mode: boolean?, reg_read_to: string?, reg_write_to: string? }?
local function yank_lines(opts)
  opts = opts or {}

  local reg_read_to = opts.reg_read_to or 'a'
  -- Make sure that's the 'read to reg' doesn't contain anything
  clean_reg(reg_read_to)

  local last_search = get_last_search()
  if last_search == nil then
    return
  end

  local v_mode = opts.v_mode or false
  if v_mode then
    -- Exit V-Block mode in order to get last region
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<esc>', true, false, true), 'x', true)
  end

  read_matched_text(last_search, v_mode)

  local text = read_text_from_reg()
  -- Cleaning reg after manipulation
  clean_reg(reg_read_to)

  local reg_write_to = opts.reg_write_to or '+y'
  -- Finally write to reg
  pcall(vim.fn.setreg, reg_write_to, text)

  print("yank lines to ", reg_write_to)
end

return {
  yank_lines = yank_lines,
}
