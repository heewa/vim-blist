"
" Commands
"

command! -range BlistIndent exe <SID>GetIndentCommand(<line1>, <line2>)

"
" Plug Mappings
"

nnoremap <silent> <Plug>BlistIndent :BlistIndent<CR>
vnoremap <silent> <Plug>BlistIndent :BlistIndent<CR>

nnoremap <silent> <Plug>BlistToggleFold :call <SID>ToggleFold(line('.'))<CR>
nnoremap <silent> <Plug>BlistOpenFold :call <SID>OpenFold(line('.'))<CR>
nnoremap <silent> <Plug>BlistCloseFold :call <SID>CloseFold(line('.'))<CR>

nnoremap <silent> <Plug>BlistDelete :BlistDelete<CR>

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

function! s:ToggleFold(lnum)
    if foldclosed(a:lnum + 1) < 0
        call s:CloseFold(a:lnum)
    else
        call s:OpenFold(a:lnum)
    endif
endfunction

function! s:CloseFold(lnum)
    if indent(a:lnum) >= indent(a:lnum + 1) || foldclosed(a:lnum + 1) >= 0
        " No children or fold already closed
        return
    else
        silent normal! jzck
    endif
endfunction

function! s:OpenFold(lnum)
    if indent(a:lnum) >= indent(a:lnum + 1)
        " No children
        return
    else
        silent normal! jzok
    endif
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
    let l:to_close = blist#movement#previous(l:prev)
    while l:to_close != l:prev && indent(l:to_close) > 0
        call BlistClose(l:to_close, 0)
        let l:prev = l:to_close
        let l:to_close = blist#movement#previous(l:prev)
    endwhile

    "   * then just close folds from there to top
    if l:to_close > 1
        silent exe '1,' . string(l:to_close - 1) . 'foldclose'
    endif

    " Repeat below
    "   * sweep down & left, closing as we go, until we hit root
    let l:prev = a:lnum
    let l:to_close = blist#movement#next(l:prev)
    while l:to_close != l:prev && indent(l:to_close) > 0
        call BlistClose(l:to_close, 0)
        let l:prev = l:to_close
        let l:to_close = blist#movement#next(l:prev)
    endwhile

    "   * then just close folds from there to bottom
    if l:to_close != l:prev
        silent exe string(l:to_close) . ',$foldclose'
    endif
endfunction
