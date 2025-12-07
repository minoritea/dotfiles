vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.hidden = true
vim.o.number = true
vim.o.mouse = ""
vim.o.shell = '/usr/bin/zsh'
vim.g.clipboard = 'osc52'
vim.o.undofile = true
vim.opt.clipboard:append({"unnamedplus"})

require('config.lazy')
require('lazy').setup({
  dev = {
    path = '~/p/neovim',
  },
  spec = {
    -- Filer
    { 'stevearc/oil.nvim', priority = 1, opts = {
      default_file_explorer = true,
      view_options = { show_hidden = true, },
    } },
    { 'ibhagwan/fzf-lua', opts = {}, },

    -- Syntax Highlighting
    { 'nvim-treesitter/nvim-treesitter', lazy = false, branch = 'main', build = ':TSUpdate', },

    -- Code suggestions
    { 'github/copilot.vim' },

    -- Git
    { 'sindrets/diffview.nvim', opts = {}, },
  },
})

local ts_langs = {
  'vim',
  'lua',
  'javascript',
  'typescript',
  'jsx',
  'tsx',
  'go',
  'html',
  'css',
  'json',
  'yaml',
  'markdown',
  'graphql',
  'bash',
  'sql',
}

-- LSP
vim.lsp.config['go'] = {
  cmd = { 'gopls', 'serve' },
  filetypes = { 'go', 'gomod' },
  root_markers = { 'go.mod', '.git' },
}
vim.lsp.config['ts'] = {
  cmd = { vim.fn.expand('~/.bun/bin/tsgo'), '--lsp', '--stdio' },
  filetypes = {
    'typescript',
    'typescriptreact',
    'typescript.tsx',
    'javascript',
    'javascriptreact',
    'javascript.jsx',
  },
  root_markers = { 'package.json', 'tsconfig.json', '.git' },
}
vim.lsp.enable({ 'go', 'ts' })

vim.api.nvim_create_user_command('TSInstallAll', function()
  require('nvim-treesitter').install(ts_langs)
end, {})

vim.api.nvim_create_user_command('TSUpdateAll', function()
  require('nvim-treesitter').update(ts_langs)
end, {})

local fileTypeGroup = vim.api.nvim_create_augroup('FileTypeCmds', { clear = true })

vim.api.nvim_create_autocmd('FileType', {
  pattern = ts_langs,
  group = fileTypeGroup,
  callback = function() vim.treesitter.start() end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'go' },
  group = fileTypeGroup,
  callback = function() vim.bo.expandtab = false end,
})

local fzf_lua = require('fzf-lua')

-- keymaps
vim.keymap.set('', '!', '<Nop>')
vim.keymap.set('', 'q', '<Nop>')
vim.keymap.set('', 'q:', '<Nop>')
vim.keymap.set('', '<Right>', ':bn<CR>')
vim.keymap.set('', '<Left>', ':bp<CR>')
vim.keymap.set('', '<C-p>b', function() fzf_lua.buffers() end)
vim.keymap.set('', '<C-p>f', function() fzf_lua.files() end)
vim.keymap.set('', '<C-p>r', function() fzf_lua.live_grep() end)
-- C-t -> vim.lsp.tagfunc()
-- grn -> vim.lsp.buf.rename()
-- gra -> vim.lsp.buf.code_action()
-- grr -> vim.lsp.buf.references()
-- gri -> vim.lsp.buf.implementation()
-- grt -> vim.lsp.buf.type_definition()
-- g0  -> vim.lsp.buf.document_symbol()
-- C-s -> vim.lsp.buf.signature_help()
vim.keymap.set('i', '<C-j>j', '<Plug>(copilot-dismiss)')
vim.keymap.set('i', '<C-j><C-j>', '<Plug>(copilot-dismiss)')
vim.keymap.set('i', '<C-j><C-n>', '<Plug>(copilot-next)')
vim.keymap.set('i', '<C-j>p', '<Plug>(copilot-previous)')
vim.keymap.set('i', '<C-j><C-p>', '<Plug>(copilot-previous)')
vim.keymap.set('i', '<C-j>w', '<Plug>(copilot-accept-word)')
vim.keymap.set('i', '<C-j><C-w>', '<Plug>(copilot-accept-word)')
vim.keymap.set('i', '<C-j>$', '<Plug>(copilot-accept-line)')
vim.keymap.set('i', '<C-j><C-$>', '<Plug>(copilot-accept-line)')
vim.keymap.set('i', '<C-j>s', '<Plug>(copilot-suggest)')
vim.keymap.set('i', '<C-j><C-s>', '<Plug>(copilot-suggest)')
