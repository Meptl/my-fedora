" fugitive reblame doesn't work with scrolloff=999
augroup MyFugitive
    autocmd!
    autocmd BufWinLeave *.fugitiveblame set scrolloff=0
    " Imperfect but I couldn't find where in the vim buf event stack to put it.
    autocmd CursorHold *.fugitiveblame set scrolloff=999
augroup END
