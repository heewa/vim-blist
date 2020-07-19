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
call s:mapUser('n', 'zc', 'Close')

call s:mapUser('n', 'zf', 'Focus')
call s:mapUser('n', 'zF', 'FullyFocus')

call s:mapUser('n', 'z-', 'ToggleComplete')

call s:mapUser('n', 'z>', 'Indent')
call s:mapUser('v', 'z>', 'Indent')

call s:mapUser('', 'zp', 'PasteAfter')
call s:mapUser('', 'zP', 'PasteBefore')

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
call s:mapPlug('n', 'Close', ':call blist#fold#close(line("."))<CR>')

call s:mapPlug('n', 'Focus', ':call blist#fold#focus(line("."))<CR>')
call s:mapPlug('n', 'FullyFocus', 'zMzvjzOk')

call s:mapPlug('n', 'ToggleComplete',
    \':call blist#bullets#toggleComplete()<CR>')

call s:mapPlug('n', 'Indent', ':call blist#bullets#indent()<CR>')
call s:mapPlug('v', 'Indent', ':call blist#bullets#indent()<CR>')

call s:mapPlug('', 'PasteAfter', ']p')
call s:mapPlug('', 'PasteBefore', ']P')
