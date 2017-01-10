" Ned's .vimrc file

filetype off

" Windows thinks personal vim stuff should be in ~/vimfiles, make it look in ~/.vim instead
set runtimepath=~/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,~/.vim/after

" To install a vimball (XYZ, for example):
"   $ mkdir ~/.vim/bundle/XYZ
"   $ vim XYZ.vmb
"   :UseVimball ~/.vim/bundle/XYZ

"set directory=/var/tmp//,/tmp//,$TEMP   " Store swp files, with full paths
set directory-=.                        " Don't store .swp files in the current directory
set updatecount=0                       " Don't create .swp files at all.
if filewritable(expand('~/.backup'))
    set backup backupdir=~/.backup      " Keep copies of files we're editing
endif
set shortmess+=I                        " Don't show the vim intro message
set history=500                         " Keep a LOT of history for commands
set scrolloff=2                         " Keep two lines visible above/below the cursor when scrolling.

set showmatch                           " Blink matching punctuation

set modeline modelines=2                " Read vim settings from the file itself
set encoding=utf-8
set fileformat=unix fileformats=unix,dos
set wildignore=*.o,*~,*.pyc

set foldmethod=syntax foldlevelstart=999

" Line numbering
set number                              " Turn on line numbering
if exists('+numberwidth')
    set numberwidth=5                   " with space for at least four digits (plus 1 for space)
endif

" mac iTerm2 cursor control for insert mode.
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

set t_Co=256

set showcmd                             " Show partial commands in the status line
if has("syntax")
    syntax on                           " Turn on syntax coloring
endif
colorscheme nedsterm                    " Color scheme to use for terminals.

if exists('+colorcolumn')
    set colorcolumn=80
endif

set tabstop=8                           " Real tab characters take up 8 spaces
set softtabstop=4                       "   but indent by 4 when typing tab while editing.
set expandtab                           " Use spaces when hitting the tab key
set shiftwidth=4                        "   and shift by 4 spaces when indenting.
set shiftround                          " When indenting, round to a multiple of shiftwidth.
set autoindent                          " Pick the indent for a line from the previous line.
set nosmarttab                          " Tabs always means the same thing, don't be too smart.
set indentkeys=o,O                      " Only new lines should get auto-indented.

filetype plugin indent on               " Use the filetype to load syntax, plugins and indent files.
set autoread                            " Re-read a file if it changed behind vim's back.
set hidden                              " Allow a modified buffer to become hidden.
set nowrap                              " When I want to be confused by wrapped lines, I'll do it manually.
set linebreak                           "   but when I do wrap, I want word wrap, not character.
set display=lastline,uhex               " Display as much as possible of a last line, and ctrl chars in hex.
set ignorecase smartcase                " If all lower-case, match any case, else be case-sensitive
set virtualedit=onemore                 " One virtual character at the ends of lines, makes ^V work properly.
set fillchars=vert:\ ,fold:-,diff:·     " Spaces are enough for vertical split separators.
set diffopt=filler,foldcolumn:0         " Show lines where missing, no need for a foldcolumn during diff.

set noerrorbells                        " Don't ring the bell on errors
set visualbell t_vb=                    "   and don't flash either.
set timeoutlen=1000 ttimeoutlen=50      " Set timeouts so that terminals act briskly.

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


""
"" Undo
""

" Adapted from https://gist.github.com/mllg/5353184
function! CleanOldFiles(path, days)
    let l:path = expand(a:path)
    if isdirectory(l:path)
        for file in split(globpath(l:path, "*"), "\n")
            if localtime() > getftime(file) + 86400 * a:days && delete(file) != 0
                echo "CleanOldFiles(): Error deleting '" . file . "'"
            endif
        endfor
    else
        echo "CleanOldFiles(): Directory '" . l:path . "' not found"
    endif
endfunction

if exists("+undofile")
    let my_undodir = $HOME . '/.vimundo'
    if !isdirectory(my_undodir)
        if exists("*mkdir")
            call mkdir(my_undodir)
        endif
    endif
    if isdirectory(my_undodir)
        set undofile undodir=~/.vimundo         " Save undo's after file closes
        set undolevels=1000                     " How many undos
        set undoreload=10000                    " Number of lines to save for undo

        " Remove undo files which have not been modified for 2 days.
        call CleanOldFiles(&undodir, 2)
    endif
endif


""
"" Status line
""

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
    let slug = len(getloclist(0)) > 0 ? 'Location' : 'Quickfix'
    let title = '     ' . slug
    if exists('w:quickfix_title')
        let title .= ': '
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

