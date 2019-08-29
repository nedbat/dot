if exists("b:current_syntax")
    finish
endif

syntax match diaryDate /\v^\= \d\d?\/\d.*$/
syntax match diaryTodo /\v- todo:.*$/
syntax match diaryXodo /\v- xodo:.*$/
syntax match diaryXodo /\v- done:.*$/
syntax region foldManual start="{{{" end="}}}" transparent fold
syntax region foldDay start=/\v^\=/ end=/\v\ze\n\=/ transparent fold

set foldmethod=syntax

highlight diaryDate     gui=bold            guifg=NONE          guibg=#ddddff
highlight diaryTodo     gui=NONE            guifg=NONE          guibg=#ffcccc
highlight diaryXodo     gui=NONE            guifg=NONE          guibg=#ddffdd

let b:current_syntax = "diary"
