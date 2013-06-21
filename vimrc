""""""""
" General
""""""""
set nocompatible
set history=400
filetype plugin on
filetype indent on
set nobackup
set noswapfile

execute pathogen#infect()

" Omni-completion
set ofu=syntaxcomplete#Complete
set tags+=~/.vim/tags/cpp
"set tags+=~/.vim/tags/llvm
"set tags+=~/.vim/tags/glib
"set tags+=~/.vim/tags/llvm
let OmniCpp_NamespaceSearch = 1
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
let OmniCpp_MayCompleteDot = 1 " autocomplete after .
let OmniCpp_MayCompleteArrow = 1 " autocomplete after ->
let OmniCpp_MayCompleteScope = 1 " autocomplete after ::
" automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
set completeopt=menuone,menu,longest,preview

if has("gui_running")
	set mouse=a
else
	" In console, we can't share vim's clipboard with X11 one.
	" This enables middle click.
	set mouse=v
endif
set fileformats=unix,dos,mac
let mapleader = ","

" Sweet zsh-like autocompletion menu
set wildmenu
set wildmode=list:full

"""""
" User interface
"""""

"Colors
set ruler
syntax enable
nmap <leader>$ :syntax sync fromstart<cr>
set t_Co=256
"colorscheme kolor
colorscheme molokai
if has("gui_running")
	set cursorline
	"set cursorcolumn
	hi cursorline guibg=#fffdc2
	hi cursorcolumn guibg=#fffdc2

	colorscheme desert

	colorscheme molokai
	if has("gui_macvim")
		set guifont=Envy\ Code\ R:h12
	elseif has("gui_gtk2")
		set guifont=Envy\ Code\ R\ 08 " TODO : Implement this for Win32
	endif

	"Set window size
	set lines=35
	set columns=100
endif

if has("gui_macvim")
	set transp=3
endif

set guioptions-=T " Remove the toolbar

"Always show the status line
set laststatus=2

"Set lines to the cursors when moving vertical
set scrolloff=5

"Show line ruler
set number
set backspace=indent,eol,start

"Searching tweaking
set incsearch
set nohlsearch
set smartcase
set ignorecase
set infercase

"No sound
set noerrorbells

"Show matching brackets
set showmatch
set mat=2

"Standard status line
set ruler

"Share the clipboard with the current window manager
set clipboard+=unnamed

"Other GUI specific tasks
if has("gui_running")
	set mousehide
endif

"""""""""""""
" Moving around
"""""""""""""

map <C-j> <C-W>j
map <A-S-Down> <C-W>j

map <C-k> <C-W>k
map <A-S-Up> <C-W>k

map <C-h> <C-W>h
map <A-S-Left> <C-W>h

map <C-l> <C-W>l
map <A-S-Right> <C-W>l

map <A-j> gT
map <A-Left> gT

map <A-k> gt
map <A-Right> gt

imap <C-Space> <C-x><C-o>

"""""""""""
" Text options
"""""""""""

set smarttab
set autoindent
set smartindent
set cindent
set wrap
set cc=80

set shiftwidth=4
set tabstop=4
set expandtab

" CamelCase plugin (move according to CamelCase, underscores, etc.)
map w <Plug>CamelCaseMotion_w
map b <Plug>CamelCaseMotion_b
map e <Plug>CamelCaseMotion_e
sunmap w
sunmap b
sunmap e

" So that you can deactivate autoindent when you paste
set pastetoggle=<F2>


if has("gui_macvim")
	autocmd Syntax,FileType ocaml nmap <leader>m :w !LANG="" /sw/bin/camllight<cr>
else
	autocmd Syntax,FileType ocaml nmap <leader>m :w !camllight<cr>
endif

"""""""""""
" MiniBufExpl
""""""""""
" Use Ctrl + Tab to navigate between buffers
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplForceSyntaxEnable = 0

"""""""""""
" NERDTree
"""""""""""
" Close vim if the only opened buffer is NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
" Use Ctrl + N to toggle NERDTree
map <C-n> :NERDTreeToggle<CR>

" Remove automatic line breaks
set textwidth=0
set wrapmargin=0
set formatoptions=roql
set nolinebreak

"""""""""""
" Misc
"""""""""""

" Printing options
set pdev=pdf
set printoptions=paper:A4,syntax:y,wrap:y

" Spelling
set spelllang=fr
"set spell

" Add Calc function which calls Python (requires Python support)
if has("python")
	command! -nargs=+ Calc :py print <args>
	py from math import *
endif

" Persistant undo
set undofile
set undodir=~/.vim/tmp//,/var/tmp/**/,/tmp//,.

"""""""""""
" LaTeX
"""""""""""
if has("gui_macvim")
	let g:Tex_ViewRule_pdf = 'Preview'
endif

set shellslash
set grepprg=grep\ -nH\ $*
let g:tex_flavor='latex'
set background=dark
