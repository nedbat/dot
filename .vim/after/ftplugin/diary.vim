" Diary files

augroup DiaryFiles
    autocmd!
    " the zv here doesn't seem to work...
    autocmd BufWinEnter <buffer> normal zMzv
augroup end

" Append to a line at column 80.
command! -nargs=1 ExtendLine execute 'normal! '.(<q-args>-strdisplaywidth(getline('.'))).'A '
nnoremap <silent> <buffer> <Leader><Leader>` :<c-u>exe 'ExtendLine '.(v:count ? v:count : 80)<CR>A

" Jump to the end of the top-most day.
nnoremap <silent> <buffer> <Leader>` zMgg/\v\= \d+\/\d+\/\d+<CR>zo/<CR>:nohl<CR>{{}

" Jump to the next/prev todo marker.
nnoremap <silent> <buffer> ]t /\v- (todo\|prog):<CR>:nohl<CR>zvzz
nnoremap <silent> <buffer> [t ?\v- (todo\|prog):<CR>:nohl<CR>zvzz

" Jump to the next/prev day.
nnoremap <silent> <buffer> ]d /\v^\= \d<CR>:nohl<CR>zvzz
nnoremap <silent> <buffer> [d ?\v^\= \d<CR>:nohl<CR>zvzz

" Insert a new date heading for today.
function! Today()
    let line = strftime("= %m/%d/%Y, %A")
    let line = substitute(substitute(line, ' 0', ' ', 'g'), '/0', '/', 'g')
    call feedkeys("O" . line . "\n\n\<ESC>")
endfunction
command! Today :call Today()
