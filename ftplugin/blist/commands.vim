" Move cursor to bullet on given line
command -nargs=1 BlistMove exe 'normal' string(<args>) . 'G^'
