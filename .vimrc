
" BEGIN PLUGINS
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'jceb/vim-orgmode'
Plugin 'whiteinge/diffconflicts'
Plugin 'vim-scripts/utl.vim'
Plugin 'vim-scripts/taglist.vim'
Plugin 'keith/swift.vim'
Plugin 'majutsushi/tagbar'
Plugin 'chrisbra/NrrwRgn'
Plugin 'itchyny/calendar.vim'
Plugin 'inkarkat/vim-SyntaxRange'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-pathogen'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-speeddating'
Plugin 'tpope/vim-fugitive'

call vundle#end()            " required

" required
filetype plugin indent on
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList          - list configured plugins
" :PluginInstall(!)    - install (update) plugins
" :PluginSearch(!) foo - search (or refresh cache first) for foo
" :PluginClean(!)      - confirm (or auto-approve) removal of unused plugins
"
" see :h vundle for more details or wiki for FAQ
" END PLUGINS

execute pathogen#infect()

syntax on

" Colors "
let g:solarized_termcolors=256
set background=dark
colorscheme solarized
set t_Co=256

set hlsearch

set backspace=2
set tabstop=2 " a tab is two spaces
set autoindent
set smartindent
set shiftwidth=2 " an autoindent (with <<) is two spaces
set expandtab " use spaces, not tabs
set list " Show invisible characters

set number

" Disable output and VCS files
set wildignore+=*.o,*.out,*.obj,.git,*.rbc,*.rbo,*.class,.svn,*.gem

" Disable archive files
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz

" Ignore bundler and sass cache
set wildignore+=*/vendor/gems/*,*/vendor/cache/*,*/.bundle/*,*/.sass-cache/*

" Disable temp and backup files
set wildignore+=*.swp,*~,._*

""
"" Backup and swap files
""

set backupdir^=~/.vim/_backup// " where to put backup files.
set directory^=~/.vim/_temp// " where to put swap files.

let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_rails = 1

:nnoremap <leader>m :silent !open -a Marked.app '%:p'<cr>

inoremap kj <ESC>

set visualbell

set wildmenu
set wildmode=list:longest,full

set splitright
set splitbelow

set hidden

set guifont=Monaco:h12
set guioptions-=T guioptions-=e guioptions-=L guioptions-=r
set shell=zsh

" if filereadable(expand('~/.vimrc.local'))
"   source ~/.vimrc.local
" endif

" Change cursor shape between insert and normal mode in iTerm2.app
if $TERM_PROGRAM =~ "iTerm"
    let &t_SI = "\<Esc>]50;CursorShape=1\x7" " Vertical bar in insert mode
    let &t_EI = "\<Esc>]50;CursorShape=0\x7" " Block in normal mode
endif

" gist-vim settings
let g:gist_clip_command = 'pbcopy'
let g:gist_get_multiplefile = 1

set encoding=utf-8

" The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

" bind K to grep word under cursor
nnoremap K :Ag "\b<C-R><C-W>\b"<CR>:cw<CR>

command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!

" Map ctrl-movement keys to window switching
map <C-k> <C-w><Up>
map <C-j> <C-w><Down>
map <C-l> <C-w><Right>
map <C-h> <C-w><Left>

" Switch to alternate file
map <C-Tab> :bnext<cr>
map <C-S-Tab> :bprevious<cr>

" Calendar "
" let g:calendar_google_calendar = 1
" let g:calendar_google_task = 1
