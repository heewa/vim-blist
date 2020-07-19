command! -nargs=1 BlistMove exe 'normal!' string(<args>) . 'G'
command! -nargs=1 BlistMoveView exe 'normal!' string(<args>) . 'Gzv^'
