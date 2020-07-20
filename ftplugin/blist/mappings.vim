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

call s:mapUser('', 'w', 'MoveWord')
call s:mapUser('', 'W', 'MoveWORD')
call s:mapUser('', 'e', 'MoveWordEnd')
call s:mapUser('', 'E', 'MoveWORDEnd')
call s:mapUser('', 'b', 'MoveBack')
call s:mapUser('', 'B', 'MoveBACK')
call s:mapUser('', 'ge', 'MoveBackEnd')
call s:mapUser('', 'gE', 'MoveBACKEnd')

call s:mapUser('', '0', 'MoveStart')
call s:mapUser('', '^', 'MoveFirst')

"
" Plug Mappings
"

function! s:mapPlug(type, from, to)
    exe a:type . 'noremap <silent>' s:name(a:from) a:to
endfunction

call s:mapPlug('', 'MoveParent',
    \':BlistMoveView blist#move#parent(line("."))<CR>')
call s:mapPlug('', 'MoveChild',
    \':BlistMoveView blist#move#child(line("."))<CR>')
call s:mapPlug('', 'MovePreviousSibling',
    \':BlistMoveView blist#move#prevSibling(line("."))<CR>')
call s:mapPlug('', 'MoveNextSibling',
    \':BlistMoveView blist#move#nextSibling(line("."))<CR>')
call s:mapPlug('', 'MovePrevious',
    \':BlistMoveView blist#move#prev(line("."))<CR>')
call s:mapPlug('', 'MoveNext',
    \':BlistMoveView blist#move#next(line("."))<CR>')

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

call s:mapPlug('', 'MoveRight', ':exe "normal!" blist#baremove#right()<CR>')
call s:mapPlug('', 'MoveLeft', ':exe "normal!" blist#baremove#left()<CR>')
call s:mapPlug('', 'MoveDown', ':exe "normal!" blist#baremove#down()<CR>')
call s:mapPlug('', 'MoveUp', ':exe "normal!" blist#baremove#up()<CR>')

call s:mapPlug('', 'MoveWord',
    \ ':exe "normal!" blist#baremove#word()<CR>')
call s:mapPlug('', 'MoveWORD',
    \ ':exe "normal!" blist#baremove#WORD()<CR>')
call s:mapPlug('', 'MoveWordEnd',
    \ ':exe "normal!" blist#baremove#wordEnd()<CR>')
call s:mapPlug('', 'MoveWORDEnd',
    \ ':exe "normal!" blist#baremove#WORDEnd()<CR>')
call s:mapPlug('', 'MoveBack',
    \ ':exe "normal!" blist#baremove#back()<CR>')
call s:mapPlug('', 'MoveBACK',
    \ ':exe "normal!" blist#baremove#BACK()<CR>')
call s:mapPlug('', 'MoveBackEnd',
    \ ':exe "normal!" blist#baremove#backEnd()<CR>')
call s:mapPlug('', 'MoveBACKEnd',
    \ ':exe "normal!" blist#baremove#BACKEnd()<CR>')

call s:mapPlug('', 'MoveStart', ':exe "normal!" blist#baremove#start()<CR>')
call s:mapPlug('', 'MoveFirst', ':exe "normal!" blist#baremove#first()<CR>')
