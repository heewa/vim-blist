" Folds

if !hasmapto('<Plug>BlistToggleFold', 'n')
    nmap <buffer> <silent> za <Plug>BlistToggleFold
endif

if !hasmapto('<Plug>BlistOpenFold', 'n')
    nmap <buffer> <silent> zo <Plug>BlistOpenFold
endif

if !hasmapto('<Plug>BlistCloseFold', 'n')
    nmap <buffer> <silent> zc <Plug>BlistCloseFold
endif

" Focus: close all other folds
nnoremap <buffer> <silent> zf :call BlistFocus(line('.'))<CR>

" Fully Focus: close all other folds & fully open this bullet
nnoremap <buffer> <silent> zF zMzvjzOk

" Toggle complete
"nnoremap <buffer> <silent> z<return> :s/^\(\s*\)\([*-]\)/\=submatch(1) . {'*': '-', '-': '*'}[submatch(2)]/<CR>
nnoremap <buffer> <silent> z<return> :call BlistToggleComplete()<CR>

" TODO: delete, with children
nmap <buffer> <silent> zd dztj

" TODO: yank, with children

" paste, as next sibling
noremap <buffer> <silent> zp ]p

" paste, as previous sibling
noremap <buffer> <silent> zP ]P

" Indent
nmap <buffer> <silent> z> <Plug>BlistIndent
nmap <buffer> <silent> z<Tab> <Plug>BlistIndent
vmap <buffer> <silent> z> <Plug>BlistIndent
vmap <buffer> <silent> z<Tab> <Plug>BlistIndent

" TODO: swap with previous sibling
" TODO: swap with next sibling

" TODO: search for @person & #tag
" TODO: goto @-def (@@label) & #-def (##label)
