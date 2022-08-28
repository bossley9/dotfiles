" Vim syntax file
" Language:    Gemini Text
" Maintainer:  Byron Torres (@torresjrjr) <b@torresjrjr.com>
" Last Change: 2022-08-27
" Filenames:   *.{gemini,gmi}
" URL:         https://git.sr.ht/~torresjrjr/gemini.vim
" Modified by Sam Bossley

if exists("b:current_syntax")
	finish
endif

" Matches
syn match link_prefix    /^=>\s*/    nextgroup=link
syn match link           /\S*/       nextgroup=link_comment contained
syn match link_comment   /.*$/       contained

syn match heading_prefix /^##\?#\?/  nextgroup=heading_text
syn match heading_text   /.*$/       contained

syn match pre_toggle     /^```.*/    contained

syn match unordered_list /^*.*/
syn match blockquote     /^>.*/

syn match completed_box  /^-\s\[x\].*/

" Regions
syn region pre_block   start=/^```/ end=/^```/ fold contains=pre_toggle keepend

" Highlighting
let b:current_syntax = "gemini"

hi def link  link_prefix    Underlined
hi def link  link           Underlined
hi def link  link_comment   Constant

hi def link  pre_block      PreProc
hi def link  pre_toggle     Comment

hi def link  heading_prefix Special
hi def link  heading_text   Constant

hi def link  unordered_list Statement
hi def link  blockquote     Comment

hi def link completed_box   Comment
