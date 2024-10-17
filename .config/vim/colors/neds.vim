" Vim color file
" Ned's gui colors. For terminal colors, see nedsterm.vim
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

highlight Normal        gui=NONE            guifg=Black         guibg=NONE
highlight FadeBg        gui=NONE            guifg=Black         guibg=#f8f8f8
highlight NonText       gui=NONE            guifg=NONE          guibg=LightGrey
highlight LineNr        gui=italic          guifg=#444444       guibg=#dddddd
highlight Comment       gui=italic          guifg=DarkGreen     guibg=NONE
highlight Constant      gui=NONE            guifg=DarkCyan      guibg=NONE
highlight Identifier    gui=NONE            guifg=#6666FF       guibg=NONE
highlight Statement     gui=bold            guifg=Blue          guibg=NONE
highlight PreProc       gui=NONE            guifg=DarkRed       guibg=NONE
highlight Type          gui=NONE            guifg=Blue          guibg=NONE
highlight Underlined    gui=underline       guifg=NONE          guibg=NONE
highlight Error         gui=NONE            guifg=Yellow        guibg=Red
highlight Todo          gui=NONE            guifg=NONE          guibg=LightYellow
highlight Folded        gui=NONE            guifg=NONE          guibg=#f8f8f8

highlight SpellBad      gui=undercurl       guifg=NONE          guibg=#ffe8e8   guisp=Red
highlight SpecialKey    gui=NONE            guifg=Red           guibg=NONE

highlight CursorLine    gui=NONE            guifg=NONE          guibg=#f0d8d8
highlight StatusLine    gui=NONE            guifg=White         guibg=Black
highlight StatusLineNC  gui=NONE            guifg=White         guibg=#a0a0a0
highlight VertSplit     gui=NONE            guifg=White         guibg=#808080

" %1: modified marker: black on yellow
highlight User1                             guifg=Black         guibg=Yellow
" %2: subtle indicators
highlight User2                             guifg=Gray          guibg=Black
" %3: alarming stuff: white on red
highlight User3                             guifg=White         guibg=Red

highlight ColorColumn                                           guibg=#fff8f8

" Pop-up menu
highlight Pmenu         gui=NONE            guifg=#666666       guibg=#ffffcc
highlight PmenuSel      gui=bold            guifg=Black         guibg=#cccc00

" Diff colors
highlight DiffAdd       gui=NONE            guifg=Red           guibg=#fff0f0
highlight DiffChange    gui=NONE            guifg=Red           guibg=#fff0f0
highlight DiffText      gui=bold,italic     guifg=Red           guibg=#fff0f0
highlight DiffDelete    gui=NONE            guifg=DarkGrey      guibg=#f0f0f0

highlight diffAdded     gui=NONE            guifg=NONE          guibg=#d0ffd0
highlight diffRemoved   gui=NONE            guifg=NONE          guibg=#ffd0d0
highlight diffFile                          guifg=Black         guibg=#c0c0e0
highlight diffNewFile                       guifg=Black         guibg=#e0e0e0
highlight diffOldFile                       guifg=Black         guibg=#e0e0e0
highlight diffLine      gui=NONE                                guibg=#ddddff
highlight diffSubname                                           guibg=#eeeeff

" Marks and Markers in the gutter
highlight SignatureMarkText     gui=NONE    guifg=Black         guibg=NONE
highlight SignatureMarkerText   gui=NONE    guifg=Black         guibg=NONE
highlight SignatureMarkLine     gui=NONE    guifg=NONE          guibg=#ffffd0

" Terminal-in-vim
highlight Terminal                          guifg=Green         guibg=#333333

" IRC logs
highlight ircDate       gui=NONE            guifg=#888888
highlight ircName       gui=bold
highlight ircSpeaker    gui=bold
highlight ircSys        gui=NONE            guifg=#aaaaaa
highlight ircAction     gui=bold            guifg=Red           guibg=#ffdddd
highlight ircURL        gui=NONE            guifg=Blue          guibg=White
highlight! link ircError Normal
highlight! link ircIncr Normal
highlight! link ircDecr Normal
highlight! link ircDo Normal

" Quickfix previews
highlight QfPreview guifg=#333333 guibg=#eeeeee
highlight QfPreviewTitle gui=bold guifg=#000000 guibg=#dddddd

" Fugitive
highlight fugitiveUnstagedSection gui=bold guibg=#dddddd
highlight! link fugitiveUnstagedModifier fugitiveUnstagedSection
highlight! link fugitiveStagedSection fugitiveUnstagedSection
highlight! link fugitiveStagedModifier fugitiveUnstagedSection

highlight flogRef gui=bold guifg=NONE guibg=#ddddff
highlight! link flogRefHead flogRef
highlight! link flogRefHeadBranch flogRef
highlight! link flogRefTag flogRef

command! Dim highlight Normal guifg=#cccccc
command! Undim highlight Normal guifg=Black

" My diary.vim
highlight diaryDate     gui=bold            guifg=NONE          guibg=#ddddff
highlight diaryTodo     gui=NONE            guifg=NONE          guibg=#ffcccc
highlight diaryXodo     gui=NONE            guifg=NONE          guibg=#eeeeee
highlight diaryDone     gui=NONE            guifg=NONE          guibg=#ddffdd
highlight diaryProg     gui=NONE            guifg=NONE          guibg=#ffee55

" vim: tabstop=4 softtabstop=4 shiftwidth=4 expandtab
