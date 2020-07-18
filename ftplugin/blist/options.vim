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
setlocal indentexpr=BlistCalcNewBulletIndent()

" Indent a new bullet as a child if there are any, otherwise
" as a sibling.
"
" NOTE: For some reason <SID> doesn't work in 'indentexpr'
function! BlistCalcNewBulletIndent()
    let l:curr = indent(v:lnum)
    let l:next = indent(v:lnum + 1)
    return l:curr > l:next ? l:curr : l:next
endfunction
