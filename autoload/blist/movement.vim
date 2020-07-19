function! blist#movement#parent(lnum)
    let l:start_indent = indent(a:lnum)
    let l:lnum = prevnonblank(a:lnum - 1)

    if l:start_indent <= 0
        return a:lnum
    endif

    while l:lnum > 0 && indent(l:lnum) >= l:start_indent
        let l:lnum = prevnonblank(l:lnum - 1)
    endwhile

    return l:lnum > 0 ? l:lnum : a:lnum
endfunction

function! blist#movement#child(lnum)
    let l:start_indent = indent(a:lnum)
    let l:lnum = nextnonblank(a:lnum + 1)

    if l:start_indent < 0
        return a:lnum
    endif

    return l:lnum > 0 && indent(l:lnum) > l:start_indent ? l:lnum : a:lnum
endfunction

function! blist#movement#previous(lnum)
    let l:start_indent = indent(a:lnum)
    let l:lnum = prevnonblank(a:lnum - 1)

    if l:start_indent < 0
        return a:lnum
    endif

    while l:lnum > 0 && indent(l:lnum) > l:start_indent
        let l:lnum = prevnonblank(l:lnum - 1)
    endwhile

    return l:lnum > 0 && indent(l:lnum) == l:start_indent ? l:lnum : a:lnum
endfunction

function! blist#movement#next(lnum)
    let l:start_indent = indent(a:lnum)
    let l:lnum = nextnonblank(a:lnum + 1)

    if l:start_indent < 0
        return a:lnum
    endif

    while l:lnum > 0 && indent(l:lnum) > l:start_indent
        let l:lnum = nextnonblank(l:lnum + 1)
    endwhile

    return l:lnum > 0 && indent(l:lnum) == l:start_indent ? l:lnum : a:lnum
endfunction
