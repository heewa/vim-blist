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
        return "m`" . blist#move#nextSibling(l:lnum) . "gg]P'`"
    endif
endfunction

function! blist#modify#pasteBefore()
    return getregtype(v:register) == 'V' ? ']P' : 'p'
endfunction
