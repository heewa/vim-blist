function! blist#bullets#toggleComplete()
    let l:orig_pos = getcurpos()

    s/
        \^\(\s*\)\([*-]\)/
        \\=submatch(1) . {'*': '-', '-': '*'}[submatch(2)]/

    call setpos('.', l:orig_pos)
endfunction

function! blist#bullets#fixIndent() range
    let l:prev = prevnonblank(a:firstline - 1)
    let l:prev_indent = indent(l:prev)

    let l:curr = a:firstline
    let l:curr_indent = indent(l:curr)

    while l:curr <= a:lastline
        if l:curr_indent > l:prev_indent + s:shiftwidth()
    endwhile
endfunction

function! blist#bullets#indent() range
    " Don't indent if it would leave first line without parent
    let l:prev = prevnonblank(a:firstline - 1)
    if a:firstline > 1 && l:prev > 0 && indent(a:firstline) > indent(l:prev)
        return -1
    endif

    " Don't indent if a full subtree isn't selected
    if !s:isFullSubtree(a:firstline, a:lastline)
        return
    endif

    exe string(a:firstline) . ',' . string(a:lastline) . '>'
endfunction

function! blist#bullets#unIndent() range
    let l:before_first = prevnonblank(a:firstline - 1)
    let l:before_indent = l:before_first > 0 ? indent(l:before_first) : -1
    let l:after_last = nextnonblank(a:lastline + 1)
    let l:after_indent = l:after_last > 0 ? indent(l:after_last) : -1

    let l:least_indent = s:oldestInRange(a:firstline, a:lastline)

    exe string(a:firstline) . ',' . string(a:lastline) . '<'

    " Besides unindenting, check if we need to move to be our previous
    " parent's next sibling
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

if exists('*shiftwidth')
    function! s:shiftwidth()
        return shiftwidth()
    endfunc
else
    function! s:shiftwidth()
        return &sw
    endfunc
endif

function! s:isFullSubtree(start, end)
    let l:start_indent = indent(a:start)
    let l:curr = nextnonblank(a:start + 1)

    " All lines must be no less indented than the 1st
    while l:curr <= a:end
        if indent(l:curr) < l:start_indent
            return 0
        endif
    endwhile

    " There must not be any children remaining outside
    if indent(nextnonblank(l:curr + 1)) > l:start_index
        return 0
    endif

    " Multiple-root subtrees (forests?) of the same lvl are fine

    return 1
endfunction

function! s:oldestInRange(start, end)
    let l:oldest_line = a:start
    let l:oldest_indent = indent(a:start)
    let l:curr_line = nextnonblank(a:start + 1)

    while l:curr_line <= a:end
        let l:curr_indent = indent(l:curr_line)

        if l:curr_indent < l:oldest_indent
            let l:oldest_line = l:curr_line
            let l:oldest_indent = l:curr_indent
        endif

        let l:curr_line = nextnonblank(l:curr_line + 1)
    endwhile

    return [l:oldest_line, l:oldest_indent]
endfunction
