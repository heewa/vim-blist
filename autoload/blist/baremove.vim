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

function! blist#baremove#firstCol(lnum)
    " Handle broken bullet syntax by checking & using a safer motion.
    return match(getline(a:lnum), s:firstPosStrict) >= 0 ? '^ll' : '^'
endfunction

"
" Private
"

function! s:motionUp(start, postfix)
    let l:end = s:lineUp(a:start)
    return s:motionTo(a:start, l:end) .
        \ (type(a:postfix) == v:t_string ? a:postfix : blist#baremove#firstCol(l:end))
endfunction

function! s:motionDown(start, postfix)
    let l:end = s:lineDown(a:start)
    return s:motionTo(a:start, l:end) .
        \ (type(a:postfix) == v:t_string ? a:postfix : blist#baremove#firstCol(l:end))
endfunction

function! s:motionTo(start, end)
    return a:end == a:start ? '' :
        \ a:end == a:start + 1 ? 'j' :
        \ a:end == a:start - 1 ? 'k' :
        \ a:end <= 0 ? 'gg' :
        \ a:end >= line('$') ? 'G' :
        \ string(a:end) . 'gg'
endfunction

function! s:lineUp(lnum)
    " Ignore blanks when checking fold (because of vim fold behavior),
    " but not when moving through lines (so blank lines can be moved onto)
    let l:fold_start = foldclosed(prevnonblank(a:lnum - 1))
    let l:up = l:fold_start >= 0 ? l:fold_start - 1 : a:lnum - 1
    return l:up > 1 ? l:up : 1
endfunction

function! s:lineDown(lnum)
    " Ignore blanks when checking fold (because of vim fold behavior),
    " but not when moving through lines (so blank lines can be moved onto)
    let l:fold_end = foldclosedend(nextnonblank(a:lnum + 1))
    let l:down = l:fold_end >= 0 ? l:fold_end + 1 : a:lnum + 1
    return l:down <= line('$') ? l:down : a:lnum
endfunction
