let s:firstPosStrict = '^\s*[*+-]\s.'
let s:firstPosLoose = '^\s*\([*+-]\s\)\?.\?'

function! blist#baremove#right() abort
    return col('.') < col('$') - 1 ? 'l' : s:motionDown(line('.'), 0)
endfunction

function! blist#baremove#left() abort
    let l:pos = getcurpos()
    return l:pos[2] > matchend(getline(l:pos[1]), s:firstPosLoose) ?
        \ 'h' : s:motionUp(l:pos[1], '$')
endfunction

function! blist#baremove#down() abort
    return s:motionDown(line('.'), 0)
endfunction

function! blist#baremove#up() abort
    return s:motionUp(line('.'), 0)
endfunction

function! blist#baremove#start() abort
    return '^f l'
endfunction

function! blist#baremove#first() abort
    return '^w'
endfunction

"
" Private
"

function! s:motionUp(start, postfix)
    return s:motionTo(a:start, s:lineUp(a:start), a:postfix)
endfunction

function! s:motionDown(start, postfix)
    return s:motionTo(a:start, s:lineDown(a:start), a:postfix)
endfunction

function! s:motionTo(start, end, postfix)
    if a:end == a:start
        return ''
    endif

    return (a:end == a:start + 1 ? 'j' :
        \ a:end == a:start - 1 ? 'k' :
        \ string(a:end) . 'gg') .
        \ (empty(a:postfix) ? s:firstCol(a:end) : a:postfix)
endfunction

function! s:firstCol(lnum)
    " Handle broken bullet syntax by checking & using a safer motion.
    return match(getline(a:lnum), s:firstPosStrict) >= 0 ? '^ll' : '^'
endfunction

function! s:lineUp(lnum)
    let l:prev = prevnonblank(a:lnum - 1)
    if l:prev <= 0
        return a:lnum
    endif

    let l:fold_start = foldclosed(l:prev)
    return l:fold_start > 0 ? prevnonblank(l:fold_start - 1) : l:prev
endfunction

function! s:lineDown(lnum)
    let l:next = nextnonblank(a:lnum + 1)
    if l:next <= 0
        return a:lnum
    endif

    let l:fold_end = foldclosedend(l:next)
    return l:fold_end > 0 ? nextnonblank(l:fold_end + 1) : l:next
endfunction
