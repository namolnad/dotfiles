""""" See :help key-notation for definitions """""

" Switch between previous/next buffers
nnoremap <leader><leader> <c-^>

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

