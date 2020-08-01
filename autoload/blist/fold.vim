function! blist#fold#text(lnum)
    let l:indent = indent(prevnonblank(a:lnum - 1)) + 1
    return repeat(' ', l:indent) . '\--' . repeat(' ', winwidth(0))
endfunction

function! blist#fold#toggle(lnum)
    if foldclosed(nextnonblank(a:lnum + 1)) < 0
        call blist#fold#close(a:lnum)
    else
        call blist#fold#open(a:lnum)
    endif
endfunction

function! blist#fold#close(lnum)
    let l:child = blist#move#child(a:lnum)
    if l:child != a:lnum && foldclosed(l:child) <= 0
        exe string(l:child) . ',' . string(l:child) . 'foldclose'
    endif
endfunction

function! blist#fold#fullyClose(lnum)
    let l:child = blist#move#child(a:lnum)
    let l:last = prevnonblank(blist#move#last(a:lnum))
    if l:child != a:lnum && l:last >= l:child
        exe string(l:child) . ',' . string(l:last) . 'foldclose!'
        normal! zv
    endif
endfunction

function! blist#fold#open(lnum)
    let l:child = blist#move#child(a:lnum)
    if l:child != a:lnum && foldclosed(l:child) > 0
        exe string(l:child) . ',' . string(blist#move#last(a:lnum)) . 'foldopen'
    endif
endfunction

function! blist#fold#fullyOpen(lnum)
    let l:child = blist#move#child(a:lnum)
    let l:end = blist#move#last(a:lnum)

    if l:child == a:lnum || l:child == l:end
        return
    endif

    exe string(l:child) . ',' . string(l:end) . 'foldopen!'
endfunction

function! blist#fold#focus(lnum)
    " Close folds above
    let [l:prev, l:to_close] = [a:lnum, blist#move#prev(a:lnum)]
    let [l:prev_indent, l:indent] = [indent(l:prev), indent(l:to_close)]

    while l:to_close != l:prev
        " Except our ancestors (that would close us)
        if l:indent == l:prev_indent
            call blist#fold#close(l:to_close)
        endif

        let [l:prev, l:to_close] = [l:to_close, blist#move#prev(l:to_close)]
        let [l:prev_indent, l:indent] = [l:indent, indent(l:to_close)]
    endwhile

    " Close below
    let [l:prev, l:to_close] = [a:lnum, blist#move#next(a:lnum)]

    while l:to_close != l:prev
        call blist#fold#close(l:to_close)

        let [l:prev, l:to_close] = [l:to_close, blist#move#next(l:to_close)]
    endwhile
endfunction
