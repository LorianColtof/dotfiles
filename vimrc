set nocompatible			  " be iMproved, required
filetype off				  " required

" Enable syntax highlighting
if has("syntax")
  syntax on
endif


" -------------------------- Plugins --------------------------

"set rtp^="/home/lorian/.opam/system/share/ocp-indent/vim"
"let g:opamshare = substitute(system('opam config var share'),'\n$','','''')
let g:opamshare = '/home/lorian/.opam/4.02.1/share'
execute "set rtp+=" . g:opamshare . "/merlin/vim"
execute "set rtp+=" . g:opamshare . "/ocp-indent/vim"

" set the runtime path to include Vundle and initialize
set rtp+=/home/lorian/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'

Plugin 'scrooloose/syntastic'

Plugin 'majutsushi/tagbar'

"Plugin 'Valloric/YouCompleteMe'

Plugin 'Shougo/deoplete.nvim'

Plugin 'zchee/deoplete-jedi'

"Plugin 'm2mdas/phpcomplete-extended'

Plugin 'plasticboy/vim-markdown'

Plugin 'neovimhaskell/haskell-vim'

Plugin 'haya14busa/incsearch.vim'

Plugin 'bling/vim-airline'

Plugin 'vim-airline/vim-airline-themes'

Plugin 'hynek/vim-python-pep8-indent'

Plugin 'nathanaelkane/vim-indent-guides'

Plugin 'airblade/vim-gitgutter'

Plugin 'rhlobo/vim-super-retab'

Plugin 'scrooloose/nerdtree'

Plugin 'PotatoesMaster/i3-vim-syntax'

Plugin 'scrooloose/nerdcommenter'

Plugin 'SirVer/ultisnips'

Plugin 'honza/vim-snippets'

Plugin 'chriskempson/base16-vim'

Plugin 'ctrlpvim/ctrlp.vim'

Plugin 'othree/html5.vim'

Plugin 'pangloss/vim-javascript'

Plugin 'Lokaltog/vim-easymotion'

Plugin 'bkad/CamelCaseMotion'

Plugin 'tpope/vim-fugitive'

Plugin 'morhetz/gruvbox'

Plugin 'hkupty/iron.nvim'

call vundle#end()

filetype plugin indent on

" Brief help
" :PluginList		- lists configured plugins
" :PluginInstall	- installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean		- confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ

" -------------------------- Auto commands --------------------------

au BufRead,BufNewFile *.pl set filetype=prolog				" Prolog source files
au BufRead,BufNewFile *.pgf set filetype=tex				" LaTeX PGF figures
au BufRead,BufNewFile *.cls set filetype=tex
au BufRead,BufNewFile *.cu set filetype=cpp					" CUDA source files
au BufRead,BufNewFile *.hs set expandtab					" Haskell doesn't like tabs as indentation
au BufRead,BufNewFile gitconfig set filetype=gitconfig		" gitconfig file in dotfiles repo

" Remove all trailing whitespace
autocmd BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif

" Jump to the last position when reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

if exists("+undofile")
  " undofile - This allows you to use undos after exiting and restarting
  " This, like swap and backups, uses .vim-undo first, then ~/.vim/undo
  " :help undo-persistence
  " This is only present in 7.3+
  if isdirectory($HOME . '/.vim/undo') == 0
    :silent !mkdir -p ~/.vim/undo > /dev/null 2>&1
  endif
  set undodir=./.vim-undo//
  set undodir+=~/.vim/undo//
  set undofile
endif

" Don't clear clipboard on close
autocmd VimLeave * call system("xclip -selection c", getreg('+'))
" -------------------------- Keymaps --------------------------

let g:mapleader = ','
let g:maplocalleader = ',,'

map <localleader>l :MerlinLocate<CR>


" Toggle tagbar
nmap <silent> <leader>v :TagbarToggle<CR>

" Close scratch
nmap <silent> <C-O> :pc<CR>

" Toggle indent guides
nmap  <silent> <C-I> <Plug>IndentGuidesToggle

" <Ctrl+Enter> to run make
noremap <NL> :make<CR>

" <Ctrl-l> redraws the screen and removes any search highlighting.
"nnoremap <silent> <C-s> :nohl<CR>
"nnoremap <C-s> :nohl<CR>

" Make < > shifts keep selection
vnoremap < <gv
vnoremap > >gv

" Show tab and newline characters
nmap <silent> <leader>l :set list!<CR>

" Searching
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)
map #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)

" Toggle column limit
nnoremap <silent> <leader>x :call g:ToggleColorColumn()<CR>

