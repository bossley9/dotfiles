vim.cmd([[

let s:formatting_enabled = 1

fu! g:SetFormat(value)
  let s:formatting_enabled = a:value
endfunction

com! -nargs=0 FormatOn call g:SetFormat(1)
com! -nargs=0 FormatOff call g:SetFormat(0)

fu! g:Format()
  let ft = &ft
  " step 1: silently format the file in place (silent !cmd expand(%:p))
  if ft == "c" || ft =="cpp"
    exe 'silent !clang-format -i ' . expand('%:p')
  elseif ft == "go"
    exe 'silent !gofmt -w ' . expand('%:p')
  elseif ft == "kotlin"
    exe 'silent !ktlint -F ' . expand('%:p')
  elseif ft == "nix"
    exe 'silent !nixpkgs-fmt ' . expand('%:p')
  elseif ft == "rust"
    exe 'silent !rustfmt ' . expand('%:p')
  en
  " step 2: reload formatting changes
  e
  " step 3: reload syntax highlighting
  redraw
  " step 4: reopen the currently closed fold
  norm! zv
endfunction

augroup formatter
  au!
  au BufWritePost * if s:formatting_enabled | call g:Format() | en
augroup end

]])
