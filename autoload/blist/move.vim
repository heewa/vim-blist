function! blist#move#parent(lnum)
    let l:start_indent = indent(a:lnum)
    if l:start_indent <= 0
        return a:lnum
    endif

    let [l:lnum, l:indent] = s:findPrev(a:lnum, l:start_indent)
    while l:lnum > 0 && l:indent >= l:start_indent
        let [l:lnum, l:indent] = s:findPrev(l:lnum, l:indent)
    endwhile

    return l:lnum > 0 ? l:lnum : a:lnum
endfunction

function! blist#move#child(lnum)
    let l:start_indent = indent(a:lnum)
    if l:start_indent < 0
        return a:lnum
    endif

    let l:lnum = nextnonblank(a:lnum + 1)
    let l:indent = indent(l:lnum)

    return l:lnum > 0 && l:indent > l:start_indent ? l:lnum : a:lnum
endfunction

function! blist#move#prevSibling(lnum)
    let l:start_indent = indent(a:lnum)
    let [l:lnum, l:indent] = s:findPrev(a:lnum, l:start_indent)

    return l:lnum > 0 && l:indent == l:start_indent ? l:lnum : a:lnum
endfunction

function! blist#move#nextSibling(lnum)
    let l:start_indent = indent(a:lnum)
    let [l:lnum, l:indent] = s:findNext(a:lnum, l:start_indent)

    return l:lnum > 0 && l:indent == l:start_indent ? l:lnum : a:lnum
endfunction

" prevSibling or parent
function! blist#move#prev(lnum)
    let l:start_indent = indent(a:lnum)
    let [l:lnum, l:indent] = s:findPrev(a:lnum, l:start_indent)

    return l:lnum > 0 && l:indent <= l:start_indent ? l:lnum : a:lnum
endfunction

" nextSibling or parent's nextSibling
function! blist#move#next(lnum)
    let l:start_indent = indent(a:lnum)
    let [l:lnum, l:indent] = s:findNext(a:lnum, l:start_indent)

    return l:lnum > 0 && l:indent <= l:start_indent ? l:lnum : a:lnum
endfunction

function! s:findPrev(lnum, indent)
    if a:indent < 0
        return a:lnum
    endif

    let l:lnum = prevnonblank(a:lnum - 1)
    let l:indent = indent(l:lnum)

    while l:lnum > 0 && l:indent > a:indent
        let l:lnum = prevnonblank(l:lnum - 1)
        let l:indent = indent(l:lnum)
    endwhile

    return [l:lnum, l:indent]
endfunction

function! s:findNext(lnum, indent)
    if a:indent < 0
        return a:lnum
    endif

    let l:lnum = nextnonblank(a:lnum + 1)
    let l:indent = indent(l:lnum)

    while l:lnum > 0 && l:indent > a:indent
        let l:lnum = nextnonblank(l:lnum + 1)
        let l:indent = indent(l:lnum)
    endwhile

    return [l:lnum, l:indent]
endfunction
