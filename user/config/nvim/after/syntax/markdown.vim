" Vim syntax file
" Language:     Markdown (customized)
" Maintainer:   Sam Bossley <sam@bossley.xyz>
" Filenames:    *.{markdown,md}
" Last Change:  2022 Sep 24

if exists("b:current_syntax") && b:current_syntax == 'markdown_customized'
	finish
endif
unlet! b:current_syntax

syn match completed_box     /^-\s\[x\].*/
syn keyword genericTodo     FIXME NOTE TODO OPTIMIZE XXX HACK TEMP containedin=mkdNonListItemBlock,mkdListItemLine

hi def link completed_box   Comment
hi def link genericTodo     Todo

hi mkdHeading               ctermfg=5
hi markdownH1               ctermfg=5
hi mkdListItemLine          ctermfg=4
hi markdownLinkText         ctermfg=5
hi markdownUrl              ctermfg=81 cterm=underline

setl commentstring=-\ [\ ]\ %s
setl nofoldenable
let b:current_syntax = "markdown_customized"
