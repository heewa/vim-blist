if exists("b:current_syntax")
  finish
endif

syntax region BlistItem oneline matchgroup=BlistBullet start=/^\s*\*\s/ end=/$/ keepend
syntax region BlistItemCompleted oneline matchgroup=BlistBulletCompleted start=/^\s*-\s/ end=/$/ keepend
syntax region BlistItemIncomplete oneline matchgroup=BlistBulletIncomplete start=/^\s*+\s/ end=/$/ keepend

" TODO: comments? maybe? I dunno, sounds complicated
"syntax region BlistComment oneline matchgroup

syntax match BlistTag /#\w\+/ contained containedin=BlistItem,BlistItemIncomplete
syntax match BlistAt /@\w\+/ contained containedin=BlistItem,BlistItemIncomplete
syntax region BlistCodeInline oneline matchgroup=BlistCodeInlineEnds start=/`/ end=/`/ concealends contained containedin=BlistItem,BlistItemIncomplete

syntax match BlistTagDef /##\w\+/ contained containedin=BlistItem,BlistItemIncomplete
syntax match BlistAtDef /@@\w\+/ contained containedin=BlistItem,BlistItemIncomplete


syntax region BlistLink_Title matchgroup=BlistLink_Ends start=/\[/ end=/\]/ concealends contained containedin=BlistItem,BlistItemIncomplete nextgroup=BlistLink_Url
syntax region BlistLink_Title_Completed matchgroup=BlistLink_Ends start=/\[/ end=/\]/ concealends contained containedin=BlistItemCompleted nextgroup=BlistLink_Url
syntax region BlistLink_Url matchgroup=BlistLink_Ends start=/(/ end=/)/ oneline contained

syntax match BlistLink_EmptyTitle /\[\s*\]/ conceal contained containedin=BlistItem,BlistItemIncomplete nextgroup=BlistLink_ShownUrl
syntax region BlistLink_ShownUrl matchgroup=BlistLink_Ends start=/(/ end=/)/ oneline concealends contained

syntax match BlistLink_EmptyTitle_Completed /\[\s*\]/ contained containedin=BlistItemCompleted nextgroup=BlistLink_ShownUrl_Completed
syntax region BlistLink_ShownUrl_Completed matchgroup=BlistLink_Ends start=/(/ end=/)/ oneline concealends contained

highlight link BlistBullet Identifier
highlight link BlistItem Normal

highlight link BlistBulletCompleted Comment
highlight link BlistItemCompleted Comment

highlight link BlistBulletIncomplete Exception
highlight link BlistItemIncomplete Exception

highlight link BlistTag Tag
highlight link BlistTagDef Typedef
highlight link BlistAt Tag
highlight link BlistAtDef Typedef

highlight link BlistCodeInline Identifier

highlight link BlistLink_Title Underlined
highlight link BlistLink_ShownUrl Underlined

highlight link BlistLink_Title_Completed Comment
highlight link BlistLink_EmptyTitle Comment
highlight link BlistLink_EmptyTitle_Completed Comment
highlight link BlistLink_Url Comment
highlight link BlistLink_ShownUrl_Completed Comment
highlight link BlistLink_Ends Comment

highlight! link Folded Comment

let b:current_syntax = "blist"
