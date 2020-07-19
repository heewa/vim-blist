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

    " Check for children & that they're open
    if indent(l:lnum) > indent(a:lnum) && foldclosed(l:lnum) < 0
        exe string(l:lnum) . ',' . string(l:lnum) . 'foldclose'
    endif
endfunction

function! blist#fold#fullyClose(lnum)
    " Close in reverse, as we move up

    let l:prev = blist#move#next(a:lnum)
    if l:prev == a:lnum
        " We're near the end, just use last line
        let l:prev = prevnonblank(line('$'))
    endif

    let l:curr_indent = indent(l:prev)
    let l:curr = prevnonblank(l:prev - 1)
    while l:curr >= a:lnum
        let [l:prev_indent, l:curr_indent] = [l:curr_indent, indent(l:curr)]

        if l:curr_indent < l:prev_indent
            exe string(l:prev) . ',' . string(l:prev) . 'foldclose'
        endif

        let [l:prev, l:curr] = [l:curr, prevnonblank(l:curr - 1)]
    endwhile
endfunction

function! blist#fold#open(lnum)
    let l:lnum = nextnonblank(a:lnum + 1)

    " Check for children & that they're closed
    if indent(l:lnum) > indent(a:lnum) && foldclosed(l:lnum) >= 0
        exe string(l:lnum) . ',' . string(l:lnum) . 'foldopen'
    endif
endfunction

function! blist#fold#fullyOpen(lnum)
    let l:lnum = nextnonblank(a:lnum + 1)
    let l:indent = indent(l:lnum)
    let l:start_indent = indent(a:lnum)

    " Keep going until we're back to same lvl & higher
    while l:indent > l:start_indent
        if foldclosed(l:lnum) >= 0
            exe string(l:lnum) . ',' . string(l:lnum) . 'foldopen'
        endif

        let l:lnum = nextnonblank(l:lnum + 1)
        let l:indent = indent(l:lnum)
    endwhile
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
