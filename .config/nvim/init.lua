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

local function carbon_float_settings()
  return {
    relative = 'editor',
    style = 'minimal',
    border = 'rounded',
    width = math.floor(vim.o.columns * 0.8),
    height = math.floor(vim.o.lines * 0.8),
    col = math.floor(vim.o.columns * 0.1),
    row = math.floor(vim.o.lines * 0.1),
  }
end

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
    { 'SidOfc/carbon.nvim', opts = { auto_open = false, auto_reveal = true, exclude = { '%.git$' }, float_settings = carbon_float_settings }, },

    -- Syntax Highlighting
    { 'nvim-treesitter/nvim-treesitter', lazy = false, branch = 'main', build = ':TSUpdate', },

    -- Code suggestions
    { 'github/copilot.vim' },

    -- Git
    { 'sindrets/diffview.nvim', opts = {}, },

    -- diff
    { 'andrewradev/linediff.vim' },
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
  root_markers = { 'go.mod' },
}
vim.lsp.config['ts'] = {
  -- cmd = { vim.fn.expand('~/.bun/bin/tsgo'), '--lsp', '--stdio' },
  cmd = { vim.fn.expand('~/.bun/bin/vtsls'), '--stdio' },
  filetypes = {
    'typescript',
    'typescriptreact',
    'typescript.tsx',
    'javascript',
    'javascriptreact',
    'javascript.jsx',
  },
  root_markers = { 'package.json', 'tsconfig.json' },
}
vim.lsp.enable({ 'go', 'ts' })

local custom_cmd_group = vim.api.nvim_create_augroup('CustomCommands', { clear = true })

vim.api.nvim_create_autocmd('FileType', {
  pattern = "*",
  group = custom_cmd_group,
  callback = function() pcall(vim.treesitter.start) end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'go' },
  group = custom_cmd_group,
  callback = function() vim.bo.expandtab = false end,
})

vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  group = custom_cmd_group,
  callback = vim.lsp.buf.format,
})

local fzf_lua = require('fzf-lua')

-- keymaps
vim.keymap.set('', '!', '<Nop>')
vim.keymap.set('', 'q', '<Nop>')
vim.keymap.set('', 'q:', '<Nop>')
vim.keymap.set('', '<Right>', ':bn<CR>')
vim.keymap.set('', '<Left>', ':bp<CR>')
vim.keymap.set('', '<C-p>b', fzf_lua.buffers)
vim.keymap.set('', '<C-p>f', fzf_lua.files)
vim.keymap.set('', '<C-p>r', fzf_lua.live_grep)
vim.keymap.set('', '<C-n>', require('carbon').explore_float)
-- C-t -> vim.lsp.tagfunc()
-- grn -> vim.lsp.buf.rename()
vim.keymap.set('v', 'gra', fzf_lua.lsp_code_actions)
vim.keymap.set('n', 'grr', fzf_lua.lsp_references)
vim.keymap.set('n', 'gri', fzf_lua.lsp_implementations)
vim.keymap.set('n', 'grt', fzf_lua.lsp_typedefs)
vim.keymap.set('n', 'g0', fzf_lua.lsp_document_symbols)
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
