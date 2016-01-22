set nocompatible			  " be iMproved, required
filetype off				  " required

" Enable syntax highlighting
if has("syntax")
  syntax on
endif


" -------------------------- Plugins --------------------------

" set the runtime path to include Vundle and initialize
set rtp+=/home/lorian/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'

Plugin 'Syntastic'

Plugin 'majutsushi/tagbar'

Plugin 'Valloric/YouCompleteMe'

Plugin 'plasticboy/vim-markdown'

Plugin 'neovimhaskell/haskell-vim'

Plugin 'haya14busa/incsearch.vim'

Plugin 'bling/vim-airline'

Plugin 'altercation/vim-colors-solarized'

Plugin 'hynek/vim-python-pep8-indent'

Plugin 'nathanaelkane/vim-indent-guides'

Plugin 'airblade/vim-gitgutter'

Plugin 'rhlobo/vim-super-retab'

Plugin 'scrooloose/nerdtree'

Plugin 'PotatoesMaster/i3-vim-syntax'

Plugin 'scrooloose/nerdcommenter'

Plugin 'honza/vim-snippets'

Plugin 'SirVer/ultisnips'

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

" -------------------------- Keymaps --------------------------

" Toggle tagbar
nmap <silent> <C-v> :TagbarToggle<CR>

" Close scratch
nmap <silent> <C-O> :pc<CR>

" Toggle indent guides
nmap  <silent> <C-I> <Plug>IndentGuidesToggle

" <Ctrl+Enter> to run make
map <NL> :make<CR>

" <Ctrl-l> redraws the screen and removes any search highlighting.
"nnoremap <silent> <C-s> :nohl<CR>
nnoremap <C-s> :nohl<CR>

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
nnoremap <silent> <leader>c :call g:ToggleColorColumn()<CR>

nmap <silent> <C-T> :RetabIndent<CR>

nmap <silent> <C-G> :!grunt screeps<CR>


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

" imap <NL> <Plug>snipMateTrigger

" -------------------------- Colors --------------------------

set background=dark			" Terminal background is dark
colorscheme peachpuff		" Peachpuff color scheme
set t_Co=256				" Set color scheme to 256

" Highlight cursor line
set cursorline
hi CursorLine cterm=NONE ctermbg=7

" Visual selection color
hi Visual ctermbg=244

hi SyntasticError ctermfg=232 ctermbg=160

" Indent guide colors
let g:indent_guides_auto_colors = 0
hi IndentGuidesOdd	ctermbg=240
hi IndentGuidesEven ctermbg=245

" Search highlighting
hi Search term=reverse ctermfg=15 ctermbg=69

" For 80 chars per line limit
let g:column_limit=80
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

" Better split window opening
set splitbelow
set splitright


" -------------------------- Other settings --------------------------

set showcmd		" Show (partial) command in status line.
set ignorecase	" Do case insensitive matching
set autowrite	" Automatically save before commands like :next and :make
set mouse=a		" Enable mouse usage (all modes)

set backspace=2				" Make backspace work
set number					" Always show line numbers

set autoindent
set smartindent
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set smarttab
"set breakindent



set clipboard=unnamedplus	" Use the X clipboard


set so=10					" Set scroll limit

" Line wrapping
set wrap
set linebreak

set listchars=tab:▶-,eol:¬	" Chars show in list mode

set hlsearch 				" Highlight search
set incsearch				" Incremental serach

" Automically unhighlight search results
let g:incsearch#auto_nohlsearch = 1

let g:airline_theme = 'powerlineish'
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
set termencoding=utf-8

let g:ycm_global_ycm_extra_conf = "~/.vim/ycm_extra_conf.py"

let g:tagbar_autofocus=1		" Autofocus on the tagbar when it is opened.
let g:syntastic_javascript_checkers = ['jsxhint']
let g:syntastic_python_checkers = ['python', 'pyflakes'] ", 'pep8']
let g:syntastic_python_flake8_args='--ignore=E501'

let g:UltiSnipsUsePythonVersion = 2
let g:UltiSnipsExpandTrigger="<c-f>"
let g:UltiSnipsListSnippets="<c-a>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"




