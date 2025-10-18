
local M = {}

function M.setup()
  -- Leader keys
  vim.g.mapleader      = " "   -- <Space> will be your global leader
  vim.g.maplocalleader = "\\"  -- <\> will be your local leader

  -- Indentation 
  vim.opt.tabstop      = 2          -- number of spaces a <Tab> counts for
  vim.opt.softtabstop  = 2          -- insert/delete 2 spaces when editing
  vim.opt.shiftwidth   = 2          -- size of an indent
  vim.opt.expandtab    = true       -- use spaces instead of real tabs
  vim.opt.smartindent  = true       -- smart auto‑indenting on new lines

  -- UI / display
  vim.opt.wrap          = false     -- don't wrap long lines
  vim.opt.number        = true      -- show absolute line numbers
  vim.opt.relativenumber = false    -- (you can set true if you prefer)
  vim.o.termguicolors  = true       -- true‑color support

end

return M
