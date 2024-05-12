" Escape insert mode with jk.
inoremap <Esc> <Nop>
inoremap jk <esc>

" Rg with fzf
command! -bang -nargs=* Rg
\ call fzf#vim#grep(
\   'rg --column --line-number --no-ignore --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
\   <bang>0 ? fzf#vim#with_preview('up:60%')
\           : fzf#vim#with_preview('right:50%:hidden', '?'),
\   <bang>0)
" }}}

" Open files with FZF
nnoremap <M-e> :Files<CR>
nnoremap <M-t> :tabnew<CR>:Files<CR>
nnoremap <M-T> :tabnew<CR>:Rg<CR>

" Too lazy to make this work with all macros.
vnoremap Q :norm! @q<CR>

" Execute the macro normal for each searched line.
nnoremap X :g//norm! @q<CR>
vnoremap X :g/^/norm! @q<CR>:nohl<CR>



" J is still a reasonably valuable mapping.
nnoremap ^ J
" TODO: I want JK to be syntax motions rather than white space.
noremap J }
noremap K {
noremap H ^
" noremap L $
noremap L g$


" Leader mappings {{{
" Leader as space.
nnoremap <SPACE> <Nop>
let mapleader = " "

vnoremap <leader>rg y:Rg <C-R>"<CR>
nnoremap <leader>rg :Rg <C-R><C-W><CR>

nnoremap <leader>b :buffers<CR>:buffer<Space>
nnoremap <leader>ev :tabnew /etc/nixos/home/vim/configs/rc/15-personal.vim<CR>
nnoremap <leader>et :tabnew<CR>
" Doesn't work, can't find rcfile in current bin wrapper.
" function! CurrentRCFile()
"     return system("rg --only-matching -- '-u /nix/store/.*vimrc' $(readlink -ns $(which nvim)) | awk '{print $2}'")
" endfunction
" nnoremap <leader>sv :!zsh -ic 're h'<CR>:execute 'source ' . CurrentRCFile()<CR>

nnoremap <silent> <leader>qq :QuickfixToggle<CR>
nnoremap <silent> <leader>l :LocationListToggle<CR>
nnoremap <leader>E :Explore<CR>
nnoremap <leader>T :Texplore<CR>
nnoremap <leader>V :Vexplore<CR>
" Paste from linux middle mouse buffer.
nnoremap <leader>p "*p
nnoremap <leader>P "*P

" Substitute with counter. Defaults cursor to before substition
nnoremap <leader>x :let i=0\|g//let i=i+1\|s//\=''.i/g<LEFT><LEFT><LEFT><LEFT><LEFT>
vnoremap <leader>x :let i=0\|g/^/let i=i+1\|s//\=''.i/g<LEFT><LEFT><LEFT><LEFT><LEFT>

" Take a movement operator and paste the final line.
nnoremap <silent> <leader>yp :set opfunc=PasteIntoCurrentLine<CR>g@
function! PasteIntoCurrentLine(type, ...)
    let reg_save = @@
    silent exe "normal! ']yy"
    silent exe "normal! '[p"
    let @@ = reg_save
endfunction

" }}}

" Commands {{{
command! Spell setlocal spell spelllang=en_us

" git-fugitive shorthands
command! -nargs=* Gdf :Gdiff <args>
command! Gdfp :execute 'Gdiff ' . system('git parent')

" Buffer relative file editting
command! -nargs=1 Touch :tabnew %:h/<args>

augroup tabbing " {{{
    autocmd!
    autocmd FileType vim setlocal shiftwidth=4 tabstop=4
    autocmd FileType go setlocal noexpandtab shiftwidth=8 tabstop=8 softtabstop=0
    autocmd FileType cpp setlocal cinoptions=g0:0  " Some LLVM style indentation. See cinoptions-values.
    autocmd FileType gdscript setlocal noexpandtab shiftwidth=2 tabstop=2 softtabstop=2
    " Don't know why nix is defaulting to noexpandtab
    autocmd FileType nix setlocal expandtab
    autocmd FileType svelte setlocal shiftwidth=2 tabstop=2 softtabstop=2
augroup END " }}}

augroup intodbg
    autocmd!
    autocmd FileType python abbreviate intodbg (__import__('ipdb')).set_trace(); from pprint import pprint as pp
    autocmd FileType ruby abbreviate intodbg require 'pry'; binding.pry
    autocmd FileType php abbreviate intodbg eval(\Psy\sh()); // Need to `composer require psy/psysh:@stable
augroup END

augroup misc " {{{
    autocmd!
    " Support highlighting jsonc. json with comments.
    autocmd FileType json syntax match Comment +\/\/.\+$+
    function! TestRSpecFile()
        " For whatever reason compiler isn't automatically discovered by
        " vim-dispatch. (So I uninstalled vim-dispatch)
        compiler rspec
        TestFile
        copen
    endfunction
    autocmd BufWrite *_spec.rb call TestRSpecFile()
    autocmd FileType ruby abbreviate intodbg require 'pry'; binding.pry
augroup END " }}}
