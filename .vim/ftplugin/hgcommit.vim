" Show diff while editing a Mercurial commit message
" Inspired by http://stackoverflow.com/questions/8009333/vim-show-diff-on-commit-in-mercurial
" and Michael Scherer' svn.vim

function! HgCiDiff()
    let i = 0
    let list_of_files = ''

    while i <= line('$') && getline(i) != 'HG: --'
        let i = i + 1
    endwhile
    while i <= line('$')
        let line = getline(i)
        if line =~ '^HG: \(added\|changed\)'
            let file = substitute(line, '^HG: \(added\|changed\) ', '', '')
            let file = "'".substitute(file, "'", "'\''", '')."'"
            let list_of_files = list_of_files . ' '.file
        endif
        let i = i + 1
    endwhile

    if list_of_files == ""
        return
    endif

    pclose
    botright new
    setlocal ft=diff previewwindow bufhidden=delete nobackup noswf nobuflisted nowrap buftype=nofile
    silent exec ':0r!hg diff ' . list_of_files
    setlocal nomodifiable
    goto 1
    redraw!
    " nooo idea why I have to do this
    syn enable
endfunction

call HgCiDiff()