augroup QuickFixSettings
    autocmd!
    autocmd FileType qf let &l:statusline = '%{StatusQuickfixTitle()}%=%l of %L  %P '
    autocmd FileType qf setlocal nobuflisted colorcolumn= cursorline
    autocmd FileType qf nnoremap <silent> <buffer> ,            :colder<CR>
    autocmd FileType qf nnoremap <silent> <buffer> .            :cnewer<CR>
    autocmd FileType qf nnoremap <silent> <buffer> q            :quit\|:wincmd b<CR>
    autocmd FileType qf nnoremap <silent> <buffer> <Leader>c    :cclose<CR>
    " <Leader>a in quickfix means re-do the search.
    autocmd FileType qf nnoremap <expr>   <buffer> <Leader>a    ':<C-U>silent grep! ' . join(split(w:quickfix_title)[1:])
    " <Leader>s means start a new search, but from the same place.
    autocmd FileType qf nnoremap <expr>   <buffer> <Leader>s    ':<C-U>silent grep! ' . split(w:quickfix_title)[1] . ' /'
augroup end

augroup HelpSettings
    autocmd!
    autocmd FileType help let &l:statusline = ' Help: %f%=%P '
    autocmd FileType help setlocal colorcolumn=
    autocmd FileType help nnoremap <silent> <buffer> q :quit<CR>
augroup end

augroup GitCommitSettings
    autocmd!
    " auto-fill paragraphs
    autocmd FileType gitcommit setlocal formatoptions+=a
    autocmd FileType gitcommit DiffGitCached | wincmd r
augroup end

augroup HgCommitSettings
    autocmd!
    autocmd FileType hgcommit setlocal formatoptions+=a
    autocmd BufRead,BufNewFile hg-editor-*.txt set filetype=hgcommit
augroup end

augroup RstSettings
    autocmd!
    autocmd FileType rst setlocal textwidth=79
augroup end

augroup ScssSettings
    autocmd!
    autocmd FileType scss set iskeyword+=-
augroup end

augroup VagrantSettings
    autocmd!
    autocmd BufRead,BufNewFile Vagrantfile set filetype=ruby
augroup end

augroup XmlSettings
    autocmd!
    autocmd BufRead,BufNewFile *.px,*.bx set filetype=xml
" Suggested by fmoralesc, but doesn't work yet.  XML doesn't spell check
" regular text?
"    autocmd FileType xml syntax match xmlAURL /["']\zs.*\ze["']/ contained containedin=xmlString contains=@NoSpell transparent
"    autocmd FileType xml syntax spell default
augroup end

augroup AllFileSettings
    autocmd!
    " Don't want balloons ever. If anyone turns them on, turn them off.
    autocmd OptionSet ballooneval if &ballooneval | set noballooneval | endif
augroup end

" Abbreviations
iabbrev pdbxx   import pdb,sys as __sys;__sys.stdout=__sys.__stdout__;pdb.set_trace() # -={XX}=-={XX}=-={XX}=-        
iabbrev pudbxx  import pudb,sys as __sys;__sys.stdout=__sys.__stdout__;pudb.set_trace() # -={XX}=-={XX}=-={XX}=-        
iabbrev staxxx  import inspect;print("\n".join("%30s : %s @%d" % (t[3], t[1], t[2]) for t in inspect.stack()[:0:-1]))          

iabbrev loremx      lorem ipsum quia dolor sit amet consectetur adipisci velit, sed quia non numquam eius modi tempora incidunt.
iabbrev loremxx     lorem ipsum quia dolor sit amet consectetur adipisci velit, sed quia non numquam eius modi tempora incidunt, ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam.
iabbrev loremxxx    lorem ipsum quia dolor sit amet consectetur adipisci velit, sed quia non numquam eius modi tempora incidunt, ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit, qui in ea voluptate velit esse, quam nihil molestiae consequatur, vel illum, qui dolorem eum fugiat, quo voluptas nulla pariatur.

" Digraphs: frown and smile
digraph :( 9785 :) 9786

" ./ in the command line expands to the directory of the current file,
"   but ../ works without an expansion.
cnoremap <expr> ./ getcmdtype() == ':' ? expand('%:p:h').'/' : './'
cnoremap ../ ../

" Highlight conflict markers.
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

" Create undo break point when you pause typing for 2 sec.
set updatetime=2000
autocmd CursorHoldI * call feedkeys("\<C-G>u", "nt")

""
"" Plugins
""

" https://github.com/junegunn/vim-plug
" 'silent!' here to keep it from complaining if there's no "git" installed.
silent! call plug#begin()

Plug 'kshenoy/vim-signature'
let g:SignatureIncludeMarks = 'abcdefghijklmnopqrstuvwxyz'

