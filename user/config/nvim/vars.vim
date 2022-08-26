let g:openedWithDir = 0

if argc() > 0 && isdirectory(argv(0))
  exe 'cd ' . argv(0)
  let g:openedWithDir = 1
endif
if argc() == 0
  let g:openedWithDir = 1
endif

" resolve() resolves any symbolic links.
" fnameescape() escapes paths with spaces, e.g. "My\ Docs/".
let g:projectDir = fnameescape(resolve(getcwd()))
