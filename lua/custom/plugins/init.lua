-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'williamboman/mason.nvim',
    config = true,
  },
  {

    'williamboman/mason-lspconfig.nvim',
    config = function()
      require('mason-lspconfig').setup {
        ensure_installed = {
          'pyright',
          'rust_analyzer',
          'omnisharp',
          'tsserver',
          'lua ls',
        },
      }
    end,
  },
  {
    'neovim/nvim-lspconfig',
    config = function()
      local lspconfig = require 'lspconfig'

      local servers = {
        pyright = {},
        rust_analyzer = {},
        omnisharp = {},
        jdtls = {},
        tsserver = {},
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = { globals = { 'vim' } },
            },
          },
        },
      }

      for server, config in pairs(servers) do
        lspconfig[server].setup(config)
      end
    end,
  },
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        python = { 'black' },
        rust = { 'rustfmt' },
        csharp = { 'csharpier' },
        java = { 'google-java-format' },
        typescript = { 'prettier' },
        javascript = { 'prettier' },
        lua = { 'stylua' },
      },
    },
  },
  {
    'kdheepak/lazygit.nvim',
    cmd = 'LazyGit',
    keys = {
      { '<leader>gg', '<cmd>LazyGit<cr>', desc = 'Lazygit' },
    },
  },
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = function()
      require('toggleterm').setup {
        direction = 'float',
      }
      vim.keymap.set('n', '<leader>tt', '<cmd>ToggleTerm<cr>', { desc = 'Terminal' })
    end,
  },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    config = function()
      require('telescope').load_extension 'fzf'
    end,
  },
}
