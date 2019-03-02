if exists("b:current_syntax")
    finish
endif

syntax match diaryDate /\v^\= \d\d?\/\d.*$/
syntax match diaryTodo /\v- todo:.*$/

highlight diaryDate     gui=bold,italic     guifg=NONE          guibg=#bbffbb
highlight diaryTodo     gui=NONE            guifg=NONE          guibg=#ffcccc

let b:current_syntax = "diary"
