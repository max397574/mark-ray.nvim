-- Mark Ray Module
local win, buf
local M = {}

-- Create commands

local function create_commands()
  vim.cmd("command! -bang -nargs=0 MarkRayShow :lua require('mark-ray').show()")
  vim.cmd("command! -bang -nargs=0 MarkRayClose :lua require('mark-ray').close_window()")
  vim.cmd("command! -bang -nargs=0 MarkRayStart :lua require('mark-ray').ray_start()")
  vim.cmd("command! -bang -nargs=0 MarkRayStop :lua require('mark-ray').ray_stop()")
end

local function parse_marks(tmp)
  local result = {}
  table.insert(result, header)
  for s in tmp:gmatch("[^\n]+") do
    table.insert(result, string.sub(s,0,10) .. string.sub(s,16))
  end
  table.insert(result,"")
  table.insert(result,"")

  return result

end

local function create_window()
  local w = vim.api.nvim_win_get_width(0)
  local width = 40
  local row = 1
  local col = w - width
  -- NOTE: Perhaps change these
  local config = {
    style="minimal",
    relative='editor',
    focusable=false,
    row=row,
    col=col,
    width=width,
    height=46,
  }

  buf = vim.api.nvim_create_buf(false, true)
  win = vim.api.nvim_open_win(buf, false, config)

  -- kill buffer on close
  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
  vim.api.nvim_win_set_option(win, "winblend", 80)

end

function M.close_window()
  if win then
    vim.api.nvim_win_close(win, true)
  end
  win = nil
  buf = nil
end

function M.show()
  if not win then
    create_window()
  end

  vim.api.nvim_buf_set_lines(
    buf,  -- buffer handle of floating window
    0,    -- put to first line
    45,    -- last line index
    false,-- don't error on out of bounds
    parse_marks(vim.fn.execute("marks"))
  )
end

function M.ray_start()
  vim.cmd('augroup MarkRay')
  vim.cmd('autocmd!')
  vim.cmd("autocmd CursorMoved * :lua require'mark-ray'.show()")
  vim.cmd('augroup END')
end

function M.ray_stop()
  vim.cmd('autocmd! MarkRay')
  M.close_window()
end

function M.init()
  create_commands()
end

return M
