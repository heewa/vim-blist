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
    let l:lnum = nextnonblank(a:lnum + 1)

    if indent(a:lnum) >= indent(l:lnum) || foldclosed(l:lnum) >= 0
        " No children or fold already closed
        return
    else
        exe string(l:lnum) . ',' . string(l:lnum) . 'foldclose'
    endif
endfunction

function! blist#fold#open(lnum)
    let l:lnum = nextnonblank(a:lnum + 1)

    if indent(a:lnum) >= indent(l:lnum)
        " No children
        return
    else
        exe string(l:lnum) . ',' . string(l:lnum) . 'foldopen'
    endif
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
