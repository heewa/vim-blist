" Folds

"   toggle open/close
nnoremap <buffer> <silent> za :call BlistToggleFold_Nextline(line('.'))<CR>
nnoremap <buffer> <silent> z<space> :call BlistToggleFold_Nextline(line('.'))<CR>

"   open  TODO: visual version - only work on top lvl items
nnoremap <buffer> <silent> zo :.+,.+foldopen<CR>

"   open al  TODO: visual version - only work on top lvl itemsl
nnoremap <buffer> <silent> zO :.+,.+foldopen!<CR>

"   close  TODO: visual version - only work on top lvl items
nnoremap <buffer> <silent> zc :.+,.+foldclose<CR>

"   close al  TODO: visual version - only work on top lvl itemsl
nnoremap <buffer> <silent> zC :.+,.+foldclose!<CR>

" Focus: close all other folds
nnoremap <buffer> <silent> zf :call BlistFocus(line('.'))<CR>

" Fully Focus: close all other folds & fully open this bullet
nnoremap <buffer> <silent> zF zMzvjzOk

" Toggle complete
"nnoremap <buffer> <silent> z<return> :s/^\(\s*\)\([*-]\)/\=submatch(1) . {'*': '-', '-': '*'}[submatch(2)]/<CR>
nnoremap <buffer> <silent> z<return> :call BlistToggleComplete()<CR>

" Movements
noremap <buffer> <silent> zh :BlistMove BlistParent(line('.'), 0)<CR>
noremap <buffer> <silent> zl :BlistMove BlistChild(line('.'), 0)<CR>
noremap <buffer> <silent> zk :BlistMove BlistPrevious(line('.'), 0)<CR>
noremap <buffer> <silent> zj :BlistMove BlistNext(line('.'), 0)<CR>

" TODO: Movements "to" (before, not including, helpful for deleting)
noremap <buffer> <silent> zth :BlistMove BlistParent(line('.'), 1)<CR>
noremap <buffer> <silent> ztl :BlistMove BlistChild(line('.'), 1)<CR>
noremap <buffer> <silent> ztk :BlistMove BlistPrevious(line('.'), 1)<CR>
noremap <buffer> <silent> ztj :BlistMove BlistNext(line('.'), 1)<CR>

" TODO: delete, with children
nmap <buffer> <silent> zd dztj

" TODO: yank, with children

" paste, as next sibling
noremap <buffer> <silent> zp ]p

" paste, as previous sibling
noremap <buffer> <silent> zP ]P

" Indent
nnoremap <buffer> <silent> z> :call BlistIndent()<CR>
nnoremap <buffer> <silent> z<Tab> :call BlistIndent()<CR>
vnoremap <buffer> <silent> z> :call BlistIndent()<CR>
vnoremap <buffer> <silent> z<Tab> :call BlistIndent()<CR>

" TODO: swap with previous sibling
" TODO: swap with next sibling

" TODO: search for @person & #tag
" TODO: goto @-def (@@label) & #-def (##label)
