" Toggle fold
nnoremap <buffer> <silent> za :call BlistToggleFold_Nextline(line('.'))<CR>

" Toggle complete
nnoremap <buffer> <silent> z<Space> :s/^\(\s*\)\([*-]\)/\=submatch(1) . {'*': '-', '-': '*'}[submatch(2)]/<CR>

command -nargs=1 BlistMove exe 'normal' string(<args>) . 'G^'

" Movements
noremap <buffer> <silent> zh :BlistMove BlistParent(line('.'), 0)<CR>
noremap <buffer> <silent> zth :BlistMove BlistParent(line('.'), 1)<CR>
noremap <buffer> <silent> zl :BlistMove BlistChild(line('.'), 0)<CR>
noremap <buffer> <silent> ztl :BlistMove BlistChild(line('.'), 1)<CR>
noremap <buffer> <silent> zk :BlistMove BlistPrevious(line('.'), 0)<CR>
noremap <buffer> <silent> ztk :BlistMove BlistPrevious(line('.'), 1)<CR>
noremap <buffer> <silent> zj :BlistMove BlistNext(line('.'), 0)<CR>
noremap <buffer> <silent> ztj :BlistMove BlistNext(line('.'), 1)<CR>

" TODO: delete, with children
" TODO: yank, with children
" TODO: paste, as next sibling
" TODO: paste, as previous sibling

" TODO: swap with previous sibling
" TODO: swap with next sibling

" TODO: search for @person & #tag
" TODO: goto @-def (@@label) & #-def (##label)

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
