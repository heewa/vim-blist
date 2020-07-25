if exists("b:current_syntax")
  finish
endif

syntax region BlistItem oneline matchgroup=BlistBullet start=/^\s*\*\s/ end=/$/ keepend
syntax region BlistItemCompleted oneline matchgroup=BlistBulletCompleted start=/^\s*-\s/ end=/$/ keepend

" TODO: comments? maybe? I dunno, sounds complicated
"syntax region BlistComment oneline matchgroup

syntax match BlistTag /#\w\+/ contained containedin=BlistItem
syntax match BlistAt /@\w\+/ contained containedin=BlistItem
syntax region BlistCodeInline oneline matchgroup=BlistCodeInlineEnds start=/`/ end=/`/ concealends contained containedin=BlistItem

syntax match BlistTagDef /##\w\+/ contained containedin=BlistItem
syntax match BlistAtDef /@@\w\+/ contained containedin=BlistItem


syntax region BlistLink_Title matchgroup=BlistLink_Ends start=/\[/ end=/\]/ concealends contained containedin=BlistItem nextgroup=BlistLink_Url
syntax region BlistLink_Url matchgroup=BlistLink_Ends start=/(/ end=/)/ oneline conceal contained

syntax match BlistLink_EmptyTitle /\[\s*\]/ conceal contained containedin=BlistItem nextgroup=BlistLink_ShownUrl
syntax region BlistLink_ShownUrl matchgroup=BlistLink_Ends start=/(/ end=/)/ oneline concealends contained

"highlight link BlistBullet Identifier
highlight link BlistBulletCompleted Comment
highlight link BlistTag Tag
highlight link BlistTagDef Typedef
highlight link BlistAt Tag
highlight link BlistAtDef Typedef
highlight link BlistCodeInline String

highlight link BlistLink_Title Underlined
highlight link BlistLink_Url Comment
highlight link BlistLink_ShownUrl Underlined
highlight link BlistLink_Ends Comment

highlight! link Folded Comment
highlight link BlistItem Normal
highlight link BlistItemCompleted Comment

let b:current_syntax = "blist"
