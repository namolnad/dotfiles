let mapleader=","

" remove all existing autocmds
autocmd!

runtime! configs/**/*.vim

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" BASIC EDITING CONFIGURATION
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Alphabetize ignoring 'no' or other obvious prefixes

" allow backspacing over everything in insert mode
set backspace=indent,eol,start
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
" Don't make backups at all
set nobackup
set nowritebackup
set cmdheight=1
set nocompatible
" highlight current line
set cursorline
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set encoding=utf-8
 " use spaces, not tabs
set expandtab
set guifont=Monaco:h12
set guioptions-=T guioptions-=e guioptions-=L guioptions-=r
" allow unsaved background buffers and remember marks/undo for them
set hidden
" remember more commands and search history
set history=10000
" make searches case-sensitive only if they contain upper-case characters
set ignorecase smartcase
set autoindent
set smartindent
set laststatus=2
 " Show invisible characters
set list
" Turn folding off for real, hopefully
set nofoldenable
set foldmethod=manual
" Insert only one space when joining lines that contain sentence-terminating
" punctuation like `.`.
set nojoinspaces
" Modelines (comments that set vim options on a per-file basis)
set modeline
set modelines=3
set number
" keep more context when scrolling off the end of a buffer
set scrolloff=3
set incsearch
set hlsearch
set shell=zsh
set showmatch
" display incomplete commands
set showcmd
set splitbelow
set splitright
set switchbuf=useopen
" Fix slow O inserts
:set timeout timeoutlen=1000 ttimeoutlen=100
" Disable output and VCS files
set wildignore+=*.o,*.out,*.obj,.git,*.rbc,*.rbo,*.class,.svn,*.gem

" Disable archive files
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz

" Ignore bundler and sass cache
set wildignore+=*/vendor/gems/*,*/vendor/cache/*,*/.bundle/*,*/.sass-cache/*

" Disable temp and backup files
set wildignore+=*.swp,*~,._*
" make tab completion for files/buffers act like bash
set wildmenu
set wildmode=list:longest,full
set visualbell

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" EDITOR APPEARANCE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set winwidth=79
set tabstop=4
set shiftwidth=4
set softtabstop=4
" Enable highlighting for syntax
syntax on
" Enable file type detection.
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MISC
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Normally, Vim messes with iskeyword when you open a shell file. This can
" leak out, polluting other file types even after a 'set ft=' change. This
" variable prevents the iskeyword change so it can't hurt anyone.
let g:sh_noisk=1

