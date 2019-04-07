" The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor
endif

" Create new vim command :Ag to grep for arguments
command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
