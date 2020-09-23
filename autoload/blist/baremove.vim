let s:firstPosStrict = '^\s*[*+-]\s.'
let s:firstPosLoose = '^\s*\([*+-]\s\)\?.\?'

function! blist#baremove#right() abort
    if col('.') < col('$') - 1
        return 'l'
    endif

    let l:pos = getcurpos()
    let l:end = s:lineDown(l:pos[1])
    return s:toLine(l:pos[1], l:end) . s:toCol(l:end, 0)
endfunction

function! blist#baremove#left() abort
    let l:pos = getcurpos()
    if l:pos[2] > matchend(getline(l:pos[1]), s:firstPosLoose)
        return 'h'
    endif

    return s:toLine(l:pos[1], s:lineUp(l:pos[1])) . '$'
endfunction

function! blist#baremove#down() abort
    let l:pos = getcurpos()
    let l:end = s:lineDown(l:pos[1])
    return s:toLine(l:pos[1], l:end) . s:toCol(l:end, l:pos[4])
endfunction

function! blist#baremove#up() abort
    let l:pos = getcurpos()
    let l:end = s:lineUp(l:pos[1])
    return s:toLine(l:pos[1], l:end) . s:toCol(l:end, l:pos[4])
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

function! s:toLine(start, end)
    return a:end == a:start ? '' :
        \ a:end == a:start + 1 ? 'j' :
        \ a:end == a:start - 1 ? 'k' :
        \ a:end <= 0 ? 'gg' :
        \ a:end >= line('$') ? 'G' :
        \ string(a:end) . 'gg'
endfunction

function! blist#baremove#firstCol()
    echo(matchend(getline(line('.')), s:firstPosStrict))
endfunction

function! s:toCol(line, col)
    let l:first_col = blist#utils#expandCol(
        \ matchend(getline(a:line), s:firstPosStrict),
        \ indent(a:line))

    if l:first_col < 0
        " Probably a broken bullet, so just go to the start
        return '^'
    elseif a:col <= l:first_col
        return '^ll'
    endif

    return string(a:col) . '|'
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
