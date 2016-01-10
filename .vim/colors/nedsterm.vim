" Vim color file
" Ned's terminal colors
" 
" to show all highlights:
" :so $VIMRUNTIME/syntax/hitest.vim

set background=dark
hi clear
if exists("syntax_on")
    syntax reset
endif
let g:colors_name="nedsterm"

" https://upload.wikimedia.org/wikipedia/en/1/15/Xterm_256color_chart.svg
"
" 16 is black, but boldable
hi Normal       cterm=NONE      ctermfg=NONE        ctermbg=NONE
hi Comment      cterm=NONE      ctermfg=46          ctermbg=NONE
hi Statement    cterm=bold      ctermfg=39          ctermbg=NONE

hi LineNr       cterm=NONE      ctermfg=247         ctermbg=238
hi CursorLine   cterm=NONE      ctermfg=NONE        ctermbg=DarkGrey
hi ColorColumn  cterm=NONE      ctermfg=NONE        ctermbg=234

hi StatusLine   cterm=bold      ctermfg=16          ctermbg=LightGrey
hi StatusLineNC cterm=NONE      ctermfg=White       ctermbg=Black

" %1: modified marker: black on yellow
hi User1        cterm=bold      ctermfg=16          ctermbg=11
" %2: subtle indicators
hi User2        cterm=None      ctermfg=DarkGrey    ctermbg=LightGrey
" %3: alarming stuff: white on red
hi User3        cterm=None      ctermfg=White       ctermbg=Red

" vim: tabstop=4 softtabstop=4 shiftwidth=4 expandtab