Plug 'will133/vim-dirdiff', { 'on': 'DirDiff' }

Plug 'ctrlpvim/ctrlp.vim', { 'on': 'CtrlP' }
noremap <silent> <Leader>e :CtrlP<CR>
"let g:ctrlp_map = '<silent><Leader>e'
"let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_custom_ignore = {
    \ 'dir': '\v/htmlcov$',
    \ }
let g:ctrlp_max_height = 30
let g:ctrlp_mruf_max = 1000
let g:ctrlp_mruf_exclude = '^/private/var/folders/.*\|.*hg-editor-.*\|.*fugitiveblame$'
let g:ctrlp_open_multiple_files = '2vjr'
let g:ctrlp_prompt_mappings = {
    \ 'ToggleType(1)': ['<C-F>', '<C-Up>', ',', '<Space>'],
    \ }
let g:ctrlp_root_markers = ['.treerc']

Plug 'pearofducks/ansible-vim'
let g:ansible_attribute_highlight = 'ab'    " highlight all attributes, brightly.
let g:ansible_name_highlight = 'd'

Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
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

noremap <silent> <Leader><Leader>f :echo expand('%:p') . " (cd: " . getcwd() . ")"<CR>

Plug 'majutsushi/tagbar'                            " Tagbar, no 'on', so that statusbar will have tags
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

let g:tagbar_type_rst = {
    \ 'ctagstype': 'rst',
    \ 'ctagsbin': expand('~/.vim/plugged/rst2ctags/rst2ctags.py'),
    \ 'ctagsargs' : '-f - --sort=yes',
    \ 'kinds' : [
        \ 's:sections',
        \ 'i:images'
    \ ],
    \ 'sro' : '|',
    \ 'kind2scope' : {
        \ 's' : 'section',
    \ },
    \ 'sort': 0,
\ }

Plug 'mattn/webapi-vim'
Plug 'mattn/gist-vim', { 'on': 'Gist' }
let g:gist_clip_command = 'pbcopy'
let g:gist_detect_filetype = 1
let g:gist_post_private = 1

Plug 'lfv89/vim-interestingwords'
" This was useful: http://htmlcolorcodes.com/color-chart/
let g:interestingWordsGUIColors = [
    \ '#F0C0FF', '#A7FFB7', '#FFB7B7', '#A8D1FF', '#AAFFFF',
    \ '#FCFA69', '#CCCCCC', '#F39C12', '#D6D450', '#999999',
    \ '#A569BD', '#27AE60', '#DB5345', '#3E96D1', '#B78264',
    \ ]
noremap <silent> <Leader><Leader>k :call RecolorAllWords()<CR>

Plug 'klen/python-mode'
let g:pymode_folding = 1
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
let g:pymode_virtualenv = 1

Plug 'tpope/vim-fugitive'                           " No 'on': it's in the statusbar
Plug 'tpope/vim-rhubarb'                            " GitHub support for fugitive
noremap <Leader>gb :Gblame<CR>
noremap <Leader>gu :Gbrowse!<CR>
noremap <Leader>gv :Gbrowse<CR>

Plug 'tpope/vim-git'                                " Git filetypes, etc.
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-repeat'

Plug 'kana/vim-textobj-user'
Plug 'Julian/vim-textobj-variable-segment'
Plug 'kana/vim-textobj-line'                        " Whole-line text object
Plug 'qstrahl/vim-dentures'                         " Indent-based text object
Plug 'vim-utils/vim-space'                          " Space text object: di<Space>

Plug 'wellle/visual-split.vim'
noremap <Leader>* :VSSplit<CR>
noremap <Leader><Leader>* :VSResize<CR>

Plug 'jszakmeister/rst2ctags'                       " Tag support for .rst files
Plug 'gregsexton/MatchTag'                          " Highlights paired HTML tags

Plug 'AndrewRadev/splitjoin.vim'                    " gS and gJ for smart expanding and contracting
let g:splitjoin_trailing_comma = 1
let g:splitjoin_python_brackets_on_separate_lines = 1

Plug 'junegunn/vim-peekaboo'                        " Pop-up panel to show registers
let g:peekaboo_window = 'vertical botright 50new'
let g:peekaboo_delay = 750

Plug 'tommcdo/vim-exchange'                         " cx{motion} - cx{motion} to swap things

Plug 'atimholt/spiffy_foldtext'
let g:SpiffyFoldtext_format = "%c %<%f{ }=( %n )=%l{/=}"

Plug 'cakebaker/scss-syntax.vim', { 'for': 'scss' }
Plug 'hail2u/vim-css3-syntax', { 'for': ['css', 'scss'] }
Plug 'sk1418/QFGrep'                                " Filter quickfix: \g \v \r

