if exists('+colorcolumn')
    " Put the colorcolumn just after the last OK column, to match what
    " .editorconfig does.
    setlocal colorcolumn=81,101,121
endif

setlocal textwidth=79
setlocal formatoptions+=corq
setlocal formatoptions-=t
if v:version >= 704
    setlocal formatoptions+=j
endif
