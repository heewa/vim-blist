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

function! BlistToggleFold_Nextline(lnum)
    let l:curr_indent = indent(a:lnum)
    let l:next_indent = indent(a:lnum + 1)

    if foldclosed(a:lnum) >= 0
        " The line we're on is a closed fold, which isn't meant to be used
        " for this, but let's open it
        silent normal! zok
        "silent exe string(a:lnum) . ',' . string(a:lnum) . 'foldopen'
    elseif l:curr_indent < l:next_indent
        let l:close_start = foldclosed(a:lnum + 1)

        if l:close_start < 0 && indent(a:lnum + 2) > l:curr_indent
            " Only attempt to close multi-line children
            silent normal! jzck
        elseif l:close_start >= 0
            " Open the fold
            silent normal! jzok
        endif
    endif
endfunction

function! IndentLvl(lnum)
    return indent(a:lnum) / shiftwidth()
endfunction

function! CalcBlistFold(lnum)
    let l:line = getline(a:lnum)

    " Blank lines (which shouldn't exist) will take smaller of adjacent lvl
    if l:line =~ '^\s*$'
        return '-1'
    endif

    let l:this_lvl = IndentLvl(a:lnum)
    let l:next_lvl = IndentLvl(a:lnum + 1)

    if l:next_lvl > l:this_lvl
        return '>' . l:next_lvl
    endif
    return l:this_lvl
endfunction
