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
    let l:lnum = nextnonblank(a:lnum + 1)
    return l:lnum > 0 && indent(l:lnum) > indent(a:lnum) ? l:lnum : a:lnum
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

" Return last line of this subtree.
"   - If starting on a non-bullet line, including blanks, treat it as the entire tree.
"   - Treat blank lines as part of tree, ignoring indent.
"   - Treat 0-indent-lvl non-bullet lines as having the same indent-lvl of
"     previous bullet line, to favor pasted text.
"   - Treat indented non-bullet lines as if they had a bullet on the first
"     non-blank char, to favor bullet corruption (eg, from a substitute).
function! blist#move#last(lnum)
    let l:lnum = a:lnum
    let l:line = getline(l:lnum)
    let l:is_blank = match(l:line, '^\s*$') >= 0
    let l:has_bullet = !l:is_blank && match(l:line, '^\s*[*+-]') >= 0

    if l:is_blank || !l:has_bullet
        return a:lnum
    endif

    let l:start_indent = indent(a:lnum)
    let l:last = line('$')
    let l:indent = l:start_indent + 1

    while l:lnum <= l:last && (
            \ l:is_blank ||
            \ l:indent > l:start_indent ||
            \ !l:has_bullet && l:indent == 0)
        let l:lnum += 1
        let l:line = getline(l:lnum)
        let l:is_blank = match(l:line, '^\s*$') >= 0
        let l:has_bullet = !l:is_blank && match(l:line, '^\s*[*+-]') >= 0

        " Blanks & zero-indent non-bullets are treated as indented at previous
        " level.
        let l:indent = l:is_blank || (!l:has_bullet && l:indent == 0) ?
            \ l:indent : indent(l:lnum)
    endwhile

    return l:lnum - 1
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
