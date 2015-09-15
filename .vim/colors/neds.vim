" Vim color file
" Ned's colors, based on:
" Maintainer:	Rajas Sambhare <rajas dot sambhare squigglylittleA gmail dot com>
" Last Change:	Nov 18, 2004
" Version:		1.0
" Based on the colors for Visual C++ 6.0 and Beyond Compare for diffs.
" Inspired by vc.vim by Vladimir Vrzic

set background=light
hi clear
if exists("syntax_on")
    syntax reset
endif
let g:colors_name="neds"

hi Normal		cterm=NONE		ctermfg=Black		ctermbg=White		gui=NONE			guifg=NONE			guibg=NONE
hi NonText		cterm=NONE		ctermfg=Black		ctermbg=Grey		gui=NONE			guifg=NONE			guibg=LightGrey
hi LineNr		cterm=NONE		ctermfg=Black       ctermbg=LightGrey	gui=italic			guifg=#444444		guibg=#dddddd
hi Comment		cterm=NONE		ctermfg=DarkGreen	ctermbg=White		gui=italic			guifg=DarkGreen		guibg=NONE
hi Constant		cterm=NONE		ctermfg=DarkCyan	ctermbg=White		gui=NONE			guifg=DarkCyan		guibg=NONE
hi Identifier	cterm=NONE		ctermfg=LightBlue	ctermbg=White		gui=NONE			guifg=#6666FF		guibg=NONE
hi Statement 	cterm=bold		ctermfg=Blue		ctermbg=White		gui=bold			guifg=Blue			guibg=NONE
hi PreProc		cterm=NONE		ctermfg=DarkRed		ctermbg=White		gui=NONE			guifg=DarkRed		guibg=NONE	
hi Type			cterm=NONE		ctermfg=Blue		ctermbg=White		gui=NONE			guifg=Blue			guibg=NONE
hi Underlined	cterm=NONE		ctermfg=Black		ctermbg=White		gui=underline		guifg=NONE			guibg=NONE
hi Error		cterm=NONE		ctermfg=Yellow		ctermbg=Red			gui=NONE			guifg=Yellow		guibg=Red
hi Todo			cterm=NONE		ctermfg=Black		ctermbg=Yellow		gui=NONE			guifg=NONE			guibg=LightYellow

hi CursorLine   cterm=NONE      ctermfg=NONE        ctermbg=LightRed    gui=NONE            guifg=NONE          guibg=#f0d8d8
hi StatusLine   cterm=bold,reverse                                      gui=NONE            guifg=White         guibg=Black
hi StatusLineNC cterm=reverse                                           gui=NONE            guifg=White         guibg=#a0a0a0
hi VertSplit    cterm=reverse                                           gui=NONE            guifg=White         guibg=#808080

" %1: modified marker: black on yellow
hi User1        cterm=None      ctermfg=Black       ctermbg=Yellow                          guifg=Black         guibg=Yellow
" %2: subtle indicators
hi User2        cterm=None      ctermfg=Gray        ctermbg=Black                           guifg=Gray          guibg=Black
" %3: alarming stuff: white on red
hi User3        cterm=None      ctermfg=White       ctermbg=Red                             guifg=White         guibg=Red

hi ColorColumn                                      ctermbg=LightGrey                                           guibg=#fff8f8

" Pop-up menu
hi Pmenu        cterm=NONE      ctermfg=Black       ctermbg=Cyan        gui=NONE            guifg=Black         guibg=Cyan
hi PmenuSel     cterm=NONE      ctermfg=Black       ctermbg=Yellow      gui=NONE            guifg=Black         guibg=Yellow

" Diff colors
hi DiffAdd		cterm=NONE		ctermfg=Red			ctermbg=LightGrey	gui=NONE			guifg=Red			guibg=#fff0f0
hi DiffChange	cterm=NONE		ctermfg=Red			ctermbg=LightGrey	gui=NONE			guifg=Red			guibg=#fff0f0
hi DiffText		cterm=NONE		ctermfg=White		ctermbg=DarkRed		gui=bold,italic		guifg=Red			guibg=#fff0f0
hi DiffDelete	cterm=NONE		ctermfg=White		ctermbg=LightGrey	gui=NONE			guifg=DarkGrey		guibg=#f0f0f0

hi diffAdded    cterm=NONE      ctermfg=NONE        ctermbg=LightGreen  gui=NONE            guifg=NONE          guibg=#d0ffd0
hi diffRemoved  cterm=NONE      ctermfg=NONE        ctermbg=LightRed    gui=NONE            guifg=NONE          guibg=#ffd0d0
hi diffFile     cterm=None      ctermfg=Black       ctermbg=LightGrey                       guifg=Black         guibg=#e0e0e0

" MinibufferExplorer colors
hi MBENormal                                                                                guifg=#808080
hi MBEChanged                                       ctermbg=Yellow                          guifg=#808080       guibg=yellow
hi MBEVisibleNormal                                                                         guifg=#505050
hi MBEVisibleActiveNormal                                               gui=bold            guifg=#505050
hi MBEVisibleChanged                                ctermbg=Yellow                          guifg=#505050       guibg=yellow
hi MBEVisibleActiveChanged                          ctermbg=Yellow      gui=bold            guifg=#505050       guibg=yellow

" vim: tabstop=4 softtabstop=4 shiftwidth=4 expandtab
