" This is Dan Loman's .vimrc file

" remove all existing autocmds
autocmd!

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" BASIC EDITING CONFIGURATION
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set nocompatible
set number
" allow unsaved background buffers and remember marks/undo for them
set hidden
" remember more commands and search history
set history=10000
 " use spaces, not tabs
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent
set smartindent
set laststatus=2
set showmatch
set incsearch
set hlsearch
 " Show invisible characters
set list
" make searches case-sensitive only if they contain upper-case characters
set ignorecase smartcase
" highlight current line
set cursorline
set cmdheight=1
set switchbuf=useopen
" Always show tab bar at the top
" set showtabline=2
set winwidth=79

" make searches case-sensitive only if they contain upper-case characters
set ignorecase smartcase

" Disable output and VCS files
set wildignore+=*.o,*.out,*.obj,.git,*.rbc,*.rbo,*.class,.svn,*.gem

" Disable archive files
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz

" Ignore bundler and sass cache
set wildignore+=*/vendor/gems/*,*/vendor/cache/*,*/.bundle/*,*/.sass-cache/*

" Disable temp and backup files
set wildignore+=*.swp,*~,._*

let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_rails = 1

" Prevent Vim from clobbering the scrollback buffer. See
" http://www.shallowsky.com/linux/noaltscreen.html
" set t_ti= t_te=
" keep more context when scrolling off the end of a buffer
set scrolloff=3
" Don't make backups at all
set nobackup
set nowritebackup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
" allow backspacing over everything in insert mode
set backspace=indent,eol,start
" display incomplete commands
set showcmd
" Enable highlighting for syntax
syntax on
" Enable file type detection.
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on
" use emacs-style tab completion when selecting files, etc
set wildmode=longest,list
" make tab completion for files/buffers act like bash
set wildmenu
let mapleader=","
" Fix slow O inserts
:set timeout timeoutlen=1000 ttimeoutlen=100
" Normally, Vim messes with iskeyword when you open a shell file. This can
" leak out, polluting other file types even after a 'set ft=' change. This
" variable prevents the iskeyword change so it can't hurt anyone.
let g:sh_noisk=1
" Modelines (comments that set vim options on a per-file basis)
set modeline
set modelines=3
" Turn folding off for real, hopefully
set foldmethod=manual
set nofoldenable
" Insert only one space when joining lines that contain sentence-terminating
" punctuation like `.`.
set nojoinspaces

" Command-T
" ignore dotfiles completely;
" g:CommandTNeverShowDotFiles
" stop searching recursively in dotdirs;
" let g:CommandTScanDotDirectories=0
" specify at what depth should Command-T stop scanning.
let g:CommandTMaxDepth=4
" Use find instead of 'ruby' for faster scanning in large hierarchies
let g:CommandTFileScanner='find'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CUSTOM AUTOCMDS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup vimrcEx
  " Clear all autocmds in the group
  autocmd!
  autocmd FileType text setlocal textwidth=78
  " Jump to last cursor position unless it's invalid or in an event handler
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  "for ruby, autoindent with two spaces, always expand tabs
  autocmd FileType ruby,haml,eruby,yaml,html,sass,cucumber set ai sw=2 sts=2 et
  autocmd FileType python set sw=4 sts=4 et

  autocmd! BufRead,BufNewFile *.sass setfiletype sass

  autocmd BufNewFile,BufRead *.swift setfiletype swift
  autocmd BufRead *.mkd  set ai formatoptions=tcroqn2 comments=n:&gt;
  autocmd BufRead *.markdown  set ai formatoptions=tcroqn2 comments=n:&gt;

  " Don't syntax highlight markdown because it's often wrong
  autocmd! FileType mkd setlocal syn=off

  " Leave the return key alone when in command line windows, since it's used
  " to run commands there.
  autocmd! CmdwinEnter * :unmap <cr>
  autocmd! CmdwinLeave * :call MapCR()

  " *.md is markdown
  autocmd! BufNewFile,BufRead *.md setlocal ft=

  " indent slim two spaces, not four
  autocmd! FileType slim set sw=2 sts=2 et

  " javascript
  autocmd! FileType javascript set sw=2 sts=2 expandtab autoindent smartindent nocindent

  " Expand tabs in Go. Was gofmt raised in a barn?!
  autocmd! FileType go set sw=4 sts=4 expandtab | retab

  " Indent swift 4 spaces"
  autocmd FileType swift set sw=4 sts=4 expandtab autoindent smartindent
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" STATUS LINE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" let g:airline_statusline_ontop=1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" BEGIN PLUGINS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Brief help
" :PluginList          - list configured plugins
" :PluginInstall(!)    - install (update) plugins
" :PluginSearch(!) foo - search (or refresh cache first) for foo
" :PluginClean(!)      - confirm (or auto-approve) removal of unused plugins
"
" see :h vundle for more details or wiki for FAQ

" be iMproved, required
set nocompatible
" required
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
" set runtime path to include fzf
set rtp+=/usr/local/opt/fzf

call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'keith/swift.vim'
Plugin 'w0rp/ale'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-pathogen'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-speeddating'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-unimpaired'
Plugin 'tpope/vim-surround'
Plugin 'gabrielelana/vim-markdown'
Plugin 'wincent/command-t'
Plugin 'zxqfl/tabnine-vim'
Plugin 'junegunn/fzf.vim'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'jiangmiao/auto-pairs'
Plugin 'k0kubun/vim-open-github'
Plugin 'vim-airline/vim-airline'
" Color Themes
Plugin 'altercation/vim-colors-solarized' " Can be removed if I end up liking molokai
Plugin 'tomasr/molokai'

" required
call vundle#end()

" required
filetype plugin indent on
" To ignore plugin indent changes, instead use:
"filetype plugin on
"

let g:markdown_enable_conceal=2

set visualbell

set wildmenu
set wildmode=list:longest,full

set splitright
set splitbelow

set guifont=Monaco:h12
set guioptions-=T guioptions-=e guioptions-=L guioptions-=r
set shell=zsh

" if filereadable(expand('~/.vimrc.local'))
"   source ~/.vimrc.local
" endif

" Change cursor shape between insert and normal mode in iTerm2.app
if $TERM_PROGRAM =~ "iTerm"
" Vertical bar in insert mode
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
 " Block in normal mode
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

" gist-vim settings
let g:gist_clip_command = 'pbcopy'
let g:gist_get_multiplefile = 1

set encoding=utf-8

" The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" KEY MAPPINGS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""" See :help key-notation for definitions """""

"""""" EDITING

" Move/drag lines; NOTE: Terminal sends ∆ for Meta-j and ˚ for Meta-k. Use these instead
nnoremap ∆ :m .+1<CR>==
nnoremap ˚ :m .-2<CR>==
inoremap ∆ <Esc>:m .+1<CR>==gi
inoremap ˚ <Esc>:m .-2<CR>==gi
vnoremap ∆ :m '>+1<CR>gv=gv
vnoremap ˚ :m '<-2<CR>gv=gv

" Align selected lines
vnoremap <leader>ib :!align<cr>

"""""" SEARCHING

" Map ctrl+p to fzf :Files command
nnoremap <c-p> :Files<cr>
nnoremap <leader><c-p> :GitFiles<cr>

" bind K to grep word under cursor
nnoremap K :Ag "\b<C-R><C-W>\b"<CR>:cw<CR>

"""""" CONVENIENCE

" Convient escape in insert mode
inoremap kj <ESC>

" Can't be bothered to understand ESC vs ctrl+c in insert mode
imap <c-c> <esc>

nnoremap <leader><leader> <c-^>

" Yank to global pasteboard
map <leader>y "*y

" Use shift tab to trigger word completion in insert
inoremap <s-tab> <c-n>

" Use leader m to preview current md file in Marked app
:nnoremap <leader>m :silent !open -a Marked.app '%:p'<cr>

" Run launch-app script w/ leader+r
nnoremap <leader>r :!~/Code/Dans-scripts/launch-app.sh<CR>

"""""" BUFFER MOVEMENT

" Move around splits with <c-hjkl>
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" Switch to previous/next buffer
map <C-Tab> :bnext<cr>
map <C-S-Tab> :bprevious<cr>

" Disable arrow keys for vim training
noremap <Up> :echo "No arrow keys for you!"<CR>
noremap <Down> :echo "No arrow keys for you!"<CR>
noremap <Left> :echo "No arrow keys for you!"<CR>
noremap <Right> :echo "No arrow keys for you!"<CR>

" MULTIPURPOSE TAB KEY
" Indent if we're at the beginning of a line. Else, do completion.

function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <expr> <tab> InsertTabWrapper()

" YouCompleteMe
let g:ycm_key_list_select_completion = ['<Down>', '<C-j>']
let g:ycm_key_list_previous_completion = ['<Up>', '<C-k>']

" UltiSnips
let g:UltiSnipsExpandTrigger="<Tab>"
let g:UltiSnipsJumpForwardTrigger="<Tab>"
let g:UltiSnipsJumpBackwardTrigger="<S-Tab>"
let g:UltiSnipsListSnippets="<C-l>"
let g:UltiSnipsEditSplit="vertical"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MISC
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" COLOR
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" 256 colors
set t_Co=256
let g:solarized_termcolors=256
colorscheme molokai

set background=dark

" :color grb256
