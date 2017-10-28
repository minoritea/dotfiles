if &compatible
  set nocompatible
endif

let s:cache = expand("$HOME/.cache/dein")
let s:dein_repo_dir = s:cache . "/repos/github.com/Shougo/dein.vim"

if !isdirectory(s:dein_repo_dir)
  execute "!git clone https://github.com/Shougo/dein.vim " . s:dein_repo_dir
endif

execute 'set runtimepath^=' . s:dein_repo_dir

call dein#begin(s:cache)

  call dein#add('Shougo/deoplete.nvim')
  call dein#add('scrooloose/nerdtree')
  call dein#add('altercation/vim-colors-solarized')
  call dein#add('vim-airline/vim-airline')
  call dein#add('vim-airline/vim-airline-themes')
  call dein#add('rking/ag.vim')
  call dein#add('fatih/vim-go')
  call dein#add('fishbullet/deoplete-ruby')
  call dein#add('cespare/vim-toml')

call dein#end()

if dein#check_install()
  call dein#install()
endif
"
call deoplete#enable()

nnoremap <C-n> :NERDTreeToggle<CR>

syntax enable
set expandtab
set tabstop=2
set shiftwidth=2
filetype plugin indent on
set background=dark
let g:solarized_termcolors=256
colorscheme solarized

let g:airline_theme = 'solarized'
let g:airline#extensions#tabline#enabled = 1
let g:airline_left_sep = ' '
let g:airline_right_sep = ' '

let NERDTreeShowHidden=1

set number

set rtp+=/usr/local/opt/fzf

"swap contents between clipboard and the anonymous(default) register
noremap <C-s> :let @t=@*<CR>:let @*=@"<CR>:let @"=@t<CR>

noremap <Left> :bp<CR>
noremap <Right> :bn<CR>
noremap <F12> g]
