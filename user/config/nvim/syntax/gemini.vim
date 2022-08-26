" Vim syntax file
" Language:    gemini
" Maintainer:  sloum < sloum AT rawtext.club >
" URL:         https://tildegit.org/sloum/gemini-vim-syntax

if exists("b:current_syntax")
  finish
endif

" Handle monospaced blocks
syn region gmiMono start=/^```/ end=/^```/

" Handle between one and three heading levels
syn match gmiHeader /^#\{1,3}[^#].*$/

" Start a link line
syn match gmiLinkStart /^=>/ nextgroup=gmiLinkUrl skipwhite

" An extremely naive way of handling the URL portion of the link line
" This is left naive in a deliberate attempt to be unambiguous about
" what part of a link line gemini considers to be the URL, regardless
" of whether or not it is a valid URL
syn match gmiLinkUrl /\S\+/ contained nextgroup=gmiLinkTitle skipwhite

" Skipping whitespace from the URL match all text, including whitespace,
" until the end of the line
syn match gmiLinkTitle /.*$/ contained

" Handle list items
syn match gmiListItem /^\* .*$/

" Handle quotes
syn match gmiQuoteLine /^>.*/

" Handle TODOs
syn match gmiTodo /TODO/

let b:current_syntax = "gemini"

hi def link gmiMono Special
hi def link gmiHeader Constant
hi def link gmiLinkStart Identifier
hi def link gmiLinkUrl Underlined
hi def link gmiLinkTitle String
hi def link gmiListItem Identifier
hi def link gmiQuoteLine Comment
hi def link gmiTodo Todo
