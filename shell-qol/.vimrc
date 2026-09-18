" TODO: add in plugins
" [[ ESSENTIAL ]] {{
filetype plugin indent on
syntax enable
set guicursor+=a:blinkon0              " Disable blinking
set clipboard=unnamedplus              " sync os clipboard with vim
set virtualedit=block                  " visual block mode cool behavior
set visualbell                         " never ever make my terminal beep
set mouse=a                            " enable mouse mode
set noshowmode                         " already in the status line
set backspace=indent,eol,start         " allow backspace on
set pumheight=10                       " pop up menu height
set conceallevel=0                     " so that `` is visible in markdown files
set encoding=UTF-8                     " the encoding written to a file
set autoindent                         " copy indent from current line when starting new one
set formatoptions-=cro                 " don't insert comment leader automatically
set incsearch                          " highlight, jump to matches in real time
" }}

" [[ LINE NUMBERS ]] {{
set number
set relativenumber
" }}

" [[ TAB STUFF ]] {{
set expandtab           " tabs -> spaces
set numberwidth=1       " set number column width to 2 {default 4}
set shiftwidth=4        " the number of spaces inserted for each indentation
set tabstop=4           " insert n spaces for a tab
set softtabstop=4       " Number of spaces that a tab counts for while performing editing
" }}

" [[ LINE WRAP ]] {{
set wrap                " false makes long long lines go offscreen
set linebreak           " companion to wrap, don't split words
if exists('+breakindent')
  set breakindent       " keep lines visually indented (Vim 8.0+)
endif
" }}

" [[ MORE USEFUL DIFFS ]] {{
if has('diff')
  set diffopt+=iwhite
  if has('patch-8.1.0360')
    set diffopt+=algorithm:histogram
    set diffopt+=indent-heuristic
  endif
endif
" }}

" [[ SEARCHING ]] {{
set hlsearch            " highlight on search
set ignorecase          " case-insensitive searching
set smartcase           " unless capital letters in search term
set iskeyword+=-        " hyphenated words recognized by searches

" [[ PROJ SPECIFIC ]]
set path-=/usr/include  " removes /usr/include from Vim's path option
set path+=$PWD/**       " recursively adds the CWD to Vim's path option.
" }}

" [[ FILES, BUFFERS ]] {{
set noswapfile
set nowritebackup       " if file is being edited by another program
set nosplitright        " how new splits open up
set splitbelow
set undofile            " save undo history
set undodir=~/.vim/undo
if !isdirectory(&undodir)
  call mkdir(&undodir, 'p')
endif
set history=5000        " save command line window history
" }}

" [[ VISUAL STUFF ]] {{
if has('termguicolors')
  set termguicolors     " true color support
endif

set signcolumn=yes      " keep signcolumn on by default
set cursorline          " show which line your cursor is on
set scrolloff=999       " keep cursor centered
set list                " show whitespace characters
set listchars=tab:»\ ,trail:·,nbsp:␣

" [[ COLORSCHEME ]]
" https://github.com/habamax/vim-gruvbit
" Install gruvbit: git clone https://github.com/habamax/vim-gruvbit ~/.vim/pack/plugins/start/vim-gruvbit
" Or using vim-plug: Plug 'habamax/vim-gruvbit'
" colorscheme gruvbit
" colorscheme desert
" }}

" [[ COMPLETIONS ]] {{
if v:version >= 900 || has('nvim')
  set completeopt=fuzzy,menuone,preview
else
  set completeopt=menuone,preview
endif
set updatetime=100      " faster completion
" }}

" [[ QOL ]] {{
set smartindent
set timeout
set ttimeout
set ttimeoutlen=-1
set timeoutlen=250
" }}

" =============================================================================
" KEYBINDINGS
" =============================================================================

" [[ ESSENTIAL ]] {{
let mapleader = " "
let maplocalleader = " "

" [[ EASIER KEYBINDS FOR COMMON OPS ]]
nnoremap <silent> cu ct_
nnoremap <silent> du dt_
nnoremap <silent> c. ct.
nnoremap <silent> d. dt.
nnoremap <silent> c" ct"
nnoremap <silent> d" dt"
nnoremap <silent> c' ct'
nnoremap <silent> d' dt'
xnoremap <silent> , t,
xnoremap <silent> . t.
noremap H ^
noremap L $
noremap <C-e> $%
nnoremap <leader>e q:

" [[ WRITE NO FORMAT ]]
nnoremap <silent> <leader>wnf :noautocmd w<CR>
" }}

" [[ QOL/COOL ]] {{
" [[ MOVE VISUALLY SELECTED LINES/BLOCKS VERTICALLY ]]
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" [[ SENSIBLE BEHAVIOR ]]
nnoremap J mzJ`z

" [[ GLOBAL SUBSTITUTION ]]
nnoremap S :%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>

" [[ STAY IN INDENT MODE ]]
vnoremap < <gv
vnoremap > >gv

" [[ TYPE SHELL COMMANDS IN A FILE AND EXPAND THE OUTPUT ]]
nnoremap <leader>so :.!sh<CR>

" [[ ANTI-TEXTWRAP ]]
"nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
"nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')
"vnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
"vnoremap <expr> j (v:count == 0 ? 'gj' : 'j')

" [[ VERTICAL MVMT ]]
nnoremap <silent> <C-d> <C-d>zz
nnoremap <silent> <C-u> <C-u>zz

" [[ CENTER SEARCH RESULTS ]]
nnoremap <silent> n nzzzv
nnoremap <silent> N Nzzzv
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap <silent> g* g*zz

" [[ "Very No Magic" ]]
" Lets you search for special chars like * or [ or | literally
nnoremap ? ?\V
nnoremap / /\V
cnoremap %s/ %sm/

" [[ WORD COUNT FOR VISUAL SELECTION ]]
xnoremap <leader>wc :'<,'>w !wc -w<CR>

" [[ TOGGLE SEARCH HIGHLIGHTS ]]
nnoremap <silent> <Esc> :nohlsearch<CR>
" }}

" [[ COPY/PASTE ]] {{
" [[ COPY PASTE SYSTEM CLIPBOARD ]]
"xnoremap <silent> <leader>y y:call system("wl-copy --trim-newline", @*)<cr>:call system("wl-copy -p --trim-newline", @*)<cr>

" [[ SANER PASTE BEHAVIOR ]]
" Paste from system clipboard in Insert and Command-line mode
inoremap <C-v> <C-r>*
cnoremap <C-v> <C-r>*

" Paste from the default (unnamed) register in Command-line mode
cnoremap <C-v> <C-r>"

" To not clobber clipboard
nnoremap cc "_cc

" [[ RE-SELECT MOST RECENT VISUAL HIGHLIGHTED ]]
nnoremap <leader>v `[V`]

" [[ BUFFERS ]] {{
nnoremap <leader>j :bnext<CR>
nnoremap <leader>k :bprev<CR>
nnoremap <leader>bd :bdelete<CR>
nnoremap <silent> <leader>; :b#<CR>

" [[ WINDOW/SPLIT NAVIGATION ]]
nnoremap <C-h> <C-w><C-h>
nnoremap <C-l> <C-w><C-l>
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>

" [[ SELECT ENTIRE BUFFER ]]
nnoremap gG gg<S-v>G
" }}

" [[ AUTOCORRECT ]]
iabbrev teh the
iabbrev recieve receive
iabbrev strcut struct
iabbrev cosnt const
iabbrev ^^ ↑
iabbrev VV ↓
" }}

" vim: set ts=2 sts=2 sw=2 et:

