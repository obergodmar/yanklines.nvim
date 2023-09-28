local M = {}

local function region_to_text()
  local region = vim.region(0, "'<", "'>", vim.fn.visualmode(), true)

  local text = ''
  local maxcol = vim.v.maxcol
  for line, cols in vim.spairs(region) do
    local endcol = cols[2] == maxcol and -1 or cols[2]
    local chunk = vim.api.nvim_buf_get_text(0, line, cols[1], line, endcol, {})[1]
    text = ('%s%s\n'):format(text, chunk)
  end
  return text
end

function M.setup()
  vim.keymap.set('n', '<leader>y', region_to_text, { desc = 'Test' })
end

return M
