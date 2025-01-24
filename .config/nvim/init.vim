if empty($XDG_DATA_HOME)
  let $XDG_DATA_HOME= $HOME."/.local/share"
endif

let g:polyglot_disabled = ['svelte']

call plug#begin($XDG_DATA_HOME.'/nvim/plugged')
  Plug 'neoclide/coc.nvim', {'branch': 'release', 'do': { -> coc#util#install() } }

  Plug 'scrooloose/nerdtree'

  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'

  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'

  Plug 'vim-scripts/DirDiff.vim'

  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'

  Plug 'APZelos/blamer.nvim'

  Plug 'sheerun/vim-polyglot'

  Plug 'evanleck/vim-svelte'

  Plug 'github/copilot.vim'
call plug#end()

let g:coc_global_extensions = [
      \ 'coc-prettier',
      \ 'coc-tsserver',
      \ 'coc-go',
      \ 'coc-svelte',
      \ 'coc-solargraph'
\]

"incremental ripgrep search by fzf
"https://github.com/junegunn/fzf.vim/blob/36de5db9f0af1fb2e788f890d7f28f1f8239bd4b/README.md#example-advanced-ripgrep-integration
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction
"

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

"incremental ripgrep search by fzf
"https://github.com/junegunn/fzf.vim/blob/36de5db9f0af1fb2e788f890d7f28f1f8239bd4b/README.md#example-advanced-ripgrep-integration
function! RipgrepFzfOptions(query, fullscreen)
  let command_fmt = 'rg-wrapper --column --line-number --no-heading --color=always --smart-case -H %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction
"

command! -nargs=* -bang RGX call RipgrepFzfOptions(<q-args>, <bang>0)

set hidden

syntax enable
filetype plugin indent on
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set smarttab
set background=dark

let g:airline_theme = 'solarized'
let g:airline#extensions#tabline#enabled = 1
let g:airline_left_sep = ' '
let g:airline_right_sep = ' '

let NERDTreeShowHidden=1
set number
set rtp+=/usr/local/opt/fzf

let g:ale_fixers = {'go': ['gofmt']}
let g:ale_fix_on_save = 1

set mouse=

noremap ! <Nop>
noremap q <Nop>
noremap q: <Nop>
" noremap <Right> gt<CR>
" noremap <Left> gT<CR>
noremap <Right> :bn<CR>
noremap <Left> :bp<CR>
noremap <C-w>t <C-w>T
nnoremap <C-n> :NERDTreeToggle<CR>
noremap <C-s> :let @t=@+<CR>:let @+=@"<CR>:let @"=@t<CR>
noremap <C-j> :ALENext<cr>
noremap <C-p>b :Buffers<cr>
noremap <C-p>f :Files<cr>
noremap <C-p>R :RG<cr>
noremap <C-p>r :RGX<cr>
noremap Q <ESC>
noremap <C-]> :call CocAction('jumpDefinition')<CR>
noremap <C-T> <C-O>

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')
" Add `:CocFormat` command to format current buffer
command! -nargs=0 CocFormat :call CocActionAsync('format')

" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
inoremap <silent><expr> <C-n>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ coc#refresh()
inoremap <expr><c-p> coc#pum#visible() ? coc#pum#prev(1) : "\<c-p>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" blamer is enabled
let g:blamer_enabled = 1

let g:svelte_preprocessor_tags = [
  \ { 'name': 'ts', 'tag': 'script', 'as': 'typescript' }
  \ ]
let g:svelte_preprocessors = ['ts']

let g:ale_linters = {'go':['gofmt']}
let g:ale_fixers = {'go':['gofmt', 'goimports']}

if has('persistent_undo')
  set undodir=~/.cache/nvim/undo
  set undofile
endif
