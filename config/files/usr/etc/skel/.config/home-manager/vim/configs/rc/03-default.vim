" This file is also: 'things vim should do out of the box'
" Note that I've left off a few sensible defaults here because neovim defaults
" are generally good. See :help vim-differences. There are a few I stole from
" https://github.com/neovim/neovim/issues/6289 rather than install vim-sensible.
" Core vim option setting {{{
set tabstop=2                        " Number of visual spaces per TAB
set softtabstop=2                    " Number of spaces per tab when editting
set shiftwidth=2
set expandtab                        " Tabs are spaces
set wildmode=longest,list            " Dictates completion method on wildmenu.
set number
set relativenumber
set autoread
set t_Co=256
set fileformats=unix
set showcmd                          " Show command progress in lower right.
set showmatch                        " Highlight matching ({[]})
set lazyredraw                       " Don't redraw during macro playback
set viewoptions-=options             " I don't use views. But this is sensible.
set completeopt-=preview             " Remove scratch windows during tab completion
set list                             " Use listchars
set textwidth=80                     " Set textwidth so `gq`/autoformat works when the next option is applied.
set wrapmargin=-1000                 " Prevent autoindenting when commenting.
set formatoptions-=t                 " Prevent auto breaking due to setting textwidth.
set formatoptions-=c                 " Prevent auto breaking on comments due to setting textwidth.
set nojoinspaces                     " Prevent two spaces after a full stop while autoformatting.
set listchars=tab:\»\ ,extends:↘,precedes:↖ " Replace tabs with »
set scrolloff=999                    " Keep cursor in the center.
set shell=/bin/sh
set splitbelow                       " Better splittings.
set splitright                       " Better splittings.
set background=dark
set clipboard+=unnamedplus           " Copy to system clipboard (Ctrl-C). Always.
set virtualedit=block                " Allow visual block select beyond EOL.
set signcolumn=no                    " Pretty sure signcolumn is a dumb hack :).
set nojoinspaces                     " Prevent double spaces after vim autoformats `gq`

" Disable mouse. The default `set mouse=` allows the terminal emulator to read
" scroll inputs and forwards that to vim.
set mouse=nicr
map <LeftMouse> <nop>
map <RightMouse> <nop>
map <ScrollWheelUp> <nop>
map <ScrollWheelDown> <nop>
imap <LeftMouse> <nop>
imap <RightMouse> <nop>
imap <ScrollWheelUp> <nop>
imap <ScrollWheelDown> <nop>
" }}}

" Backup, undo, swap file setup {{{
" Disable backups for coc nvim.
set nobackup                         " Backup files.
set nowritebackup
set backupskip=/tmp/*
set undofile                         " Persistent undo.
set undolevels=5000
" The // in these values tell vim to store as an absolute path.
set backupdir=$HOME/.vim/backup//
set directory=$HOME/.vim/swap//          " Swap files.
set undodir=$HOME/.vim/undo//
call mkdir(expand(&backupdir), 'p')
call mkdir(expand(&directory), 'p')
call mkdir(expand(&undodir), 'p')
" }}}

command! -nargs=0 CurrentHighlightGroup :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
            \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
            \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

augroup DefaultAutocmds
    autocmd!
    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    autocmd BufReadPost * if line("'\"") >= 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

    function! HelpInNewTab()
        if &buftype == 'help'
            " Convert the help window to a tab.
            execute "normal \<C-W>T"
        endif
    endfunction
    autocmd BufEnter *.txt call HelpInNewTab()
augroup END

" Search in visual mode
vnoremap <silent>* <ESC>:call VisualSearch('/')<CR>/<CR>
vnoremap <silent># <ESC>:call VisualSearch('?')<CR>?<CR>
function! VisualSearch(direction)
    let l:register=@@
    normal! gvy
    let l:search=escape(@@, '$.*/\[]')
    if a:direction=='/'
        execute 'normal! /'.l:search
    else
        execute 'normal! ?'.l:search
    endif
    let @/=l:search
    normal! gV
    let @@=l:register
endfunction

" Quickfix toggle {{{
function! QuickfixToggle()
    for i in range(1, winnr('$'))
        let bnum = winbufnr(i)
        if getbufvar(bnum, '&buftype') == 'quickfix'
            cclose
            return
        endif
    endfor

    copen
