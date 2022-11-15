if empty($XDG_DATA_HOME)
  let $XDG_DATA_HOME= $HOME."/.local/share"
endif
call plug#begin($XDG_DATA_HOME.'/nvim/plugged')
  Plug 'neoclide/coc.nvim', {'branch': 'release'}

  Plug 'scrooloose/nerdtree'

  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'

  Plug 'w0rp/ale'

  Plug 'vim-scripts/DirDiff.vim'

  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'

  Plug 'sheerun/vim-polyglot'
  Plug 'jremmen/vim-ripgrep'

  Plug 'guns/vim-sexp',    {'for': 'clojure'}
  Plug 'liquidz/vim-iced', {'for': 'clojure'}
call plug#end()

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
noremap <Left> :bp<CR>
noremap <Right> :bn<CR>
nnoremap <C-n> :NERDTreeToggle<CR>
noremap <C-s> :let @t=@*<CR>:let @*=@"<CR>:let @"=@t<CR>
noremap <C-j> :ALENext<cr>
noremap <C-p>b :Buffers<cr>
noremap <C-p>f :Files<cr>
noremap <C-p>r :RG<cr>
noremap Q <ESC>

let g:iced_enable_default_key_mappings = v:true