Plug 'editorconfig/editorconfig-vim'                " Obey .editorconfig files
let g:EditorConfig_preserve_formatoptions = 1

Plug 'bogado/file-line'                             " Enables opening and jumping to line with: foo.txt:345
Plug 'vim-utils/vim-husk'                           " Ctrl-A, Ctrl-E, etc, in the command line.

Plug 'szw/vim-maximizer', { 'on': 'MaximizerToggle' }   " Maximize current split
noremap <Leader>+ :MaximizerToggle!<CR>

Plug 'AndrewRadev/sideways.vim'                     " Function argument text objects and movement
noremap <Leader>, :SidewaysLeft<CR>
noremap <Leader>. :SidewaysRight<CR>
omap aa <Plug>SidewaysArgumentTextobjA
xmap aa <Plug>SidewaysArgumentTextobjA
omap ia <Plug>SidewaysArgumentTextobjI
xmap ia <Plug>SidewaysArgumentTextobjI

Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }  " Display undotree

call plug#end()

""
"" Custom functions
""

" Run a command, but keep the output in a buffer.
command! -nargs=+ -complete=command BufOut call <SID>BufOut(<q-args>)
function! <SID>BufOut(cmd)
    redir => output
    silent execute a:cmd
    redir END
    if empty(output)
        echoerr "no output"
    else
        new
        setlocal buftype=nofile bufhidden=wipe noswapfile nomodified
        execute('file [Scratch '.bufnr('%').': '.a:cmd.' ]')
        silent put =output
    endif
endfunction

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
function! <SID>DiffTheseCommand()
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

" From https://github.com/garybernhardt/dotfiles/blob/master/.vimrc
command! RemoveFancyCharacters :call <SID>RemoveFancyCharacters()
function! <SID>RemoveFancyCharacters()
    let typo = {}
    let typo["“"] = '"'
    let typo["”"] = '"'
    let typo["‘"] = "'"
    let typo["’"] = "'"
    "let typo["–"] = '--'
    let typo["—"] = '--'
    let typo["…"] = '...'
    execute ":%s/".join(keys(typo), '\|').'/\=typo[submatch(0)]/ge'
endfunction

" Show the syntax highlight group for the current character.
map <silent><Leader>h :echo
\ "hi=" . synIDattr(synID(line("."),col("."),1),"name") .
\ " trans=" . synIDattr(synID(line("."),col("."),0),"name") .
\ " lo=" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name")<CR>
map <silent><Leader><Leader>h :source $VIMRUNTIME/syntax/hitest.vim<CR>

" Shortcuts to things I want to do often.
noremap <Leader>p gwap
noremap <Leader><Leader>p gw}
nnoremap coa :setlocal <C-R>=(&formatoptions =~# "a") ? 'formatoptions-=a' : 'formatoptions+=a'<CR><CR>

noremap <silent> <Leader>q :quit<CR>
noremap <silent> <Leader><Leader>q :Bclose<CR>
noremap <Leader>w :write<CR>
noremap <Leader><Leader>w :wall<CR>
noremap <Leader>x :exit<CR>

noremap <Leader>2 :setlocal shiftwidth=2 softtabstop=2<CR>
noremap <Leader>4 :setlocal shiftwidth=4 softtabstop=4<CR>
noremap <Leader>8 :setlocal shiftwidth=8 softtabstop=8<CR>

" Toggle list mode to see special characters.
set listchars=tab:>-,eol:$,trail:-

" Show only one window on the screen, but keep the explorers open.
noremap <silent> <Leader>1 :only!\|:NERDTreeToggle\|:vertical resize 30\|:wincmd b<CR>
noremap <silent> <Leader><Leader>1 :only!<CR>

" More intuitive splits.
nnoremap <Leader>_ <C-W>s
nnoremap <Leader><Bar> <C-W>v
nnoremap <Leader><Leader>_ :only!<CR><C-W>s
nnoremap <Leader><Leader><Bar> :only!<CR><C-W>v
autocmd VimResized * :wincmd =

" Selecting things: last modified text (good for after pasting); everything.
noremap <Leader>v `[v`]
noremap <Leader><Leader>v ggVG

" Adapted from https://gist.github.com/dahu/6ff4de11ca9c5bb25902
" Toggle colorcolumn..
"   .. at start of line
nnoremap <silent> <Leader>i :exe "normal m`^\<Leader>\<Leader>i``"<CR>
"   .. at cursor
nnoremap <silent> <Leader><Leader>i :exe 'set cc'.(&cc =~ virtcol('.')?'-=':'+=').virtcol('.')<CR>

