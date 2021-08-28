""""" See :help key-notation for definitions """""

" Run launch-app script w/ leader+r
nnoremap <leader>r :! PROJECT=Instacart $CODE_DIR/Scripts/launch-app.sh<CR>
" Run test-app script
nnoremap <leader>t :! $CODE_DIR/Scripts/test-app.sh<CR>
