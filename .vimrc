" Ned's .vimrc file

filetype off

" Windows thinks personal vim stuff should be in ~/vimfiles, make it look in ~/.vim instead
set runtimepath=~/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,~/.vim/after

" To install a vimball (XYZ, for example):
"   $ mkdir ~/.vim/bundle/XYZ
"   $ vim XYZ.vmb
"   :UseVimball ~/.vim/bundle/XYZ

set directory-=.                        " Don't store .swp files in the current directory
set updatecount=0                       " Don't create .swp files at all.
set shortmess+=I                        " Don't show the vim intro message
set history=500                         " Keep a LOT of history for commands
set scrolloff=2                         " Keep two lines visible above/below the cursor when scrolling.

set incsearch                           " Use incremental search
set showmatch                           " Blink matching punctuation

set modeline modelines=2                " Read vim settings from the file itself
set encoding=utf-8
set fileformat=unix fileformats=unix,dos
set wildignore=*.o,*~,*.pyc

set undofile undodir=~/.vimundo         " Save undo's after file closes
set undolevels=1000                     " How many undos
set undoreload=10000                    " Number of lines to save for undo

" Line numbering
set number                              " Turn on line numbering
if exists('+numberwidth')
    set numberwidth=5                   " with space for at least four digits (plus 1 for space)
endif

" mac iTerm2 cursor control for insert mode.
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

