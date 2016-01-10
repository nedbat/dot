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

hi Normal       gui=NONE            guifg=NONE          guibg=NONE
hi LineNr       cterm=NONE          ctermfg=LightGrey   ctermbg=DarkGrey
hi CursorLine   cterm=NONE          ctermfg=NONE        ctermbg=DarkGrey
hi ColorColumn  cterm=NONE          ctermfg=NONE        ctermbg=DarkGrey

" vim: tabstop=4 softtabstop=4 shiftwidth=4 expandtab
