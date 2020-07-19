function! blist#fold#text(lnum)
    let l:indent = indent(a:lnum - 1) + 1
    return repeat(' ', l:indent) . '\--' . repeat(' ', winwidth(0))
endfunction

function! blist#fold#toggle(lnum)
    if foldclosed(a:lnum + 1) < 0
        call blist#fold#close(a:lnum)
    else
        call blist#fold#open(a:lnum)
    endif
endfunction

function! blist#fold#close(lnum)
    if indent(a:lnum) >= indent(a:lnum + 1) || foldclosed(a:lnum + 1) >= 0
        " No children or fold already closed
        return
    else
        silent normal! jzck
    endif
endfunction

function! blist#fold#open(lnum)
    if indent(a:lnum) >= indent(a:lnum + 1)
        " No children
        return
    else
        silent normal! jzok
    endif
endfunction

function! blist#fold#focus(lnum)
    " Close folds above
    "   * sweep up & left, closing as we go, until we hit root
    let l:prev = a:lnum
    let l:to_close = blist#move#prevSibling(l:prev)
    while l:to_close != l:prev && indent(l:to_close) > 0
        call blist#fold#close(l:to_close)
        let l:prev = l:to_close
        let l:to_close = blist#move#prevSibling(l:prev)
    endwhile

    "   * then just close folds from there to top
    if l:to_close > 1
        silent exe '1,' . string(l:to_close - 1) . 'foldclose'
    endif

    " Repeat below
    "   * sweep down & left, closing as we go, until we hit root
    let l:prev = a:lnum
    let l:to_close = blist#move#nextSibling(l:prev)
    while l:to_close != l:prev && indent(l:to_close) > 0
        call blist#fold#close(l:to_close)
        let l:prev = l:to_close
        let l:to_close = blist#move#nextSibling(l:prev)
    endwhile

    "   * then just close folds from there to bottom
    if l:to_close != l:prev
        silent exe string(l:to_close) . ',$foldclose'
    endif
endfunction
