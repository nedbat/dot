" from https://github.com/habamax/vim-rst/wiki

func! s:section_delimiter_adjust() abort
    let section_delim = '^\([=`:."' . "'" . '~^_*+#-]\)\1*$'
    let cline = getline('.')
    if cline !~ section_delim && cline !~ '^\s\+\S'
        let nline = getline(line('.') + 1)
        let pline = getline(line('.') - 1)
        if pline =~ '^\s*$' && nline =~ section_delim
            call setline(line('.') + 1, repeat(nline[0], strchars(cline)))
        elseif pline =~ section_delim && nline =~ section_delim && pline[0] == nline[0]
            call setline(line('.') + 1, repeat(nline[0], strchars(cline)))
            call setline(line('.') - 1, repeat(pline[0], strchars(cline)))
        endif
    endif
endfunc

augroup rst_section | au!
    au InsertLeave <buffer> :call s:section_delimiter_adjust()
augroup END
