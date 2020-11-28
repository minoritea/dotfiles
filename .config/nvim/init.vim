if empty($XDG_DATA_HOME)
  let $XDG_DATA_HOME= $HOME."/.local/share"
endif
call plug#begin($XDG_DATA_HOME.'/nvim/plugged')
  " Plug 'autozimu/LanguageClient-neovim', {
  "     \ 'branch': 'next',
  "     \ 'do': 'bash install.sh',
  "     \ }

  " (Optional) Multi-entry selection UI.
  " Plug 'junegunn/fzf'
  " Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'neoclide/coc.nvim', {'branch': 'release'}

  Plug 'scrooloose/nerdtree'

  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'

  Plug 'w0rp/ale'

  Plug 'vim-scripts/DirDiff.vim'
call plug#end()

set hidden

"let g:LanguageClient_serverCommands = {'go': [$GOPATH.'/bin/go-langserver','-format-tool','gofmt','-gocodecompletion']}
"let g:LanguageClient_serverCommands = {'go': ['gopls-once', '-logfile', '/tmp/gopls.log']}
"let g:LanguageClient_serverCommands = {'go': ['gopls-unifier']}
"let g:deoplete#enable_at_startup = 1
"let g:LanguageClient_diagnosticsEnable = 0

syntax enable
set expandtab
set tabstop=2
set shiftwidth=2
filetype plugin indent on
set background=dark

let g:airline_theme = 'solarized'
let g:airline#extensions#tabline#enabled = 1
let g:airline_left_sep = ' '
let g:airline_right_sep = ' '

let NERDTreeShowHidden=1
set number
set rtp+=/usr/local/opt/fzf

noremap <C-s> :let @t=@*<CR>:let @*=@"<CR>:let @"=@t<CR>
noremap <Left> :bp<CR>
noremap <Right> :bn<CR>
nnoremap <C-n> :NERDTreeToggle<CR>

let g:ale_fixers = {'go': ['gofmt']}
let g:ale_fix_on_save = 1

noremap <C-a> :ALENext<cr>