nmap <silent> <C-T> :RetabIndent<CR>

noremap <C-G> :w<CR>:!pdflatex -shell-escape %<CR><CR>


noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

noremap <C-up> <C-w>k
noremap <C-down> <C-w>j
noremap <C-left> <C-w>h
noremap <C-right> <C-w>l

"Easier comment toggle
map <C-_> <plug>NERDCommenterToggle
vmap <C-_> <plug>NERDCommenterToggle<CR>gv

inoremap # x<BS>#

noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

" Jump to merge conflicts
nnoremap <silent> ]c /\v^(\<\|\=\|\>){7}([^=].+)?$<CR>
nnoremap <silent> [c ?\v^(\<\|\=\|\>){7}([^=].+)\?$<CR>

" Jump to hunks
nmap ]h <Plug>GitGutterNextHunk
nmap [h <Plug>GitGutterPrevHunk

"Move blocks of text up and down with the arrow keys
vnoremap <silent> <down> :m '>+1<CR>gv=gv
vnoremap <silent> <up> :m '<-2<CR>gv=gv


xnoremap i$ :<C-u>normal! T$vt$<CR>
onoremap i$ :normal vi$<CR>

" -------------------------- Colors --------------------------

set termguicolors
set background=dark			" Terminal background is dark
"colorscheme base16-default-dark
let g:gruvbox_contrast_dark='hard'
let g:gruvbox_italic=1
colorscheme gruvbox

" Highlight cursor line
set cursorline

hi SyntasticError ctermfg=232 ctermbg=160

" Indent guide colors
let g:indent_guides_auto_colors = 0
hi IndentGuidesOdd	ctermbg=240
hi IndentGuidesEven ctermbg=245

" Search highlighting
hi Search term=reverse ctermfg=15 ctermbg=69

" For 80 chars per line limit
let g:column_limit=79
let s:column_limit_color=202
function! g:ToggleColorColumn()
    if &colorcolumn != ''
        set colorcolumn&
        match OverLength //
    else
        execute 'set colorcolumn='.(g:column_limit+1)
        execute 'highlight OverLength ctermfg=15 ctermbg='.(s:column_limit_color)
        execute 'match OverLength /\%'.(g:column_limit+1).'v.\+/'
    endif
endfunction

execute 'hi ColorColumn ctermbg='.(s:column_limit_color)

" -------------------------- Other settings --------------------------

" Better split window opening
set splitbelow
set splitright

set showcmd		" Show (partial) command in status line.
set ignorecase	" Do case insensitive matching
set autowrite	" Automatically save before commands like :next and :make
set mouse=a		" Enable mouse usage (all modes)

set backspace=2				" Make backspace work
set number					" Always show line numbers
set relativenumber

set autoindent
set smartindent
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set smarttab
"set breakindent
"
set wildmenu
set clipboard=unnamedplus	" Use the X clipboard
set so=10					" Set scroll limit

" Line wrapping
set wrap
set linebreak

set listchars=tab:▶-,eol:¬	" Chars show in list mode

set hlsearch 				" Highlight search
set incsearch				" Incremental serach

set autoread

" Automically unhighlight search results
let g:incsearch#auto_nohlsearch = 1

"let g:airline_theme = 'powerlineish'
let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#branch#enabled = 1

let g:airline_powerline_fonts = 1 " Enable powerline icons.

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

let g:airline_symbols.whitespace = 'Ξ'

let g:airline#extensions#tabline#enabled = 1
set ttimeoutlen=50 				" Stop the delay in airline when leaving insertmode.
set laststatus=2				" always show the statusbar.
let g:tagbar_autofocus=1		" Autofocus on the tagbar when it is opened.
let g:syntastic_javascript_checkers = ['jsxhint']
let g:syntastic_python_checkers = ['python', 'flake8', 'pep8']
let g:syntastic_python_pep8_args='--ignore=E114,E265'

let g:UltiSnipsExpandTrigger="<tab>"
"let g:UltiSnipsListSnippets="<c-a>"
"let g:UltiSnipsJumpForwardTrigger="<c-b>"
"let g:UltiSnipsJumpBackwardTrigger="<c-z>"
let g:ycm_path_to_python_interpreter = '/usr/bin/python'
let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++'
let g:ycm_confirm_extra_conf = 0
let g:syntastic_ocaml_checkers = ['merlin']


let g:deoplete#enable_at_startup = 1

let g:UltiSnipsSnippetDirectories=["UltiSnips", "UltiSnipsExtra"]

let g:python_host_prog = '/usr/bin/python'
let g:python3_host_prog = '/usr/bin/python3'

