" Vim color file
" Ned's gui colors
" 
" to show all highlights:
" :so $VIMRUNTIME/syntax/hitest.vim
"
" based on:
" Maintainer:   Rajas Sambhare <rajas dot sambhare squigglylittleA gmail dot com>
" Last Change:  Nov 18, 2004
" Version:      1.0
" Based on the colors for Visual C++ 6.0 and Beyond Compare for diffs.
" Inspired by vc.vim by Vladimir Vrzic

set background=light
highlight clear
if exists("syntax_on")
    syntax reset
endif
let g:colors_name="neds"

highlight Normal        cterm=NONE      ctermfg=Black       ctermbg=White       gui=NONE            guifg=NONE          guibg=NONE
highlight NonText       cterm=NONE      ctermfg=Black       ctermbg=Grey        gui=NONE            guifg=NONE          guibg=LightGrey
highlight LineNr        cterm=NONE      ctermfg=Black       ctermbg=LightGrey   gui=italic          guifg=#444444       guibg=#dddddd
highlight Comment       cterm=NONE      ctermfg=DarkGreen   ctermbg=White       gui=italic          guifg=DarkGreen     guibg=NONE
highlight Constant      cterm=NONE      ctermfg=DarkCyan    ctermbg=White       gui=NONE            guifg=DarkCyan      guibg=NONE
highlight Identifier    cterm=NONE      ctermfg=LightBlue   ctermbg=White       gui=NONE            guifg=#6666FF       guibg=NONE
highlight Statement     cterm=bold      ctermfg=Blue        ctermbg=White       gui=bold            guifg=Blue          guibg=NONE
highlight PreProc       cterm=NONE      ctermfg=DarkRed     ctermbg=White       gui=NONE            guifg=DarkRed       guibg=NONE  
highlight Type          cterm=NONE      ctermfg=Blue        ctermbg=White       gui=NONE            guifg=Blue          guibg=NONE
highlight Underlined    cterm=NONE      ctermfg=Black       ctermbg=White       gui=underline       guifg=NONE          guibg=NONE
highlight Error         cterm=NONE      ctermfg=Yellow      ctermbg=Red         gui=NONE            guifg=Yellow        guibg=Red
highlight Todo          cterm=NONE      ctermfg=Black       ctermbg=Yellow      gui=NONE            guifg=NONE          guibg=LightYellow

highlight SpellBad      cterm=reverse   ctermbg=12                              gui=undercurl       guifg=NONE          guibg=#ffe8e8   guisp=Red

highlight CursorLine    cterm=NONE      ctermfg=NONE        ctermbg=LightRed    gui=NONE            guifg=NONE          guibg=#f0d8d8
highlight StatusLine    cterm=bold,reverse                                      gui=NONE            guifg=White         guibg=Black
highlight StatusLineNC  cterm=reverse                                           gui=NONE            guifg=White         guibg=#a0a0a0
highlight VertSplit     cterm=reverse                                           gui=NONE            guifg=White         guibg=#808080

" %1: modified marker: black on yellow
highlight User1         cterm=None      ctermfg=Black       ctermbg=Yellow                          guifg=Black         guibg=Yellow
" %2: subtle indicators
highlight User2         cterm=None      ctermfg=Gray        ctermbg=Black                           guifg=Gray          guibg=Black
" %3: alarming stuff: white on red
highlight User3         cterm=None      ctermfg=White       ctermbg=Red                             guifg=White         guibg=Red

highlight ColorColumn                                       ctermbg=LightGrey                                           guibg=#fff8f8

" Pop-up menu
highlight Pmenu         cterm=NONE      ctermfg=Black       ctermbg=Cyan        gui=NONE            guifg=Black         guibg=Cyan
highlight PmenuSel      cterm=NONE      ctermfg=Black       ctermbg=Yellow      gui=NONE            guifg=Black         guibg=Yellow

" Diff colors
highlight DiffAdd       cterm=NONE      ctermfg=Red         ctermbg=LightGrey   gui=NONE            guifg=Red           guibg=#fff0f0
highlight DiffChange    cterm=NONE      ctermfg=Red         ctermbg=LightGrey   gui=NONE            guifg=Red           guibg=#fff0f0
highlight DiffText      cterm=NONE      ctermfg=White       ctermbg=DarkRed     gui=bold,italic     guifg=Red           guibg=#fff0f0
highlight DiffDelete    cterm=NONE      ctermfg=White       ctermbg=LightGrey   gui=NONE            guifg=DarkGrey      guibg=#f0f0f0

highlight diffAdded     cterm=NONE      ctermfg=NONE        ctermbg=LightGreen  gui=NONE            guifg=NONE          guibg=#d0ffd0
highlight diffRemoved   cterm=NONE      ctermfg=NONE        ctermbg=LightRed    gui=NONE            guifg=NONE          guibg=#ffd0d0
highlight diffFile      cterm=None      ctermfg=Black       ctermbg=LightGrey                       guifg=Black         guibg=#e0e0e0

" vim: tabstop=4 softtabstop=4 shiftwidth=4 expandtab
