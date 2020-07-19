command! -nargs=1 BlistMove exe 'normal!' string(<args>) . 'G'
command! -nargs=1 BlistMoveView exe 'normal!' string(<args>) . 'Gzv^'

noremap <Plug>BlistMoveParent :BlistMoveView blist#movement#parent(line('.'))<CR>
noremap <Plug>BlistMoveChild :BlistMoveView blist#movement#child(line('.'))<CR>
noremap <Plug>BlistMovePrevious :BlistMoveView blist#movement#previous(line('.'))<CR>
noremap <Plug>BlistMoveNext :BlistMoveView blist#movement#next(line('.'))<CR>

if !hasmapto('<Plug>BlistMoveParent')
    map <buffer> <silent> zh <Plug>BlistMoveParent
endif

if !hasmapto('<Plug>BlistMoveChild')
    map <buffer> <silent> zl <Plug>BlistMoveChild
endif

if !hasmapto('<Plug>BlistMovePrevious')
    map <buffer> <silent> zk <Plug>BlistMovePrevious
endif

if !hasmapto('<Plug>BlistMoveNext')
    map <buffer> <silent> zj <Plug>BlistMoveNext
endif

function! blist#movement#parent(lnum)
    let l:start_indent = indent(a:lnum)
    let l:lnum = prevnonblank(a:lnum - 1)

    if l:start_indent <= 0
        return a:lnum
    endif

    while l:lnum > 0 && indent(l:lnum) >= l:start_indent
        let l:lnum = prevnonblank(l:lnum - 1)
    endwhile

    return l:lnum > 0 ? l:lnum : a:lnum
endfunction

function! blist#movement#child(lnum)
    let l:start_indent = indent(a:lnum)
    let l:lnum = nextnonblank(a:lnum + 1)

    if l:start_indent < 0
        return a:lnum
    endif

    return l:lnum > 0 && indent(l:lnum) > l:start_indent ? l:lnum : a:lnum
endfunction

function! blist#movement#previous(lnum)
    let l:start_indent = indent(a:lnum)
    let l:lnum = prevnonblank(a:lnum - 1)

    if l:start_indent < 0
        return a:lnum
    endif

    while l:lnum > 0 && indent(l:lnum) > l:start_indent
        let l:lnum = prevnonblank(l:lnum - 1)
    endwhile

    return l:lnum > 0 && indent(l:lnum) == l:start_indent ? l:lnum : a:lnum
endfunction

function! blist#movement#next(lnum)
    let l:start_indent = indent(a:lnum)
    let l:lnum = nextnonblank(a:lnum + 1)

    if l:start_indent < 0
        return a:lnum
    endif

    while l:lnum > 0 && indent(l:lnum) > l:start_indent
        let l:lnum = nextnonblank(l:lnum + 1)
    endwhile

    return l:lnum > 0 && indent(l:lnum) == l:start_indent ? l:lnum : a:lnum
endfunction
