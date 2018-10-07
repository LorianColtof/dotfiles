set nocompatible			  " be iMproved, required
filetype off				  " required

" Enable syntax highlighting
if has("syntax")
  syntax on
endif


" -------------------------- Plugins --------------------------

call plug#begin('~/.vim/plugged')

Plug 'w0rp/ale'

Plug 'majutsushi/tagbar'

Plug 'ncm2/ncm2'

Plug 'ncm2/ncm2-bufword'

Plug 'ncm2/ncm2-path'

Plug 'ncm2/ncm2-cssomni'

Plug 'ncm2/ncm2-tern'

Plug 'ncm2/ncm2-jedi'

Plug 'ncm2/ncm2-pyclang'

Plug 'ncm2/ncm2-vim'

Plug 'phpactor/ncm2-phpactor'

Plug 'ncm2/ncm2-ultisnips'

Plug 'ncm2/ncm2-html-subscope'

Plug 'ncm2/ncm2-markdown-subscope'

Plug 'roxma/nvim-yarp'

Plug 'plasticboy/vim-markdown'

Plug 'neovimhaskell/haskell-vim'

Plug 'haya14busa/incsearch.vim'

Plug 'bling/vim-airline'

Plug 'vim-airline/vim-airline-themes'

Plug 'hynek/vim-python-pep8-indent'

Plug 'airblade/vim-gitgutter'

Plug 'rhlobo/vim-super-retab'

Plug 'scrooloose/nerdtree'

Plug 'PotatoesMaster/i3-vim-syntax'
"
Plug 'MaicoTimmerman/ast.vim'

Plug 'tomtom/tcomment_vim'

Plug 'SirVer/ultisnips'

Plug 'honza/vim-snippets'

Plug 'chriskempson/base16-vim'

Plug 'ctrlpvim/ctrlp.vim'

Plug 'othree/html5.vim'

Plug 'pangloss/vim-javascript'

Plug 'Lokaltog/vim-easymotion'

Plug 'bkad/CamelCaseMotion'

Plug 'tpope/vim-fugitive'

Plug 'morhetz/gruvbox'

Plug 'hkupty/iron.nvim'
"
Plug 'Valloric/MatchTagAlways'

Plug 'tpope/vim-surround'

Plug 'jiangmiao/auto-pairs'

Plug 'digitaltoad/vim-pug'

" Plug 'thaerkh/vim-indentguides'
"
Plug 'dag/vim-fish'

Plug 'Glench/Vim-Jinja2-Syntax'

Plug 'chase/vim-ansible-yaml'

" Plug 'OmniSharp/omnisharp-vim'

Plug 'kchmck/vim-coffee-script'

Plug 'juliosueiras/cakebuild.vim'

call plug#end()

filetype plugin indent on

" -------------------------- Auto commands --------------------------
"
autocmd BufEnter * call ncm2#enable_for_buffer()

au BufRead,BufNewFile *.pl set filetype=prolog				" Prolog source files
au BufRead,BufNewFile *.pgf set filetype=tex				" LaTeX PGF figures
au BufRead,BufNewFile *.tex set filetype=tex				" Avoid plaintex
au BufRead,BufNewFile *.cls set filetype=tex
au BufRead,BufNewFile *.tex set filetype=tex
au BufRead,BufNewFile *.cu set filetype=cpp					" CUDA source files
au BufRead,BufNewFile gitconfig set filetype=gitconfig		" gitconfig file in dotfiles repo
au BufRead,BufNewFile *.{cvc,mac} set syntax=c
au BufRead,BufNewFile *.{tex,txt} setlocal spell spelllang=en_us

" Remove all trailing whitespace
autocmd BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif
"
" Don't conceal stuff
let g:indentLine_setConceal = 0

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
let g:maplocalleader = ' '

map <localleader>l :MerlinLocate<CR>


" Toggle tagbar
nmap <silent> <leader>v :TagbarToggle<CR>

" Close scratch
nmap <silent> <C-O> :pc<CR>

" <Ctrl+Enter> to run make
noremap <leader>m :make<CR>

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

nnoremap <Left> :tabn<CR>
nnoremap <Right> :tabp<CR>

noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

noremap <C-up> <C-w>k
noremap <C-down> <C-w>j
noremap <C-left> <C-w>h
noremap <C-right> <C-w>l

inoremap # x<BS>#

noremap <Up> <Nop>
noremap <Down> <Nop>

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

" ...but only if the count is undefined (otherwise, things like 4j
" break if wrapped LINES are present)
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
xnoremap <expr> j (v:count == 0 ? 'gj' : 'j')
xnoremap <expr> k (v:count == 0 ? 'gk' : 'k')

noremap q: :q<CR>
noremap Q <nop>

inoremap jkl <Esc>
inoremap jlk <Esc>

inoremap <C-f> <C-n><C-y>

" -------------------------- Colors --------------------------
function! SetBackgroundColor()
    if filereadable($HOME.'/.colors_light')
        set bg=light
    else
        set bg=dark
    endif
endfunction

set termguicolors
let g:gruvbox_contrast_dark='hard'
let g:gruvbox_contrast_light='hard'
let g:gruvbox_italic=1
colorscheme gruvbox
"
call SetBackgroundColor()

" Highlight cursor line
set cursorline

hi SyntasticError ctermfg=232 ctermbg=160

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

autocmd BufReadPost * call g:ToggleColorColumn()

execute 'hi ColorColumn ctermbg='.(s:column_limit_color)

"disable syntastic on a per buffer basis (some work files blow it up)
function! SyntasticDisableBuffer()
    let b:syntastic_mode = "passive"
    SyntasticReset
    echo 'Syntastic disabled for this buffer'
endfunction

command! SyntasticDisableBuffer call SyntasticDisableBuffer()

" let g:airline#extensions#tabline#show_buffers = 0
" let g:airline#extensions#tabline#show_splits = 1
" let g:airline#extensions#tabline#show_tabs = 1

" -------------------------- Other settings --------------------------

set completeopt=noinsert,menuone,noselect

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

set magic

" Automatically unhighlight search results
let g:incsearch#auto_nohlsearch = 1

let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#branch#enabled = 1

let g:airline_powerline_fonts = 1 " Enable powerline icons.

" let g:airline#extensions#tabline#show_splits = 0

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

let g:airline_symbols.whitespace = 'Ξ'

let g:airline#extensions#tabline#enabled = 1
set ttimeoutlen=50 				" Stop the delay in airline when leaving insertmode.
set laststatus=2				" always show the statusbar.
let g:tagbar_autofocus=1		" Autofocus on the tagbar when it is opened.
let g:ale_python_pylint_options = '--disable C0103'

let g:UltiSnipsExpandTrigger="<tab>"

" TODO: port to ale someday
let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++'
let g:syntastic_c_no_include_search = 1

let g:UltiSnipsSnippetDirectories=["UltiSnips", "UltiSnipsExtra"]

let g:python_host_prog = '/usr/bin/python'
let g:python3_host_prog = '/usr/bin/python3'

let g:vim_markdown_conceal = 0
let g:tex_conceal = ""
let g:vim_markdown_math = 1

" Fix cursor blink
set guicursor=n:blinkon1

let g:ale_linters = {'python': ['flake8', 'mypy'], 'javascript': ['eslint']}

let g:indentguides_toggleListMode = 0

set title

let g:OmniSharp_server_path = '/home/lorian/omnisharp/OmniSharp.exe'
let g:OmniSharp_server_use_mono = 1
