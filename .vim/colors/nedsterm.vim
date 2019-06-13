" Vim color file
" Ned's terminal colors
" 
" to show all highlights:
" :so $VIMRUNTIME/syntax/hitest.vim

set background=dark
highlight clear
if exists("syntax_on")
    syntax reset
endif
let g:colors_name="nedsterm"

" https://upload.wikimedia.org/wikipedia/en/1/15/Xterm_256color_chart.svg
"
" 16 is black, but boldable
highlight Normal        cterm=NONE      ctermfg=NONE        ctermbg=NONE
highlight Comment       cterm=italic    ctermfg=46          ctermbg=NONE
highlight Statement     cterm=bold      ctermfg=39          ctermbg=NONE

highlight LineNr        cterm=NONE      ctermfg=247         ctermbg=238
highlight CursorLine    cterm=NONE      ctermfg=NONE        ctermbg=53
highlight ColorColumn   cterm=NONE      ctermfg=NONE        ctermbg=234

highlight StatusLine    cterm=bold      ctermfg=16          ctermbg=LightGrey
highlight StatusLineNC  cterm=NONE      ctermfg=16          ctermbg=DarkGrey
highlight VertSplit     cterm=NONE      ctermfg=16          ctermbg=DarkGrey

highlight Folded        cterm=NONE      ctermfg=NONE        ctermbg=236
highlight SpecialKey    cterm=NONE      ctermfg=Red         ctermbg=NONE

" %1: modified marker: black on yellow
highlight User1         cterm=bold      ctermfg=16          ctermbg=11
" %2: subtle indicators
highlight User2         cterm=None      ctermfg=Black       ctermbg=LightGrey
" %3: alarming stuff: white on red
highlight User3         cterm=None      ctermfg=White       ctermbg=Red

" Pop-up menu
highlight Pmenu         cterm=italic    ctermfg=238         ctermbg=250
highlight PmenuSel      cterm=bold      ctermfg=Black       ctermbg=Yellow

highlight diffAdded     cterm=None      ctermfg=None        ctermbg=22
highlight diffRemoved   cterm=None      ctermfg=None        ctermbg=52

highlight DiffAdd       cterm=None      ctermfg=None        ctermbg=22
highlight DiffDelete    cterm=None      ctermfg=52          ctermbg=52
highlight DiffChange    cterm=None      ctermfg=None        ctermbg=236
highlight DiffText      cterm=None      ctermfg=None        ctermbg=59

" vim: tabstop=4 softtabstop=4 shiftwidth=4 expandtab
