"
" Commands
"

" Move cursor to bullet on given line
command -nargs=1 BlistMove exe 'normal' string(<args>) . 'G^'

command -range BlistIndent exe <SID>GetIndentCommand(<line1>, <line2>)

"
" Plug Mappings
"

nnoremap <silent> <Plug>BlistIndent :BlistIndent<CR>
vnoremap <silent> <Plug>BlistIndent :BlistIndent<CR>

"
" Private Functions
"

function! BlistToggleComplete()
    let l:orig_pos = getcurpos()

    s/
        \^\(\s*\)\([*-]\)/
        \\=submatch(1) . {'*': '-', '-': '*'}[submatch(2)]/

    call setpos('.', l:orig_pos)
endfunction

" Find the end line to be indented from a range, or -1 if it's
" an invalid indent.
function! s:FindIndentEnd(first_line, last_line)
    " Don't indent if doing so would leave first line without parent
    if a:first_line > 1 && indent(a:first_line) > indent(a:first_line - 1)
        return -1
    endif

    " Find least indented so we can include all the children of all items
    " in this range
    let l:lnum = a:first_line
    let l:indent = indent(l:lnum)
    while l:lnum < a:last_line
        let l:lnum += 1
        let l:indent = min([l:indent, indent(l:lnum)])
    endwhile

    " Continue down to find end of tree
    while indent(l:lnum + 1) > l:indent 
        let l:lnum += 1
    endwhile

    return l:lnum
endfunction

function! s:GetIndentCommand(...)
    let l:first_line = get(a:, 1, line('.'))
    let l:last_line = s:FindIndentEnd(
        \l:first_line,
        \get(a:, 2, l:first_line))

    if l:last_line < 0
        return ''
    endif

    return string(l:first_line) . ',' . string(l:last_line) . '>'
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