" Backspace and cursor keys wrap to previous/next line.
set backspace=indent,eol,start
set whichwrap+=<,>,[,]
set t_kb=                           " Use the delete key for backspace (the blot is ^?)

" Indenting in visual mode keeps the visual highlight.
vnoremap < <gv
vnoremap > >gv
" Indent in visual, but don't adjust relative indents in the block.
vnoremap <Leader>< <Esc>:setlocal noshiftround<CR>gv<:setlocal shiftround<CR>gv
vnoremap <Leader>> <Esc>:setlocal noshiftround<CR>gv>:setlocal shiftround<CR>gv

" Remove annoying F1 help.
inoremap <F1> <Nop>
nnoremap <F1> <Nop>
vnoremap <F1> <Nop>

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
noremap <silent> <C-Tab>        <C-W><C-W>

" Control-H etc navigate among windows.
nnoremap <C-H> <C-W>h
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l

" Easier sizing of windows.
nnoremap <Leader>[ <C-W>-
nnoremap <Leader><Leader>[ 20<C-W>-
nnoremap <Leader>] <C-W>+
nnoremap <Leader><Leader>] 20<C-W>+
nnoremap <Leader>{ <C-W><
nnoremap <Leader><Leader>{ 20<C-W><
nnoremap <Leader>} <C-W>>
nnoremap <Leader><Leader>} 20<C-W>>

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
inoremap jj <Esc>
inoremap jJ <Esc>
inoremap qqj <Esc>
" Quick one-command escape from insert mode.
inoremap qqo <C-O>
inoremap qqp <C-O>gwap

" Allow undoing <C-U> (delete text typed in the current line)
inoremap <C-U> <C-G>u<C-U>

" Easier access to completions
inoremap <C-L> <C-X><C-L>
inoremap <C-N> <C-X><C-N>
inoremap <C-P> <C-X><C-P>

" Use CTRL-Q to do what CTRL-V used to do
noremap <C-Q> <C-V>

" Searching
set incsearch                           " Use incremental search
set hlsearch                            " Highlight search results in the file.
nnoremap <Leader>n nzvzz
nnoremap <Leader>N Nzvzz
" <C-L> was redraw, make it \z
nnoremap <Leader>z :nohlsearch<CR><C-L>
nnoremap <Leader><Leader>z :nohlsearch<CR>zvzz<C-L>

" My own crazy grep program
set grepprg=~/bin/gerp.py

function! RunGrep(word)
    call inputsave()
    let l:cmdline = input('gerp /', a:word)
    call inputrestore()
    if l:cmdline == ''
        echo "No pattern entered, search aborted."
    else
        " Create the gerp command line.
        let l:words = split(l:cmdline)
        let l:pattern = shellescape(substitute(l:words[0], '[%#]', '\\&', 'g'))
        let l:options = join(l:words[1:])
        execute ':silent grep! % /' . l:pattern . ' ' . l:options
        " Force recalculation of all the buffer names. This makes the results
        " uniform in terms of absolute/relative pathnames.
        silent cd .
        " rg returns results non-contiguously
        call QfSortEntries()
        botright copen
    endif
endfunction

" Inspired by https://github.com/jboner/vim-config/blob/master/autoload/l9/quickfix.vim#L62-L82
" Compares quickfix entries for sorting.
function QfCompareEntries(e0, e1)
    if a:e0.bufnr != a:e1.bufnr
        let i0 = bufname(a:e0.bufnr)
        let i1 = bufname(a:e1.bufnr)
    elseif a:e0.lnum != a:e1.lnum
        let i0 = a:e0.lnum
        let i1 = a:e1.lnum
    elseif a:e0.col != a:e1.col
        let i0 = a:e0.col
        let i1 = a:e1.col
    else
        return 0
    endif
    return (i0 > i1 ? +1 : -1)
endfunction

" Sorts quickfix
function QfSortEntries()
    " Grab the window title, restore it later. setqflist() clobbers the title.
    let l:info = getqflist({'title': 1})
    call setqflist(sort(getqflist(), 'QfCompareEntries'), 'r')
    call setqflist([], 'r', l:info)
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

nnoremap gj j
nnoremap gk k
nnoremap j gj
nnoremap k gk


" Yank from the cursor to the end of the line, to be consistent with C and D.
nnoremap Y y$

" qq to record, Q to replay (thanks, junegunn)
nnoremap Q @q

" Figure out if Python is properly configured.
try
    python 1+1
    let python_works = 1
catch /^Vim\%((\a\+)\)\=:E/ 
    let python_works = 0
endtry

" Custom formatters
if python_works
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
