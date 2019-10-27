" Diary files

augroup DiaryFiles
    autocmd!
    " the zv here doesn't seem to work...
    autocmd BufWinEnter <buffer> normal zMzv
augroup end

" Append to a line at column 80
command! -nargs=1 ExtendLine execute 'normal! '.(<q-args>-strdisplaywidth(getline('.'))).'A '
nnoremap <silent> <buffer> <Leader><Leader>` :<c-u>exe 'ExtendLine '.(v:count ? v:count : 80)<CR>A

" Jump to the end of the top-most day.
nnoremap <silent> <buffer> <Leader>` zMgg/\v\= \d+\/\d+\/\d+<CR>zo/<CR>:nohl<CR>{{}

nnoremap <silent> <buffer> ]t /- todo:<CR>:nohl<CR>zvzz
nnoremap <silent> <buffer> [t ?- todo:<CR>:nohl<CR>zvzz
