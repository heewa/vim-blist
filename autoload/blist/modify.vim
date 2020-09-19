function! blist#modify#pasteAfter()
    if getregtype(v:register) !=  'V' 
        return 'p'
    endif

    let l:lnum = line('.')
    let l:next_lnum = nextnonblank(l:lnum + 1)
    if l:next_lnum <= 0 || indent(l:lnum) >=  indent(l:next_lnum)
        " With no children, regular is fine
        return ']p'
    elseif  foldclosed(l:next_lnum) <= 0
        " With open children, paste as child
        return "m`j]P'`"
    else
        " With closed children, paste as next sibling
        return "m`" .
            \ blist#move#next(l:lnum) .
            \ "gg]P'`" .
            \ blist#move#nextSibling(l:lnum) .
            \ "gg"
    endif
endfunction

function! blist#modify#pasteBefore()
    return getregtype(v:register) == 'V' ? ']P' : 'P'
endfunction

function! blist#modify#newlineAfter()
    let l:lnum = line('.')
    let l:foldend = foldclosedend(l:lnum + 1)
    if l:foldend <= 0
        return 'o'
    else
        call append(l:foldend, repeat("\t", indent(l:lnum) / s:shiftwidth()) .. '* ')
        return (l:foldend + 1) . 'GA'
    endif
endfunction

if exists('*shiftwidth')
    function! s:shiftwidth()
        return shiftwidth()
    endfunc
else
    function! s:shiftwidth()
        return &sw
    endfunc
endif
