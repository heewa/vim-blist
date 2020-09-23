if exists('*shiftwidth')
    function! blist#utils#shiftwidth()
        return shiftwidth()
    endfunc
else
    function! blist#utils#shiftwidth()
        return &sw
    endfunc
endif

" Given a col from getcurpos(), expand indents to translate to screen position
function! blist#utils#expandCol(col, indent)
    if a:indent <= 0
        return a:col
    endif

    let l:sw = blist#utils#shiftwidth()
    let l:indent_lvl = a:indent / l:sw

    if a:col <= l:indent_lvl
        return a:col * l:sw
    endif

    return a:col - l:indent_lvl + a:indent
endfunction
