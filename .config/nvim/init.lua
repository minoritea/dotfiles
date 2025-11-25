vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.hidden = true
vim.o.number = true
vim.o.mouse = ""
vim.o.shell = '/usr/bin/zsh'
vim.g.clipboard = 'osc52'
vim.o.undodir = vim.fn.expand('~/.cache/nvim/undo')
vim.o.undofile = true
vim.opt.clipboard:append({"unnamedplus"})

require('config.lazy')
require('lazy').setup({
  spec = {
    -- LSP
    { 'neoclide/coc.nvim', branch = 'release', },

    -- Filer
    { 'stevearc/oil.nvim', priority = 1, config = function()
        require('oil').setup({ default_file_explorer = true, view_options = { show_hidden = true, }, })
        vim.api.nvim_create_user_command('OilP', function()
          require('oil').open(vim.fn.expand('%:p:h'))
        end, {})
      end,
    },
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

vim.api.nvim_create_user_command('TSInstallAll', function()
  local ts = require('nvim-treesitter')
  ts.install(ts_langs)
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
vim.keymap.set('', '<C-w>t', '<C-w>T')
vim.keymap.set('', '<C-p>b', function() fzf_lua.buffers() end)
vim.keymap.set('', '<C-p>f', function() fzf_lua.files() end)
vim.keymap.set('', '<C-p>r', function() fzf_lua.live_grep() end)
vim.keymap.set('', '<C-]>', '<Plug>(coc-definition)')
vim.keymap.set('', '<C-T>', '<C-O>')
vim.keymap.set('', '<C-K>', ":call CocAction('doHover')<CR>")
vim.keymap.set('n', 'gcr', '<Plug>(coc-references-used)')
vim.keymap.set('n', 'gci', '<Plug>(coc-implementation)')
vim.keymap.set('n', 'gct', '<Plug>(coc-type-definition)')
vim.keymap.set('n', 'gcp', '<Plug>(coc-diagnostic-prev)')
vim.keymap.set('n', 'gcn', '<Plug>(coc-diagnostic-next)')
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
vim.keymap.set('i', '<expr><C-w>;', 'coc#pum#close()')
