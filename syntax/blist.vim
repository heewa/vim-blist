if exists("b:current_syntax")
  finish
endif

syntax region BlistItem oneline matchgroup=BlistBullet start=/^\s*\*\s/ end=/$/ keepend
syntax region BlistItemCompleted oneline matchgroup=BlistBulletCompleted start=/^\s*-\s/ end=/$/ keepend

" TODO: comments? maybe? I dunno, sounds complicated
"syntax region BlistComment oneline matchgroup

syntax match BlistTag /#\h\w*/ contained containedin=BlistItem
syntax match BlistAt /@\h\w*/ contained containedin=BlistItem
syntax region BlistCodeInline oneline matchgroup=BlistCodeInlineEnds start=/`/ end=/`/ concealends contained containedin=BlistItem

syntax match BlistTagDef /##\h\w*/ contained containedin=BlistItem
syntax match BlistAtDef /@@\h\w*/ contained containedin=BlistItem

"highlight link BlistBullet Identifier
highlight link BlistBulletCompleted Comment
highlight link BlistTag Tag
highlight link BlistTagDef Typedef
highlight link BlistAt Tag
highlight link BlistAtDef Typedef
highlight link BlistCodeInline String

highlight! link Folded Comment
highlight link BlistItem Normal
highlight link BlistItemCompleted Comment

let b:current_syntax = "blist"
