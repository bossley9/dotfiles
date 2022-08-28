" vim:fdm=marker

" gitgutter {{{

let s:vcs = '│'

" disable gutter mappings
let g:gitgutter_map_keys = 0
" gutter refresh rate
set updatetime=300
" gutter symbols
let g:gitgutter_sign_added = s:vcs
let g:gitgutter_sign_modified = s:vcs
let g:gitgutter_sign_removed = s:vcs
let g:gitgutter_sign_removed_first_line = s:vcs
let g:gitgutter_sign_modified_removed = s:vcs

set signcolumn=yes

" }}}

" gitblame {{{

com! CopySHA GitBlameCopySHA

" }}}
