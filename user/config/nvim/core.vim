" nohl
nnoremap <Space> :noh<CR>

" <Esc>, <CR>, <BS>
inoremap <M-;> <Esc>
vnoremap <M-;> <Esc>
cnoremap <M-;> <Esc>

inoremap <M-j> <CR>

inoremap <M-h> <BS>

" normal mode space
nnoremap <M-Space> i<Space><Esc>

" normal mode CR
nnoremap K i<CR><Esc>

let s:nav_jump = 5
let s:nav_jump_large = 25

" vertical navigation
exe 'nnoremap <M-j> ' . s:nav_jump . 'j'
exe 'vnoremap <M-j> ' . s:nav_jump . 'j'

exe 'nnoremap <M-k> ' . s:nav_jump . 'k'
exe 'vnoremap <M-k> ' . s:nav_jump . 'k'

exe 'nnoremap <M-d> ' . s:nav_jump_large . 'j'
exe 'vnoremap <M-d> ' . s:nav_jump_large . 'j'
exe 'nnoremap <C-d> ' . s:nav_jump_large . 'j'
exe 'vnoremap <C-d> ' . s:nav_jump_large . 'j'

exe 'nnoremap <M-u> ' . s:nav_jump_large . 'k'
exe 'vnoremap <M-u> ' . s:nav_jump_large . 'k'
exe 'nnoremap <C-u> ' . s:nav_jump_large . 'k'
exe 'vnoremap <C-u> ' . s:nav_jump_large . 'k'

" buffer navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap <M-h> <C-w>h
nnoremap <M-l> <C-w>l

nnoremap = <C-w>=

" close and save
nnoremap ZZ :up<CR>:qa!<CR>
nnoremap ZQ :qa!<CR>

" indentation
nnoremap <Tab> >>
vnoremap <Tab> >gv
inoremap <S-Tab> <C-d>
nnoremap <S-Tab> <<
vnoremap <S-Tab> <gv

" code commenting
imap <M-/> <Esc>gc<Right><Right>i
nmap <M-/> <Esc>gc<Right>
vmap <M-/> gcgv

" clipboard
vnoremap <C-c> "+ygv
nnoremap <C-c> "+ygv

" replace window preview (fzf.vim)
com! W w

" gx browser
nnoremap gx :silent! exe '!$BROWSER '.expand('<cWORD>')<CR>
