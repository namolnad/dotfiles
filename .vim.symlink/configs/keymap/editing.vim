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

" Jump to definition
nnoremap <leader>j :ALEGoToDefinition<cr>
nnoremap <leader>f :ALEFix<cr>

