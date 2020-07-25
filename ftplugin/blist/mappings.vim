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
    if !has('nvim') && a:type == ''
        " Plain vim does some weird cursor thing for motions where
        " it puts it at the top line of a visual area, not the "current"
        " line. I can't find a workaround, so just don't map it.

        call s:mapUser('n', a:from, a:to)
        call s:mapUser('o', a:from, a:to)

        return
    endif

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
call s:mapUser('n', 'z+', 'ToggleIncomplete')

call s:mapUser('n', 'yy', 'YankItem')
call s:mapUser('n', 'dd', 'DeleteItem')

call s:mapUser('', 'p', 'PasteAfter')
call s:mapUser('', 'P', 'PasteBefore')

"
" Bare Commands
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

call s:mapUser('n', '>>', 'Indent')
call s:mapUser('n', '<<', 'UnIndent')

"
" Plug Mappings
"

function! s:mapPlug(type, from, to, ...)
    exe a:type . 'noremap' get(a:, 1, '<silent>') s:name(a:from) a:to
endfunction

function! s:mapEx(type, from, to)
    let l:to = (has('nvim') ? '<Cmd>' : ':') . a:to . '<CR>'
    call s:mapPlug(a:type, a:from, l:to)
endfunction

function! s:mapCall(type, from, to)
    call s:mapEx(a:type, a:from, 'call ' . a:to)
endfunction

function! s:mapNormal(type, from, to)
    if has('nvim')
        let l:to = '<Cmd>silent exe <SID>maybeNormal(' . a:to . ')<CR>'
    elseif a:type == ''
        " Plain vim does some weird cursor thing for motions where
        " it puts it at the top line of a visual area, not the "current"
        " line. I can't find a workaround, so just don't map it.

        call s:mapNormal('n', a:from, a:to)
        call s:mapNormal('o', a:from, a:to)

        return
    elseif a:type == 'v'
        let l:to = ':<C-u>exe <SID>maybeNormal("gv".' . a:to . ")<CR>"
    else
        let l:to = ':<C-u>exe <SID>maybeNormal(' . a:to . ')<CR>'
    endif

    call s:mapPlug(a:type, a:from, l:to, '')
endfunction

function! s:maybeNormal(cmds)
    return empty(a:cmds) ? '' : 'normal! ' . a:cmds
endfunction

call s:mapNormal('', 'MoveParent', 'blist#move#parent(line(".")) . "ggzv^ll"')
call s:mapNormal('', 'MoveChild', 'blist#move#child(line(".")) . "ggzv^ll"')
call s:mapNormal('', 'MovePreviousSibling', 'blist#move#prevSibling(line(".")) . "ggzv^ll"')
call s:mapNormal('', 'MoveNextSibling', 'blist#move#nextSibling(line(".")) . "ggzv^ll"')
call s:mapNormal('', 'MovePrevious', 'blist#move#prev(line(".")) . "ggzv^ll"')
call s:mapNormal('', 'MoveNext', 'blist#move#next(line(".")) . "ggzv^ll"')

call s:mapCall('n', 'Toggle', 'blist#fold#toggle(line("."))')
call s:mapCall('n', 'Open', 'blist#fold#open(line("."))')
call s:mapCall('n', 'FullyOpen', 'blist#fold#fullyOpen(line("."))')
call s:mapCall('n', 'Close', 'blist#fold#close(line("."))')
call s:mapCall('n', 'FullyClose', 'blist#fold#fullyClose(line("."))')

call s:mapCall('n', 'Focus', 'blist#fold#focus(line("."))')
call s:mapPlug('n', 'FullyFocus', 'zMzvjzOk')

call s:mapCall('n', 'ToggleComplete', 'blist#bullets#toggleComplete()')
call s:mapCall('n', 'ToggleIncomplete', 'blist#bullets#toggleIncomplete()')

call s:mapEx('n', 'YankItem',
    \ 'exe ".," . string(blist#move#end(line("."))) . "y"')
call s:mapEx('n', 'DeleteItem',
    \ 'exe ".," . string(blist#move#end(line("."))) . "d"')

call s:mapNormal('', 'PasteAfter', 'blist#modify#pasteAfter()')
call s:mapNormal('', 'PasteBefore', 'blist#modify#pasteBefore()')

call s:mapNormal('', 'MoveRight', 'blist#baremove#right()')
call s:mapNormal('', 'MoveLeft', 'blist#baremove#left()')
call s:mapNormal('', 'MoveDown', 'blist#baremove#down()')
call s:mapNormal('', 'MoveUp', 'blist#baremove#up()')

call s:mapNormal('', 'MoveWord', 'blist#baremove#word()')
call s:mapNormal('', 'MoveWORD', 'blist#baremove#WORD()')
call s:mapNormal('', 'MoveWordEnd', 'blist#baremove#wordEnd()')
call s:mapNormal('', 'MoveWORDEnd', 'blist#baremove#WORDEnd()')
call s:mapNormal('', 'MoveBack', 'blist#baremove#back()')
call s:mapNormal('', 'MoveBACK', 'blist#baremove#BACK()')
call s:mapNormal('', 'MoveBackEnd', 'blist#baremove#backEnd()')
call s:mapNormal('', 'MoveBACKEnd', 'blist#baremove#BACKEnd()')

call s:mapNormal('', 'MoveStart', 'blist#baremove#start()')
call s:mapNormal('', 'MoveFirst', 'blist#baremove#first()')

call s:mapCall('n', 'Indent', 'blist#bullets#indent(line("."))')
call s:mapCall('n', 'UnIndent', 'blist#bullets#unIndent(line("."))')