endfunction
command! -nargs=0 QuickfixToggle :call QuickfixToggle()

function! LocationListToggle() abort
    let buffer_count_before = s:BufferCount()
    " Location list can't be closed if there's cursor in it, so we need
    " to call lclose twice to move cursor to the main pane
    silent! lclose
    silent! lclose

    if s:BufferCount() == buffer_count_before
        execute "silent! lopen"
    endif
endfunction
function! s:BufferCount() abort
    return len(filter(range(1, bufnr('$')), 'bufwinnr(v:val) != -1'))
endfunction
command! -nargs=0 LocationListToggle :call LocationListToggle()

" }}}

" Tabline with numbering {{{
" Commented out because does not collapse properly, so fails with many files.
" Rename tabs to show tab number. Mostly copied with slight bugfix.
" (Based on http://stackoverflow.com/questions/5927952/whats-implementation-of-vims-default-tabline-function)
" if exists("+showtabline")
"     function! MyTabLine()
"         let s = ''
"         let wn = ''
"         let t = tabpagenr()
"         let i = 1
"         while i <= tabpagenr('$')
"             let buflist = tabpagebuflist(i)
"             let winnr = tabpagewinnr(i)
"             let s .= '%' . i . 'T'
"             let s .= (i == t ? '%1*' : '%2*')
"             let s .= ' '
"             let wn = tabpagewinnr(i,'$')

"             let s .= '%#TabNum#'
"             let s .= i
"             " let s .= '%*'
"             let s .= (i == t ? '%#TabLineSel#' : '%#TabLine#')
"             let bufnr = buflist[winnr - 1]
"             let file = bufname(bufnr)
"             let buftype = getbufvar(bufnr, '&buftype')
"             if buftype == 'nofile'
"                 if file =~ '\/.'
"                     let file = substitute(file, '.*\/\ze.', '', '')
"                 endif
"             elseif buftype == 'help'
"                 let file = '[H] ' . fnamemodify(file, ':t')
"             else
"                 let file = pathshorten(fnamemodify(file, ':.'))
"             endif
"             if file == ''
"                 let file = '[No Name]'
"             endif
"             let s .= ' ' . file . ' '
"             let i = i + 1
"         endwhile
"         let s .= '%T%#TabLineFill#%='
"         let s .= (tabpagenr('$') > 1 ? '%999XX' : 'X')
"         return s
"     endfunction
"     set stal=2
"     set tabline=%!MyTabLine()
"     set showtabline=1
"     highlight link TabNum Special
" endif "}}}

" Easier macro application.
map Q <Nop>
nnoremap Q @q

nnoremap Y y$

nnoremap S :%s///g<LEFT><LEFT>
vnoremap S :s///g<LEFT><LEFT>

nnoremap gf gF

" Use <C-L> to clear the highlighting of :set hlsearch.
nnoremap <silent> <C-L> :nohlsearch<CR>

" Fix visual paste, but also don't muck up the registry with the delete.
vnoremap p "_dP

" Add numerical jumps to the jumplist
nnoremap <expr> k (v:count > 1 ? "m'" . v:count : '') . 'k'
nnoremap <expr> j (v:count > 1 ? "m'" . v:count : '') . 'j'

" Split window handling.
nnoremap <M-<> :vertical resize -10<CR>
nnoremap <M->> :vertical resize +10<CR>
nnoremap <M-_> :resize -10<CR>
nnoremap <M-+> :resize +10<CR>

" Display registers.
nnoremap <silent> "" :registers "0123456789abcdefghijklmnopqrstuvwxyz*+.<CR>

" Save file with sudo
cmap w!! w !sudo tee > /dev/null %

" Define filetypes for certain file extensions {{{
augroup filetypes
    autocmd BufRead,BufNewFile *.ino,*.pde setfiletype c
    autocmd BufRead,BufNewFile *.xsh,.xonshrc,xonshrc setfiletype python
    autocmd BufRead,BufNewFile *.inc,*.module setfiletype php
    autocmd BufRead,BufNewFile *.gdx setfiletype gdscript3
augroup END " }}}
