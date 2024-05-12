" Highlight EOL whitespace, http://vim.wikia.com/wiki/Highlight_unwanted_spaces
call s:highlight("ExtraWhitespace", {"bg": s:red})
augroup EOLhighlight
    autocmd!
    autocmd ColorScheme * call s:highlight("ExtraWhitespace", {"bg": s:red})
    autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
    " the above flashes annoyingly while typing, be calmer in insert mode
    autocmd InsertLeave * match ExtraWhitespace /\s\+$/
    autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
augroup END

function! s:FixWhitespace(line1,line2)
    let l:save_cursor = getpos(".")
    " Clear Windows line endings.
    silent! execute ':' . a:line1 . ',' . a:line2 . 's/
$//'
    " Clear white space.
    silent! execute ':' . a:line1 . ',' . a:line2 . 's/\s\+$//'
    retab
    call setpos('.', l:save_cursor)
endfunction

" Run :FixWhitespace to remove end of line white spaces, tabs, and line endings.
command! -range=% FixWhitespace call <SID>FixWhitespace(<line1>,<line2>)
