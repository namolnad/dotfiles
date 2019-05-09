""""" See :help key-notation for definitions """""

"""""" SEARCHING / EXPLORING

map <silent> <C-E> :call ToggleVExplorer()<CR>

" Map ctrl+p to fzf :Files command
nnoremap <c-p> :Files<cr>
nnoremap <leader><c-p> :GitFiles<cr>

" bind K to grep word under cursor
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

nnoremap \ :Ag<SPACE>

" Use leader-f to more easily find files
nnoremap <leader>f :Files<cr>
nnoremap <leader><c-f> :GitFiles<cr>
