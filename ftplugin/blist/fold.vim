" TODO: choose oneline/nextline folds based on option
setlocal foldmethod=indent
setlocal foldtext=BlistFoldText_Nextline(v:foldstart)
"setlocal foldmethod=expr
"setlocal foldexpr=CalcBlistFold(v:lnum)
"setlocal foldtext=BlistFoldText_Oneline()

function! BlistFoldText_Oneline()
    let l:indent = indent(v:foldstart) / shiftwidth() * &tabstop
    let l:content = substitute(getline(v:foldstart), '^\s*\(\S\)\s\+\(.*\)', '(\1)\2', '')
    return repeat(' ', l:indent - 1) . l:content . repeat(' ', winwidth(0))
endfunction

function! BlistFoldText_Nextline(lnum)
    let l:indent = indent(a:lnum - 1) + 1
    return repeat(' ', l:indent) . '\--' . repeat(' ', winwidth(0))
endfunction

function! CalcBlistFold(lnum)
    let l:line = getline(a:lnum)

    " Blank lines (which shouldn't exist) will take smaller of adjacent lvl
    if l:line =~ '^\s*$'
        return '-1'
    endif

    let l:this_lvl = indent(a:lnum) / shiftwidth()
    let l:next_lvl = indent(a:lnum + 1) / shiftwidth()

    if l:next_lvl > l:this_lvl
        return '>' . l:next_lvl
    endif
    return l:this_lvl
endfunction
