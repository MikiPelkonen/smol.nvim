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
          'ts_ls',
          'lua_ls',
        },
      }
    end,
  },
  {
    'neovim/nvim-lspconfig',
    config = function()
      local lspconfig = require 'lspconfig'
      -- Needed for proper Unity references
      local pid = vim.fn.getpid()
      local omnisharp_bin = vim.fn.stdpath 'data' .. '/mason/bin/OmniSharp'

      local servers = {
        pyright = {},
        rust_analyzer = {},
        omnisharp = {
          capabilities = {
            workspace = { workspaceFolders = false },
          },
          cmd = { omnisharp_bin, '-z', '--hostPID', tostring(pid), 'DotNet:enablePackageRestore=false', '--encoding', 'utf-8', '--languageserver' },
          enable_editorconfig_support = true,
          enable_roslyn_analyzers = true,
          organize_imports_on_format = true,
          enable_import_completion = true,
          sdk_include_prereleases = true,
          analyze_open_documents_only = false,
          handlers = {
            ['textDocument/definition'] = require('omnisharp_extended').definition_handler,
            ['textDocument/references'] = require('omnisharp_extended').references_handler,
            ['textDocument/implementation'] = require('omnisharp_extended').implementation_handler,
          },
        },
        jdtls = {},
        ts_ls = {},
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
        cs = { 'csharpier' },
        typescript = { 'prettier' },
        javascript = { 'prettier' },
        lua = { 'stylua' },
      },
      default_format_opts = {
        lst_format = 'fallback',
      },
      format_on_save = {
        lstp_format = 'fallback',
        lsp_fallback = true,
        timeout_ms = 2000,
      },
      format_after_save = { lsp_format = 'fallback' },
    },
  },
  {
    'kdheepak/lazygit.nvim',
    cmd = 'LazyGit',
    keys = {
      { '<leader>gg', '<cmd>LazyGit<cr>', desc = 'Lazygit' },
    },
  },
  'Hoffs/omnisharp-extended-lsp.nvim',
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
