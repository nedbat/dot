if exists("b:current_syntax")
    finish
endif

syntax match diaryDate /\v^\= \d\d?\/\d.*$/
syntax match diaryTodo /\v- todo:.*$/
syntax match diaryXodo /\v- xodo:.*$/
syntax match diaryDone /\v- done:.*$/
syntax match diaryProg /\v- prog:.*$/
syntax region foldManual start="{{{" end="}}}" transparent fold
syntax region foldDay start=/\v^\=/ end=/\v\ze\n\=/ transparent fold

set foldmethod=syntax

highlight diaryDate     gui=bold            guifg=NONE          guibg=#ddddff
highlight diaryTodo     gui=NONE            guifg=NONE          guibg=#ffcccc
highlight diaryXodo     gui=NONE            guifg=NONE          guibg=#ddffdd
highlight diaryDone     gui=NONE            guifg=NONE          guibg=#ddffdd
highlight diaryProg     gui=NONE            guifg=NONE          guibg=#ffdd00

let b:current_syntax = "diary"
