function! s:name(base)
    " Prefix to make it a name that can't be typed
    " Postfix to remove prefix-collisions, which cause vim to pause
    return '<Plug>Blist' . a:base . '<>'
endfunction

"
" User Mappings
"

" Map if there isn't already one to a Plug mapping
function! s:mapUser(type, from, to)
    let l:to = s:name(a:to)

    if !hasmapto(l:to, a:type == '' ? 'nvo' : a:type)
        exe a:type . 'map <buffer> <silent>' a:from l:to
    endif
endfunction

call s:mapUser('', 'zh', 'MoveParent')
call s:mapUser('', 'zl', 'MoveChild')
call s:mapUser('', 'zk', 'MovePreviousSibling')
call s:mapUser('', 'zK', 'MovePrevious')
call s:mapUser('', 'zj', 'MoveNextSibling')
call s:mapUser('', 'zJ', 'MoveNext')

call s:mapUser('n', 'za', 'Toggle')
call s:mapUser('n', 'zo', 'Open')
call s:mapUser('n', 'zO', 'FullyOpen')
call s:mapUser('n', 'zc', 'Close')
call s:mapUser('n', 'zC', 'FullyClose')

call s:mapUser('n', 'zf', 'Focus')
call s:mapUser('n', 'zF', 'FullyFocus')

call s:mapUser('n', 'z-', 'ToggleComplete')

" TODO: fix all indenting
call s:mapUser('n', 'z>', 'Indent')
call s:mapUser('v', 'z>', 'Indent')
call s:mapUser('n', 'z<', 'UnIndent')

call s:mapUser('', 'zp', 'PasteAfter')
call s:mapUser('', 'zP', 'PasteBefore')

"
" Bare Movements
"

call s:mapUser('', 'l', 'MoveRight')
call s:mapUser('', 'h', 'MoveLeft')
call s:mapUser('', 'j', 'MoveDown')
call s:mapUser('', 'k', 'MoveUp')

call s:mapUser('n', 'w', 'MoveWord')
call s:mapUser('n', 'W', 'MoveWORD')
call s:mapUser('n', 'e', 'MoveWordEnd')
call s:mapUser('n', 'E', 'MoveWORDEnd')
call s:mapUser('n', 'b', 'MoveBack')
call s:mapUser('n', 'B', 'MoveBACK')
call s:mapUser('n', 'ge', 'MoveBackEnd')
call s:mapUser('n', 'gE', 'MoveBACKEnd')

call s:mapUser('', '0', 'MoveStart')
call s:mapUser('', '^', 'MoveFirst')

"
" Plug Mappings
"

function! s:mapPlug(type, from, to, ...)
    exe a:type . 'noremap' get(a:, 1, '<silent>') s:name(a:from) a:to
endfunction

function! s:mapNormal(type, from, to)
    call s:mapPlug(
        \ a:type,
        \ a:from,
        \ '<Cmd>exe <SID>maybeNormal(' . a:to . ')<CR>',
        \ '')
endfunction

function! s:maybeNormal(cmds)
    return empty(a:cmds) ? '' : 'normal! ' . a:cmds
endfunction

call s:mapNormal('', 'MoveParent',
    \ 'blist#move#parent(line(".")) . "ggzv^ll"')
call s:mapNormal('', 'MoveChild',
    \ 'blist#move#child(line(".")) . "ggzv^ll"')
call s:mapNormal('', 'MovePreviousSibling',
    \ 'blist#move#prevSibling(line(".")) . "ggzv^ll"')
call s:mapNormal('', 'MoveNextSibling',
    \ 'blist#move#nextSibling(line(".")) . "ggzv^ll"')
call s:mapNormal('', 'MovePrevious',
    \ 'blist#move#prev(line(".")) . "ggzv^ll"')
call s:mapNormal('', 'MoveNext',
    \ 'blist#move#next(line(".")) . "ggzv^ll"')

call s:mapPlug('n', 'Toggle', ':call blist#fold#toggle(line("."))<CR>')
call s:mapPlug('n', 'Open', ':call blist#fold#open(line("."))<CR>')
call s:mapPlug('n', 'FullyOpen', ':call blist#fold#fullyOpen(line("."))<CR>')
call s:mapPlug('n', 'Close', ':call blist#fold#close(line("."))<CR>')
call s:mapPlug('n', 'FullyClose', ':call blist#fold#fullyClose(line("."))<CR>')

call s:mapPlug('n', 'Focus', ':call blist#fold#focus(line("."))<CR>')
call s:mapPlug('n', 'FullyFocus', 'zMzvjzOk')

call s:mapPlug('n', 'ToggleComplete',
    \':call blist#bullets#toggleComplete()<CR>')

call s:mapPlug('n', 'Indent', ':call blist#bullets#indent()<CR>')
call s:mapPlug('v', 'Indent', ':call blist#bullets#indent()<CR>')
call s:mapPlug('n', 'UnIndent', ':call blist#bullets#unIndent()<CR>')

call s:mapPlug('', 'PasteAfter', ']p')
call s:mapPlug('', 'PasteBefore', ']P')

call s:mapNormal('', 'MoveRight', 'blist#baremove#right()')
call s:mapNormal('', 'MoveLeft', 'blist#baremove#left()')
call s:mapNormal('', 'MoveDown', 'blist#baremove#down()')
call s:mapNormal('', 'MoveUp', 'blist#baremove#up()')

call s:mapNormal('n', 'MoveWord', 'blist#baremove#word()')
call s:mapNormal('n', 'MoveWORD', 'blist#baremove#WORD()')
call s:mapNormal('n', 'MoveWordEnd', 'blist#baremove#wordEnd()')
call s:mapNormal('n', 'MoveWORDEnd', 'blist#baremove#WORDEnd()')
call s:mapNormal('n', 'MoveBack', 'blist#baremove#back()')
call s:mapNormal('n', 'MoveBACK', 'blist#baremove#BACK()')
call s:mapNormal('n', 'MoveBackEnd', 'blist#baremove#backEnd()')
call s:mapNormal('n', 'MoveBACKEnd', 'blist#baremove#BACKEnd()')

call s:mapNormal('', 'MoveStart', 'blist#baremove#start()')
call s:mapNormal('', 'MoveFirst', 'blist#baremove#first()')
