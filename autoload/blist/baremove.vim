function! blist#baremove#right() abort
    return col('.') < col('$') - 1 ? 'l' : s:down(line('.'), '^ll')
endfunction

function! blist#baremove#left() abort
    let l:pos = getcurpos()
    return l:pos[4] > indent(l:pos[1]) + 3 ? 'h' : s:up(l:pos[1], '$')
endfunction

function! blist#baremove#down() abort
    return s:down(line('.'), '^ll')
endfunction

function! blist#baremove#up() abort
    return s:up(line('.'), '^ll')
endfunction

function! blist#baremove#word() abort
    " This is bad, huh
    let l:lnum = line('.')
    return getline(l:lnum)[col('.')-1:] !~ '^\w*$' ?
        \ 'w' : s:down(l:lnum, '^w')
endfunction

function! blist#baremove#WORD() abort
    " This is bad, huh
    let l:lnum = line('.')
    return getline(l:lnum)[col('.')-1:] =~ '\s' ?
        \ 'W' : s:down(l:lnum, '^W')
endfunction

function! blist#baremove#wordEnd() abort
    " This is bad, huh
    let l:lnum = line('.')
    return getline(l:lnum)[col('.')-1:] =~ '\k\+$' ?
        \ 'e' : s:down(l:lnum, '^e')
endfunction

function! blist#baremove#WORDEnd() abort
    " This is bad, huh
    let l:lnum = line('.')
    return getline(l:lnum)[col('.')-1:] =~ '\w\+$' ?
        \ 'e' : s:down(l:lnum, '^e')
endfunction

function! blist#baremove#back() abort
    " This is bad, huh
    let l:lnum = line('.')
    return getline(l:lnum)[:col('.')] =~ '^\s*\S\s\+' ?
        \ 'b' : s:up(l:lnum, '$b')
endfunction

function! blist#baremove#BACK() abort
    " This is bad, huh
    let l:lnum = line('.')
    return getline(l:lnum)[:col('.')] =~ '^\s*\S\s\+' ?
        \ 'b' : s:up(l:lnum, '$b')
endfunction

function! blist#baremove#backEnd() abort
    " This is bad, huh
    let l:lnum = line('.')
    return getline(l:lnum)[:col('.')] =~ '^\s*\S\s\+' ?
        \ 'ge' : s:up(l:lnum, '$ge')
endfunction

function! blist#baremove#BACKEnd() abort
    " This is bad, huh
    let l:lnum = line('.')
    return getline(l:lnum)[:col('.')] =~ '^\s*\S\s\+' ?
        \ 'ge' : s:up(l:lnum, '$ge')
endfunction

function! blist#baremove#start() abort
    return '^ll'
endfunction

function! blist#baremove#first() abort
    return '^w'
endfunction

"
" Private
"

function! s:up(lnum, postfix)
    let l:prev = prevnonblank(a:lnum - 1)
    let l:fold_start = foldclosed(l:prev)
    let l:prev = l:fold_start > 0 ? prevnonblank(l:fold_start - 1) : l:prev

    return l:prev == a:lnum - 1 ? 'k' . a:postfix : l:prev < a:lnum ? string(l:prev) . 'gg' . a:postfix : ''
endfunction

function! s:down(lnum, postfix)
    let l:next = nextnonblank(a:lnum + 1)
    let l:fold_end = foldclosedend(l:next)
    let l:next = l:fold_end > 0 ? nextnonblank(l:fold_end + 1) : l:next

    return l:next == a:lnum + 1 ? 'j' . a:postfix : l:next > a:lnum ? string(l:next) . 'gg' . a:postfix : ''
endfunction
