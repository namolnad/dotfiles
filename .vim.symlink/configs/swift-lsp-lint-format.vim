let g:airline#extensions#ale#enabled = 1

 let g:ale_echo_msg_error_str = 'ERROR'
 let g:ale_echo_msg_warning_str = 'WARN'
 let g:ale_echo_msg_format = '[%linter%] *%severity%* %s'

let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'swift': ['swiftformat'],
\}

let g:ale_swift_swiftformat_options = '--header strip
            \ --commas inline
            \ --indent 4
            \ --self init-only
            \ --commas inline
            \ --stripunusedargs closure-only
            \ --wrapcollections beforefirst
            \ --wraparguments beforefirst'

