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
noremap <C-p>r :Rg<cr>
noremap Q <ESC>

let g:iced_enable_default_key_mappings = v:true
