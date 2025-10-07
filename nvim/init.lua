local function setLeader()
  vim.g.mapleader = " "
  vim.g.maplocalleader = "\\"
end

local function setIndentation()
  vim.opt.tabstop = 2
  vim.opt.softtabstop = 2
  vim.opt.shiftwidth = 2
  vim.opt.expandtab = true
  vim.opt.smartindent = true
end

local function tweakDisplay()
  vim.opt.wrap = false
  vim.opt.number = true
  vim.opt.relativenumber = false
  vim.o.termguicolors = true
end

local function setPlugins()
  -- Bootstrap lazy.nvim
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
      vim.api.nvim_echo({
        { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
        { out, "WarningMsg" },
        { "\nPress any key to exit..." },
      }, true, {})
      vim.fn.getchar()
      os.exit(1)
    end
  end
  vim.opt.rtp:prepend(lazypath)

  -- Setup lazy.nvim
  require("lazy").setup({
    change_detection = { notify = false },
    spec = {
      -- import your plugins
      { import = "plugins" },
    },
    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    install = { colorscheme = { "habamax" } },
    -- automatically check for plugin updates
    checker = { enabled = false },
  })


  -- NUSHELL
  
  require("lazy").setup({
    -- NOTE: Use the official treesitter definition (nushell/tree-sitter-nu)
    -- Syntax highlighing, code navigation etc..
    -- The lua, vim and vimdoc one are optional but highly suggested for neovim.
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",

      dependencies = "nushell/tree-sitter-nu",
      config = function()
        -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
        ---@diagnostic disable-next-line: missing-fields
        require("nvim-treesitter.configs").setup({
          ensure_installed = {
            "nu",
            "lua",
            "vim",
            "vimdoc",
          },
          auto_install = true,
          highlight = { enable = true },
          indent = { enable = true },
        })
      end,
    },

    -- NOTE: LSP
    -- lsp-config greatly simplifies the setup and has builtin support for nushell.
    -- --
    -- mason: is a TUI tool to install DAP, LSP, Linters or Formatters.
    -- mason-lspconfig: glue between mason and lspconfig (written by mason's dev William Boman).
    -- mason-tool-installer: allow to use ensure_installed with either the mason name or lsp name.
    {
      "neovim/nvim-lspconfig",
      dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        { "j-hui/fidget.nvim", opts = {} },
      },
      config = function()
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        local servers = {
          lua_ls = {
            settings = {
              Lua = {
                runtime = { version = "LuaJIT" },
                workspace = {
                  checkThirdParty = false,
                  library = {
                    "${3rd}/luv/library",
                    unpack(vim.api.nvim_get_runtime_file("", true)),
                  },
                },
              },
            },
          },
        }

        local ensure_installed = vim.tbl_keys(servers or {})
        require("mason").setup()
        require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

        -- NOTE: this is where you can customize the lsp setup
        -- here we use the default options to see the available fields.
        vim.lsp.config.nushell.setup({
          cmd = { "nu", "--lsp" },
          filetypes = { "nu" },
          root_dir = require("lspconfig.util").find_git_ancestor,
          single_file_support = true,
        })

        require("mason-lspconfig").setup({
          handlers = {
            function(server_name)
              local server = servers[server_name] or {}
              require("lspconfig")[server_name].setup({
                cmd = server.cmd,
                settings = server.settings,
                filetypes = server.filetypes,
                capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {}),
              })
            end,
          },
        })
      end,
    },
  }, {
    -- check for updates
    checker = {
      enabled = true,
      notify = false,
    },
  })
end

setLeader()
setIndentation()
tweakDisplay()
setPlugins()
