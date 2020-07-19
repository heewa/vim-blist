function! blist#bullets#toggleComplete()
    let l:orig_pos = getcurpos()

    s/
        \^\(\s*\)\([*-]\)/
        \\=submatch(1) . {'*': '-', '-': '*'}[submatch(2)]/

    call setpos('.', l:orig_pos)
endfunction

function! blist#bullets#indent() range
    let l:lastline = s:FindIndentEnd(a:firstline, a:lastline)

    if l:lastline >= 0
        exe 'normal!' string(a:firstline) . ',' . string(l:lastline) . '>'
    endif
endfunction

" Indent a new bullet as a child if there are any, otherwise as a sibling.
function! blist#bullets#calcNewIndent()
    let l:curr = indent(v:lnum)
    let l:next = indent(nextnonblank(v:lnum + 1))
    return l:curr > l:next ? l:curr : l:next
endfunction

"
" Private
"

" Find the end line to be indented from a range, or -1 if it's
" an invalid indent.
function! s:FindIndentEnd(first_line, last_line)
    " Don't indent if doing so would leave first line without parent
    if a:first_line > 1 &&
            \indent(a:first_line) > indent(prevnonblank(a:first_line - 1))
        return -1
    endif

    " Find least indented so we can include all the children of all items
    " in this range
    let l:lnum = a:first_line
    let l:indent = indent(l:lnum)
    while l:lnum < a:last_line
        let l:lnum = nextnonblank(l:lnum + 1)
        let l:indent = min([l:indent, indent(l:lnum)])
    endwhile

    " Continue down to find end of tree
    let l:next = nextnonblank(l:lnum + 1)
    while indent(l:next) > l:indent
        let [l:lnum, l:next] = [l:next, nextnonblank(l:next + 1)]
    endwhile

    return l:lnum
endfunction
