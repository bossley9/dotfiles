" Playlist syntax file
" Maintainer:  Sam Bossley
" Last Change: 2022-09-04
" Filenames:   *.m3u

if exists("b:current_syntax")
	finish
endif

syn match song_path /^.\{-}\s/
syn match line_comment /#.*$/

hi def link song_path    Constant
hi def link line_comment Comment

setl commentstring=#\ %s

let b:current_syntax = "m3u"
