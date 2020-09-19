function! blist#modify#pasteAfter()
    if getregtype(v:register) !=  'V' 
        return 'p'
    endif

    let l:lnum = line('.')
    let l:indent = indent(l:lnum)

    let l:next = nextnonblank(l:lnum + 1)
    let l:indent_next = indent(l:next)

    let l:foldend = foldclosedend(l:next)
    let l:after = nextnonblank(l:foldend + 1)
    let l:indent_after = indent(l:after)

    if l:next <= 0 || l:indent >=  l:indent_next
        " With no children, regular is fine
        return ']p'
    elseif  l:foldend <= 0
        " With open children, paste as child by pasting before the first child
        return 'j]P'
    elseif l:indent_after == l:indent
        " With closed children and a next sibling, insert as a sibling before
        " next
        return l:after . 'G]P'
    else
        " No sibling, insert a temp one to anchor the paste, then remove
        "call insert(l:after, repeat("\t", indent(l:lnum) / s:shiftwidth()) .. '* ')
        let @9 = repeat("\t", l:indent / s:shiftwidth()) . '* '
        return l:after . "GO\<C-u>\<C-r>\9\<Esc>]pkdd"
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
