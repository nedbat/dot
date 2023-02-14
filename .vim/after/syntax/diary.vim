if exists("b:current_syntax")
    finish
endif

syntax match diaryDate /\v^\= \d\d?\/\d.*$/
syntax match diaryTodo /\v- todo:.*$/
syntax match diaryXodo /\v- xodo:.*$/
syntax match diaryDone /\v- done:.*$/
syntax match diaryDone /\v- togh:.*$/
syntax match diaryProg /\v- prog:.*$/
syntax region foldManual start="{{{" end="}}}" transparent fold
syntax region foldDay start=/\v^\=/ end=/\v\ze\n\=/ transparent fold

set foldmethod=syntax
syntax sync fromstart

"highlight diaryDate     gui=bold            guifg=NONE          guibg=#ddddff
"highlight diaryTodo     gui=NONE            guifg=NONE          guibg=#ffcccc
"highlight diaryXodo     gui=NONE            guifg=NONE          guibg=#eeeeee
"highlight diaryDone     gui=NONE            guifg=NONE          guibg=#ddffdd
"highlight diaryProg     gui=NONE            guifg=NONE          guibg=#ffdd33

let b:current_syntax = "diary"