if has("mac")
    if has("terminfo")                  " from https://nicksergeant.com/make-your-leopard-terminal-and-vim-shine-with-simbl-terminalcolors-and-the-ir_black-theme/
        set t_Co=16
        set t_AB=[%?%p1%{8}%<%t%p1%{40}%+%e%p1%{92}%+%;%dm
        set t_AF=[%?%p1%{8}%<%t%p1%{30}%+%e%p1%{82}%+%;%dm
    else
        set t_Co=16
        set t_Sf=[3%dm
        set t_Sb=[4%dm
    endif
endif

set showcmd                             " Show partial commands in the status line
if has("syntax")
    syntax on                           " Turn on syntax coloring
endif
colorscheme neds                        " Use my colors to whatever extent possible.

if exists('+colorcolumn')
    set colorcolumn=80
endif

set listchars=tab:>-,eol:$,trail:-      " When in show-all-chars mode (set list), use >-- for tabs.
set tabstop=8                           " Real tab characters take up 8 spaces
set softtabstop=4                       "   but indent by 4 when typing tab while editing.
set expandtab                           " Use spaces when hitting the tab key
set shiftwidth=4                        "   and shift by 4 spaces when indenting.
set shiftround                          " When indenting, round to a multiple of shiftwidth.
set autoindent                          " Pick the indent for a line from the previous line.
set nosmarttab                          " Tabs always means the same thing, don't be too smart.
set indentkeys=o,O                      " Only new lines should get auto-indented.

filetype plugin indent on               " Use the filetype to load syntax, plugins and indent files.
set hlsearch                            " Highlight search results in the file.
set autoread                            " Re-read a file if it changed behind vim's back.
set hidden                              " Allow a modified buffer to become hidden.
set nowrap                              " When I want to be confused by wrapped lines, I'll do it manually.
set linebreak                           "   but when I do wrap, I want word wrap, not character.
set display=lastline,uhex               " Display as much as possible of a last line, and ctrl chars in hex.
set ignorecase smartcase                " If all lower-case, match any case, else be case-sensitive
set virtualedit=onemore                 " One virtual character at the ends of lines, makes ^V work properly.
set noerrorbells                        " Don't ring the bell on errors
set visualbell t_vb=                    "   and don't flash either.
set fillchars=vert:\ ,fold:-            " Spaces are enough for vertical split separators.

if exists("+mouse")
    set mouse=a                         " Mice are wonderful.
endif

if exists("+cursorline")
    augroup CursorLine
        autocmd!
        autocmd InsertEnter * set cursorline
        autocmd InsertLeave * set nocursorline
    augroup end
endif

set laststatus=2                        " Always show a status line
let filestatus = ''
let filestatus .= ' %1*%{&readonly ? "" : &modified ? " + " : &modifiable ? "" : " - "}%*'
let filestatus .= '%3*%{&readonly ? (&modified ? " + " : " ∅ ") : ""}%*'
let filestatus .= '%{&readonly? "" : &modified ? "" : &modifiable ? "   " : ""}'
let filestatus .= ' %<%f  '
let filestatus .= '%2*%{tagbar#currenttag(" %s ", "", "f")}%*'
let filestatus .= ' %{fugitive#statusline()}'
let filestatus .= '%='
let filestatus .= '%{strlen(&filetype) ? &filetype : "none"}'
let filestatus .= ' [%{strpart(&fileencoding,0,1)}%{strpart(&fileformat,0,1)}]'
let filestatus .= '%6l,%2c'
let filestatus .= '  %P '
let &statusline = filestatus

function! StatusQuickfixTitle()
    if exists('w:quickfix_title')
        let title = ': '
        let titleparts = split(w:quickfix_title)
        if titleparts[0] =~ 'gerp.py'
            let titleparts[0] = 'gerp'
        endif
        let title .= join(titleparts, '  ')
    else
        let title = ''
    endif
    return title
endfunction

let quickfixstatus = '     Quickfix'
let quickfixstatus .= '%{StatusQuickfixTitle()}'
let quickfixstatus .= '%='
let quickfixstatus .= '%l of %L  %P '

let helpstatus = ' Help: %f%=%P '

augroup QuickFixSettings
    autocmd!
    autocmd FileType qf let &l:statusline = quickfixstatus
    autocmd FileType qf setlocal nobuflisted colorcolumn=
    autocmd FileType qf nnoremap <silent> <buffer> ,            :colder<CR>
    autocmd FileType qf nnoremap <silent> <buffer> .            :cnewer<CR>
    autocmd FileType qf nnoremap <silent> <buffer> q            :quit\|:wincmd b<CR>
    autocmd FileType qf nnoremap <silent> <buffer> <Leader>c    :cclose<CR>
    " <Leader>a in quickfix means re-do the search.
    autocmd FileType qf nnoremap <expr>   <buffer> <Leader>a    ':<C-U>grep! ' . join(split(w:quickfix_title)[1:])
    " <leader>s means start a new search, but from the same place.
    autocmd FileType qf nnoremap <expr>   <buffer> <Leader>s    ':<C-U>grep! ' . split(w:quickfix_title)[1] . ' /'
augroup end

augroup HelpSettings
    autocmd FileType help let &l:statusline = helpstatus
    autocmd FileType help setlocal colorcolumn=
augroup end

augroup GitCommitSettings
    " auto-fill paragraphs
    autocmd FileType gitcommit setlocal formatoptions+=a
    autocmd FileType gitcommit DiffGitCached | wincmd r
augroup end

augroup HgCommitSettings
    autocmd BufRead,BufNewFile hg-editor-*.txt set filetype=hgcommit
    autocmd FileType hgcommit setlocal formatoptions+=a
augroup end

augroup VagrantSettings
    autocmd BufRead,BufNewFile Vagrantfile set filetype=ruby
augroup end

" Suggested by fmoralesc, but doesn't work yet.  XML doesn't spell check
" regular text?
"augroup XmlSettings
"    autocmd FileType xml syntax match xmlAURL /["']\zs.*\ze["']/ contained containedin=xmlString contains=@NoSpell transparent
"    autocmd FileType xml syntax spell default
"augroup end

" Abbreviations
iabbrev pdbxx   import pdb,sys as __sys;__sys.stdout=__sys.__stdout__;pdb.set_trace() # -={XX}=-={XX}=-={XX}=-        
iabbrev pudbxx  import pudb,sys as __sys;__sys.stdout=__sys.__stdout__;pudb.set_trace() # -={XX}=-={XX}=-={XX}=-        
iabbrev staxxx  import inspect;print("\n".join("%30s : %s @%d" % (t[3], t[1], t[2]) for t in inspect.stack()[:0:-1]))          

iabbrev loremx      lorem ipsum quia dolor sit amet consectetur adipisci velit, sed quia non numquam eius modi tempora incidunt.
iabbrev loremxx     lorem ipsum quia dolor sit amet consectetur adipisci velit, sed quia non numquam eius modi tempora incidunt, ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam.
iabbrev loremxxx    lorem ipsum quia dolor sit amet consectetur adipisci velit, sed quia non numquam eius modi tempora incidunt, ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit, qui in ea voluptate velit esse, quam nihil molestiae consequatur, vel illum, qui dolorem eum fugiat, quo voluptas nulla pariatur.

" ./ in the command line expands to the directory of the current file, but ../
" works without an expansion.
cnoremap <expr> ./ getcmdtype() == ':' ? expand('%:p:h').'/' : './'
cnoremap ../ ../

""
"" Plugins
""

" https://github.com/junegunn/vim-plug

call plug#begin()

Plug 'kshenoy/vim-signature'
Plug 'will133/vim-dirdiff'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'pearofducks/ansible-vim'
Plug 'scrooloose/nerdtree'
Plug 'majutsushi/tagbar'
Plug 'mattn/webapi-vim' | Plug 'mattn/gist-vim'
Plug 'lfv89/vim-interestingwords'
Plug 'klen/python-mode'
Plug 'qstrahl/vim-dentures'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'kana/vim-textobj-user' | Plug 'Julian/vim-textobj-variable-segment'
Plug 'tpope/vim-unimpaired'
Plug 'maxbrunsfeld/vim-yankstack'

call plug#end()

""
"" Plugin configuration.
""

" kshenoy/vim-signature
let g:SignatureIncludeMarks = 'abcdefghijklmnopqrstuvwxyz'

" ctrlpvim/ctrlp.vim
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_max_height = 50
let g:ctrlp_mruf_max = 1000
let g:ctrlp_mruf_exclude = '^/private/var/folders/.*\|.*hg-editor-.*\|.*fugitiveblame$'
let g:ctrlp_open_multiple_files = '2vjr'
let g:ctrlp_prompt_mappings = {
    \ 'ToggleType(1)':        ['<c-f>', '<c-up>', ',', '<space>'],
    \ }
let g:ctrlp_root_markers = ['.treerc']
nnoremap <silent> <Leader>e :CtrlP<CR>

" pearofducks/ansible-vim
let g:ansible_attribute_highlight = 'ab'    " highlight all attributes, brightly.
let g:ansible_name_highlight = 'd'

" scrooloose/nerdtree
if v:version >= 700
    let g:NERDTreeIgnore = ['\.pyc$', '\.pyo$', '\.pyd$', '\.o$', '\.so$', '__pycache__', '\.egg-info$']
    let g:NERDTreeSortOrder = ['^_.*', '\/$', '*', '\.swp$',  '\.bak$', '\~$']
    let g:NERDTreeShowBookmarks = 0
    let g:NERDTreeMinimalUI = 1
    let g:NERDTreeBookmarksSort = 0
    let g:NERDTreeCascadeOpenSingleChildDir = 1
    if has("gui_win32")
        let g:NERDTreeDirArrows = 0
    endif
    noremap <silent> <Leader>f :NERDTreeFind<CR>
else
    " Don't load NERDTree, it will just complain.
    let g:loaded_nerd_tree = 1
endif

" majutsushi/tagbar
let g:tagbar_width = 40
let g:tagbar_zoomwidth = 30
let g:tagbar_sort = 0                               " sort by order in file
let g:tagbar_show_visibility = 0
let g:tagbar_show_linenumbers = 0
let g:tagbar_autofocus = 1
let g:tagbar_autoclose = 1
let g:tagbar_iconchars = ['+', '-']
nnoremap <silent> <Leader>t :TagbarToggle<CR>

let g:tagbar_type_html = {
    \ 'ctagstype' : 'html',
    \ 'sort'      : 0,
    \ 'kinds'     : [
        \ 'h:headings'
    \ ]
\ }

" mattn/gist
let g:gist_clip_command = 'pbcopy'
let g:gist_detect_filetype = 1
let g:gist_post_private = 1

" lfv89/vim-interestingwords
let g:interestingWordsGUIColors = ['#F0C0FF', '#A7FFB7', '#FFB7B7', '#A8D1FF', '#AAFFFF', '#E8E8AA']

" klen/python-mode
let g:pymode_folding = 0
let g:pymode_syntax = 1
let g:pymode_syntax_slow_sync = 1
let g:pymode_syntax_all = 1
let g:pymode_motion = 1
let g:pymode_trim_whitespaces = 0
let g:pymode_lint_on_write = 0
let g:pymode_syntax_string_formatting = 1
let g:pymode_syntax_string_format = 1
let g:pymode_syntax_string_templates = 1
let g:pymode_syntax_doctests = 1
let g:pymode_rope = 0
let g:pymode_rope_complete_on_dot = 0
let g:pymode_breakpoint = 0


" Run a command, but keep the output in a buffer.
command! -nargs=+ BufOut redir => bufout | silent <args> | redir END | new | call append(0, split(bufout, '\n'))

" Don't close window, when deleting a buffer
" from: https://github.com/amix/vimrc/blob/master/vimrcs/basic.vim
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction

" From https://github.com/Julian/dotfiles/blob/master/.vimrc
command! DiffThese call <SID>DiffTheseCommand()
function! s:DiffTheseCommand()
    if &diff
        diffoff!
    else
        diffthis

        let window_count = tabpagewinnr(tabpagenr(), '$')
        if window_count == 2
            wincmd w
            diffthis
            wincmd w
        endif
    endif
endfunction
nnoremap <Leader>d :<C-U>DiffThese<CR>

" Shortcuts to things I want to do often.
noremap <Leader>p gwap
noremap <Leader><Leader>p gw}
noremap <silent> <Leader>q :quit<CR>
noremap <silent> <Leader><Leader>q :Bclose<CR>
noremap <Leader>w :write<CR>
noremap <Leader><Leader>w :wall<CR>
noremap <Leader>x :exit<CR>

noremap <Leader>2 :setlocal shiftwidth=2 softtabstop=2<CR>
noremap <Leader>4 :setlocal shiftwidth=4 softtabstop=4<CR>
noremap <Leader>8 :setlocal shiftwidth=8 softtabstop=8<CR>

" Toggle list mode to see special characters.
noremap <Leader>l :set list!<CR>
" Show only one window on the screen, but keep the explorers open.
noremap <silent> <Leader>1 :only!\|:NERDTreeToggle\|:vertical resize 30\|:wincmd b<CR>
noremap <silent> <Leader><Leader>1 :only!<CR>

" More intuitive splits.
nnoremap <Leader>_ <C-W>s
nnoremap <Leader><Bar> <C-W>v
nnoremap <Leader><Leader><Bar> :only!<CR><C-W>v

noremap <Leader>gb :Gblame<CR>

" Selecting things: last modified text (good for after pasting); everything.
noremap <Leader>v `[v`]
noremap <Leader><Leader>v ggVG

" Backspace and cursor keys wrap to previous/next line.
set backspace=indent,eol,start
set whichwrap+=<,>,[,]
set t_kb=                           " Use the delete key for backspace (the blot is ^?)

" Indenting in visual mode keeps the visual highlight.
vnoremap < <gv
vnoremap > >gv

" Remove annoying F1 help.
inoremap <F1> <nop>
nnoremap <F1> <nop>
vnoremap <F1> <nop>

" Jump to start and end of line using the home row keys.
nnoremap H ^
vnoremap H ^
nnoremap L $
vnoremap L $

" Fix the filetype for .md files.
augroup MarkDownType
    autocmd!
    autocmd BufNewFile,BufRead *.md setlocal filetype=markdown
augroup end

" Idea from https://github.com/Julian/dotfiles/blob/master/.vimrc
augroup FormatStupidity
    " ftplugins are stupid and try to mess with indentkeys.
    autocmd!
    autocmd BufNewFile,BufRead * setlocal indentkeys=o,O " Only new lines should get auto-indented.
augroup end

noremap <silent> <C-PageUp>     :bprevious<CR>
noremap <silent> <C-PageDown>   :bnext<CR>
noremap <silent> <C-Tab>        <C-w><C-w>

" Control-H etc navigate among windows.
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" <C-l> was redraw, make it \z
nnoremap <leader>z :nohlsearch<CR><C-L>

" Easier sizing of windows.
nnoremap <leader>[ <C-W>-
nnoremap <leader><leader>[ 20<C-W>-
nnoremap <leader>] <C-W>+
nnoremap <leader><leader>] 20<C-W>+
nnoremap <leader>{ <C-W><
nnoremap <leader>} <C-W>>

" Windows-style ctrl-up and ctrl-down: scroll the text without moving cursor.
noremap <C-Up> <C-Y>
noremap <C-Down> <C-E>
inoremap <silent> <C-Up>    <C-O><C-Y>
inoremap <silent> <C-Down>  <C-O><C-E>

inoremap <silent> <C-BS>    <C-O>db
inoremap <silent> <C-Del>   <C-O>dw

cnoremap <C-BS> <C-W>

noremap <silent> <PageUp>   <C-U>
noremap <silent> <PageDown> <C-D>

" backspace in Visual mode deletes selection
vnoremap <BS> d
" CTRL-X is Cut
vnoremap <C-X> "+x
" CTRL-C is Copy
vnoremap <C-C> "+y
" CTRL-V is Paste
noremap <C-V> "+gP
inoremap <C-V> <C-O>"+gP
cnoremap <C-V> <C-R>+

" Quick escape from insert mode.
inoremap jj <ESC>
inoremap jJ <ESC>

" Allow undoing <C-u> (delete text typed in the current line)
inoremap <C-U> <C-G>u<C-U>

" Use CTRL-Q to do what CTRL-V used to do
noremap <C-Q> <C-V>

" Use F3 to navigate among grep results
noremap <silent> <F3>   :cnext<CR> zz
noremap <silent> <S-F3> :cprev<CR> zz

" My own crazy grep program
set grepprg=~/bin/gerp.py

function! RunGrep(word)
    call inputsave()
    let l:cmdline = input('gerp /', a:word)
    call inputrestore()
    if l:cmdline == ''
        echo "No pattern entered, search aborted."
    else
        let l:words = split(l:cmdline)
        let l:pattern = shellescape(substitute(l:words[0], '[%#]', '\\&', 'g'))
        let l:options = join(l:words[1:])
        execute ':grep! %:h /' . l:pattern . ' ' . l:options
        botright copen
    endif
endfunction

noremap <Leader>s :call RunGrep('')<CR>
noremap <Leader>a :call RunGrep('<C-R><C-W>')<CR>
nnoremap <silent> <Leader>c :botright copen<CR>

" Adapted from:
" Barry Arthur 2014 06 25 Jump to the last cursor position in a File Jump
function! FileJumpLastPos(jump_type)
    let jump_mark = nr2char(getchar())
    let the_jump = a:jump_type . jump_mark
    if jump_mark =~# '[A-Z]'
        let the_jump .= "'\""
    endif
    return the_jump
endfunction

nnoremap <expr> ' FileJumpLastPos("'")
nnoremap <expr> ` FileJumpLastPos("`")

" Wrapped lines, adapted from
" http://vim.wikia.com/wiki/Move_cursor_by_display_lines_when_wrapping
noremap <silent> <Leader>r :call ToggleWrap()<CR>
function! ToggleWrap()
    if &wrap
        echo "Wrap OFF"
        setlocal nowrap
        silent! nunmap <buffer> k
        silent! nunmap <buffer> j
        silent! nunmap <buffer> <Up>
        silent! nunmap <buffer> <Down>
        silent! nunmap <buffer> <Home>
        silent! nunmap <buffer> <End>
        silent! iunmap <buffer> <Up>
        silent! iunmap <buffer> <Down>
        silent! iunmap <buffer> <Home>
        silent! iunmap <buffer> <End>
    else
        echo "Wrap ON"
        setlocal wrap
        noremap  <buffer> <silent> k        gk
        noremap  <buffer> <silent> j        gj
        noremap  <buffer> <silent> <Up>     gk
        noremap  <buffer> <silent> <Down>   gj
        noremap  <buffer> <silent> <Home>   g<Home>
        noremap  <buffer> <silent> <End>    g<End>
        inoremap <buffer> <silent> <Up>     <C-o>gk
        inoremap <buffer> <silent> <Down>   <C-o>gj
        inoremap <buffer> <silent> <Home>   <C-o>g<Home>
        inoremap <buffer> <silent> <End>    <C-o>g<End>
    endif
endfunction

" YankStack
let g:yankstack_map_keys = 0
nmap <C-t> <Plug>yankstack_substitute_older_paste
nmap <C-n> <Plug>yankstack_substitute_newer_paste

call yankstack#setup()

" Maps for yanking and pasting need to be after here, so that yankstack won't
" clobber them.

" Yank from the cursor to the end of the line, to be consistent with C and D.
nnoremap Y y$

" Why should deleting a single character save that character?
nnoremap x "_x
nnoremap X "_X

" Custom formatters
if has("python")
    python << EOF_PY
import json, vim, sys

def pretty_xml(x):
    """Make xml string `x` nicely formatted."""
    # Hat tip to http://code.activestate.com/recipes/576750/
    import xml.dom.minidom as md
    new_xml = md.parseString(x.strip()).toprettyxml(indent=' '*2)
    return '\n'.join([line for line in new_xml.split('\n') if line.strip()])

def pretty_json(j):
    """Make json string `j` nicely formatted."""
    return json.dumps(json.loads(j), sort_keys=True, indent=4)

prettiers = {
    'xml':  pretty_xml,
    'json': pretty_json,
    }

def pretty_it(datatype):
    b = vim.current.buffer
    content = "\n".join(b)
    content = prettiers[datatype](content)
    b[:] = str(content).split('\n')
EOF_PY

    command! Pxml :python pretty_it('xml')
    command! Pjson :python pretty_it('json')
endif
