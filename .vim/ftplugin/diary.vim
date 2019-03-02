" Diary files

augroup DiaryFiles
    autocmd!
    " the zv here doesn't seem to work...
    autocmd BufWinEnter <buffer> normal zMzv
augroup end
