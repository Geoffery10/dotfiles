local function configure() 
	require("oil").setup({
    view_options = {
      -- Show files and directories that start with "."
      show_hidden = true,
    }
  })
	vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
end

return {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  ---opts = {},
  config = configure, 
  -- Optional dependencies
  dependencies = { { "nvim-mini/mini.icons", opts = {} } },
  -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
  -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
  lazy = false,
}
