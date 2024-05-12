let g:codeium_enabled = v:false
let g:codeium_no_map_tab = v:true
imap <script><silent><nowait><expr> <S-CR> codeium#Accept()
" nmap <leader>c <Cmd>call codeium#Complete()<CR>
