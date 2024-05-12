" Some plugin commands are unavailable within the configuration. So define a
" command to run at startup.
function! PersonalPluginRc()
  Abolish {despa,sepe}rat{e,es,ed,ing,ely,ion,ions,or}  {despe,sepa}rat{}
  Abolish accomadat{e,es,ed,ing,ion,ions}  accomodat{}
endfunction
autocmd VimEnter * call PersonalPluginRc()

augroup Commentary
    autocmd FileType openscad setlocal commentstring=//\ %s
augroup END

" Customize default file browser
let g:netrw_banner = 0
let g:netrw_bufsettings = 'noma nomod nonu nobl nowrap ro'


" vim-smoothie configuration
if !exists('g:smoothie_base_speed')
    let g:smoothie_base_speed = 20
endif

" vim-polyglot includes csv.vim which does fancy comma delimiting. Disable it.
let g:csv_no_conceal = 1

" Allow a whitespace surround. For whatever reason I have to press it twice.
let g:surround_32 = " \r "

" test.vim configuration
let test#strategy = "neomake"

" neomake configuration {{{
let g:neomake_place_signs = 1
let g:neomake_virtualtext_current_error = 0
let g:neomake_error_sign =   { 'numhl': 'QuickfixErrorNr' }
let g:neomake_warning_sign = { 'numhl': 'QuickfixWarningNr' }
let g:neomake_message_sign = { 'numhl': 'QuickfixMessageNr' }
let g:neomake_info_sign =    { 'numhl': 'QuickfixInfoNr' }
function! MyNeomakeHook()
    if g:neomake_hook_context.jobinfo.exit_code == 0
        echom 'Success: neomake'
    endif
    cclose
endfunction
autocmd User NeomakeJobFinished call MyNeomakeHook()
" }}}

" vim-schlepp configuration
let g:Schlepp#dupTrimWS = 1  " Remove trailing whitespace on duplication
vmap <up>    <Plug>SchleppUp
vmap <down>  <Plug>SchleppDown
vmap <left>  <Plug>SchleppLeft
vmap <right> <Plug>SchleppRight
vmap Dk <Plug>SchleppDupUp
vmap Dj <Plug>SchleppDupDown
vmap Dh <Plug>SchleppDupLeft
vmap Dl <Plug>SchleppDupRight

" gitgutter configuration {{{
" Make git gutter do nothing until we call ]c or [c.
" let g:gitgutter_map_keys = 0
" let g:gitgutter_signs = 0
" let g:gitgutter_highlight_lines = 1
" let g:gitgutter_highlight_linenrs = 0
" " TODO: Make this not overwrite.
" nnoremap <silent> <C-L> :nohlsearch<CR>:call gitgutter#sign#clear_signs(bufnr(''))<CR>
" augroup MyGitGutter
"     autocmd!
"     autocmd InsertEnter * call gitgutter#sign#clear_signs(bufnr(''))
"     " This belongs in an 'after plugin' rc, but I don't have one so I'll run it
"     " on VimEnter.
"     autocmd VimEnter * autocmd! gitgutter CursorHold,CursorHoldI
" augroup END
" highlight link GitGutterAddLine NONE
" highlight link GitGutterDeleteLine NONE
" highlight link GitGutterChangeLine NONE
" highlight link GitGutterChangeDeleteLine NONE
" highlight link GitGutterAddLineNr NONE
" highlight link GitGutterDeleteLineNr NONE
" highlight link GitGutterChangeLineNr NONE
" highlight link GitGutterChangeDeleteLineNr NONE
" omap ih <Plug>(GitGutterTextObjectInnerPending)
" omap ah <Plug>(GitGutterTextObjectOuterPending)
" xmap ih <Plug>(GitGutterTextObjectInnerVisual)
" xmap ah <Plug>(GitGutterTextObjectOuterVisual)
" function! UpdateGitGutter ()
"     let g:gitgutter_diff_base = trim(system('git rev-parse $(git parent)'))
"     GitGutter
"     " We want the bg change as subtle as possible. So use the color code right
"     " above bg. Sorry for the hardcode love. Also bah can't setup CursorLineNr
"     " with sign-define's numhl.
"     highlight GitGutterAddLine ctermbg=233
"     highlight GitGutterChangeLine ctermbg=233
"     " highlight GitGutterAddLineNr ctermfg=239 ctermbg=233
"     " highlight GitGutterChangeLineNr ctermfg=239 ctermbg=233
" endfunction
" nmap ]c :call UpdateGitGutter()<CR><Plug>(GitGutterNextHunk)
" nmap [c :call UpdateGitGutter()<CR><Plug>(GitGutterPrevHunk)
" " }}}

" vim-swap {{{
let g:swap_no_default_key_mappings = 1

nmap <leader>mi <Plug>(swap-interactive)
nmap <leader>mh <Plug>(swap-prev)
nmap <leader>ml <Plug>(swap-next)
" }}}

" Use InstantMarkdownPreview
let g:instant_markdown_autostart = 0


" vim-localvimrc {{{
let g:localvimrc_persistent = 1
" let g:localvimrc_persistence_file = ~/.vim/localvimrc_persistence_file//
" }}}
