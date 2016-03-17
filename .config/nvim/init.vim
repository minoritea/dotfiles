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

call dein#end()

if dein#check_install()
  call dein#install()
endif
"
let g:deoplete#enable_at_startup = 1

nnoremap <C-n> :NERDTreeToggle<CR>

syntax enable
filetype plugin indent on
set background=dark
let g:solarized_termcolors=256
colorscheme solarized

let g:airline_theme = 'solarized'
let g:airline#extensions#tabline#enabled = 1
let g:airline_left_sep = ' '
let g:airline_right_sep = ' '
"
set number
