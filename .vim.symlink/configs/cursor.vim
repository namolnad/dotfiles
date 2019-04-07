" Change cursor shape between insert and normal mode in iTerm2.app
if $TERM_PROGRAM =~ "iTerm"
" Vertical bar in insert mode
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
 " Block in normal mode
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif
