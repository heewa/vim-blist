function! blist#bullets#toggleComplete()
    let l:orig_pos = getcurpos()

    s/
        \^\(\s*\)\([*+-]\)/
        \\=submatch(1) . {'*': '-', '+': '-', '-': '*'}[submatch(2)]/

    call setpos('.', l:orig_pos)
endfunction

function! blist#bullets#toggleIncomplete()
    let l:orig_pos = getcurpos()

    s/
        \^\(\s*\)\([*+-]\)/
        \\=submatch(1) . {'*': '+', '-': '+', '+': '*'}[submatch(2)]/

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

function! blist#bullets#indent(lnum)
    " Don't indent if it would leave first line without parent
    let l:prev = blist#move#prev(a:lnum)
    if a:lnum > 1 && l:prev > 0 && indent(a:lnum) > indent(l:prev)
        return -1
    endif

    let l:end = blist#move#end(a:lnum)
    exe string(a:lnum) . ',' . string(l:end) . '>'
endfunction

function! blist#bullets#unIndent(lnum)
    let l:parent = blist#move#parent(a:lnum)
    let l:end = blist#move#end(a:lnum)

    if l:parent <= 0 || l:parent == a:lnum
        return -1
    endif

    " Unindent by moving entire subtree of item to after the end of parent
    let l:parent_end = blist#move#end(l:parent)
    let l:dest = l:parent_end > 0 ? l:parent_end : line('$')

    silent! exe string(a:lnum) . ',' . string(l:end) . '<'

    if l:dest > l:end
        silent! exe string(a:lnum) . ',' . string(l:end) .
            \ 'move' string(l:dest)
    endif

    " The move cmd places cursor on the last line, so move it up to the 1st,
    " where we started
    silent! exe 'normal!' string(a:lnum - l:end + 1) . '-'
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
