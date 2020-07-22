" Fold behavior
setlocal foldenable
setlocal foldlevel=0
setlocal foldminlines=0
setlocal foldmethod=indent
setlocal foldtext=blist#fold#text(v:foldstart)

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

" Only save/load fold-view-state for a file
setlocal viewoptions=folds
augroup BLIST_VIEWS
    autocmd!
    autocmd BufWinLeave *.blist mkview
    autocmd BufWinEnter *.blist silent! loadview
augroup END

" Start a new bullet on newline, by treating them as comments
setlocal autoindent
setlocal comments=b:*,b:-,b:+
setlocal formatoptions=roj
setlocal indentexpr=blist#bullets#calcNewIndent()

" Check suffix for gf type commands
setlocal suffixesadd+=.blist
