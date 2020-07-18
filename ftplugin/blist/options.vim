set foldenable

" Tabs
setlocal shiftwidth=0
setlocal softtabstop=0
setlocal tabstop=4
setlocal noexpandtab

" Wrap, indenting to align with item content
setlocal wrap
setlocal breakindent
setlocal breakindentopt=shift:2
setlocal linebreak

" Start a new bullet on newline, by treating them as comments
setlocal autoindent
setlocal comments=b:*,b:-,b:+
setlocal formatoptions=roj
