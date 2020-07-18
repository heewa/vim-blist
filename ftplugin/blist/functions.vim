function! BlistIndent() range
    " Don't indent if doing so would leave first line without parent
    if a:firstline > 1 && indent(a:firstline) > indent(a:firstline - 1)
        return
    endif

    " Find least indented so we can include all the children of all items
    " in this range
    let l:lnum = a:firstline
    let l:indent = indent(l:lnum)
    while l:lnum < a:lastline
        let l:lnum += 1
        let l:indent = min([l:indent, indent(l:lnum)])
    endwhile

    " Continue down to find end of tree
    while indent(l:lnum + 1) > l:indent 
        let l:lnum += 1
    endwhile

    silent exe string(a:firstline) . ',' . string(l:lnum) . '>'
endfunction

function! BlistToggleFold_Nextline(lnum)
    let l:curr_indent = indent(a:lnum)
    let l:next_indent = indent(a:lnum + 1)

    if foldclosed(a:lnum) >= 0
        " The line we're on is a closed fold, which isn't meant to be used
        " for this, but let's open it
        silent normal! zok
        "silent exe string(a:lnum) . ',' . string(a:lnum) . 'foldopen'
    elseif l:curr_indent < l:next_indent
        let l:close_start = foldclosed(a:lnum + 1)

        if l:close_start < 0 && indent(a:lnum + 2) > l:curr_indent
            " Only attempt to close multi-line children
            silent normal! jzck
        elseif l:close_start >= 0
            " Open the fold
            silent normal! jzok
        endif
    endif
endfunction

function! BlistNext(lnum, to_before)
    let l:start_indent = indent(a:lnum)
    let l:lnum = a:lnum + 1
    let l:indent = indent(l:lnum)

    while l:indent >= 0 && l:indent > l:start_indent
        let l:lnum += 1
        let l:indent = indent(l:lnum)
    endwhile

    " TODO: everything's broken :( I should do this while sober
    if l:indent < 0 || a:to_before && l:indent >= l:start_indent
        let l:lnum -= 1
    endif

    return l:lnum
endfunction

function! BlistPrevious(lnum, to_before)
    let l:start_indent = indent(a:lnum)
    let l:lnum = a:lnum - 1
    let l:indent = indent(l:lnum)

    while l:indent >= 0 && l:indent > l:start_indent
        let l:lnum -= 1
        let l:indent = indent(l:lnum)
    endwhile

    if l:indent < 0 || a:to_before && l:indent <= l:start_indent
        let l:lnum += 1
    endif

    return l:lnum
endfunction

function! BlistParent(lnum, to_before)
    let l:start_indent = indent(a:lnum)
    let l:lnum = a:lnum - 1
    let l:indent = indent(l:lnum)

    while l:indent >= 0 && l:indent >= l:start_indent
        let l:lnum -= 1
        let l:indent = indent(l:lnum)
    endwhile

    if a:to_before && l:indent >= 0 && l:indent < l:start_indent
        return l:lnum + 1
    endif

    return l:indent >= 0 && l:indent < l:start_indent ? l:lnum : a:lnum
endfunction

function! BlistChild(lnum, to_end)
    let l:start_indent = indent(a:lnum)
    let l:lnum = a:lnum + 1
    let l:indent = indent(l:lnum)

    while a:to_end && l:indent > l:start_indent
        let l:lnum += 1
        let l:indent = indent(l:lnum)
    endwhile

    if l:indent >= 0 && l:indent <= l:start_indent
        let l:line -= 1
    endif

    return l:line
endfunction

function! BlistClose(lnum, all)
    " This should be called on an item, not its children, but it might
    " be anyway?
    if foldclosed(a:lnum) >= 0 || foldclosed(a:lnum + 1) >= 0
        return
    endif

    silent exe
        \ string(a:lnum + 1) . ',' . string(a:lnum + 1) .
        \ 'foldclose' . (a:all ? '!' : '')
endfunction

function! BlistFocus(lnum)
    " Close folds above
    "   * sweep up & left, closing as we go, until we hit root
    let l:prev = a:lnum
    let l:to_close = BlistPrevious(l:prev, 0)
    while l:to_close != l:prev && indent(l:to_close) > 0
        call BlistClose(l:to_close, 0)
        let l:prev = l:to_close
        let l:to_close = BlistPrevious(l:prev, 0)
    endwhile

    "   * then just close folds from there to top
    if l:to_close > 1
        silent exe '1,' . string(l:to_close - 1) . 'foldclose'
    endif

    " Repeat below
    "   * sweep down & left, closing as we go, until we hit root
    let l:prev = a:lnum
    let l:to_close = BlistNext(l:prev, 0)
    while l:to_close != l:prev && indent(l:to_close) > 0
        call BlistClose(l:to_close, 0)
        let l:prev = l:to_close
        let l:to_close = BlistNext(l:prev, 0)
    endwhile

    "   * then just close folds from there to bottom
    if l:to_close != l:prev
        silent exe string(l:to_close) . ',$foldclose'
    endif
endfunction
