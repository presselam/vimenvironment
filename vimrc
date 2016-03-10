set ruler
set expandtab
"=====[ Auto/Smart Indent ]======
set ai sm smd
"=====[ Smarter search ]=======
set incsearch
set ignorecase
set smartcase
set ts=2
set sw=2
set splitbelow
set splitright
set hlsearch
"set background=light
syntax on
set title
"           +--Disable hlsearch while loading viminfo
"           | +--Remember marks for last 500 files
"           | |    +--Remember up to 10000 lines in each register
"           | |    |      +--Remember up to 1MB in each register
"           | |    |      |     +--Remember last 1000 search patterns
"           | |    |      |     |     +---Remember last 1000 commands
"           | |    |      |     |     |
"           v v    v      v     v     v
set viminfo=h,'500,<10000,s1000,/1000,:1000
set wildmode=list:longest,full

"====[ Goto last location in non-empty files ]=======
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

filetype plugin on

"=====[ Enable Nmap command for documented mappings ]================
runtime plugin/documap.vim

"====[ Edit and auto-update this config file and plugins ]==========

augroup VimReload
autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END

Nmap           ;r   [reload .vimrc]        :source $MYVIMRC<CR>
Nmap <silent>  ;v   [Edit .vimrc]          :next $MYVIMRC<CR>
Nmap           ;vv  [Edit .vim/plugin/...] :next ~/.vim/plugin/

set t_Co=8
set t_Sf=[3%p1%dm

hi Search ctermfg=Black ctermbg=Yellow

"=====[ Make * respect smartcase and also set @/ (to enable 'n' and 'N') ]======
nmap *  :let @/ = '\<'.expand('<cword>').'\>' ==? @/ ? @/ : '\<'.expand('<cword>').'\>'<CR>:set hls<CR>

noremap <Leader>s :%s/<C-R><C-w>//<CR>
noremap <Leader>mt :!make test TEST_VERBOSE=1<CR>
noremap <Leader>mi :!make install<CR>

noremap  <F9>  :ga<CR>
"nnoremap * :set hls<CR>:exec "let @/='\\<".expand("<cword>")."\\>'"<CR>
noremap  <BS>  :set hls!<CR>
noremap  <F12> :!cvs diff -w % <Bar> colorize<CR>
nnoremap <silent> <Leader>k mk:exe 'match Search /<Bslash>%'.line(".").'l/'<CR>
"=====[ Extend a previous match ]=====================================
nnoremap //   /<C-R>/
nnoremap ///  /<C-R>/\<BAR>
"=====[ remove trailing whitespace ]==================================
Nmap <silent> <BS><BS>  [Remove trailing whitespace] mz:call TrimTrailingWS()<CR>`z

function! TrimTrailingWS ()
    if search('\s\+$', 'cnw')
        :%s/\s\+$//g
    endif
endfunction

"====[ Use persistent undo ]=================

if has('persistent_undo')
    " Save all undo files in a single location (less messy, more risky)...
    set undodir=$HOME/.VIM_UNDO_FILES

    " Save a lot of back-history...
    set undolevels=5000

    " Actually switch on persistent undo
    set undofile
endif

"=====[ Configure % key (via matchit plugin) ]==============================

" Match angle brackets...
set matchpairs+=<:>,«:»

" Match double-angles, XML tags and Perl keywords...
let TO = ':'
let OR = ','
let b:match_words =
\
\                          '<<' .TO. '>>'
\
\.OR.     '<\@<=\(\w\+\)[^>]*>' .TO. '<\@<=/\1>'
\
\.OR. '\<if\>' .TO. '\<elsif\>' .TO. '\<else\>'

" Engage debugging mode to overcome bug in matchpairs matching...
let b:match_debug = 1

"=====[ Add or subtract comments ]===============================

" Work out what the comment character is, by filetype...
autocmd FileType           *sh,awk,python,perl,perl6,ruby let b:cmt = exists('b:cmt') ? b:cmt : '#'
autocmd FileType           vim                            let b:cmt = exists('b:cmt') ? b:cmt : '"'
autocmd BufNewFile,BufRead *.vim,.vimrc                   let b:cmt = exists('b:cmt') ? b:cmt : '"'
autocmd BufNewFile,BufRead *                              let b:cmt = exists('b:cmt') ? b:cmt : '#'
autocmd BufNewFile,BufRead *.p[lm],.t                     let b:cmt = exists('b:cmt') ? b:cmt : '#'

" Work out whether the line has a comment then reverse that condition...
function! ToggleComment ()
    " What's the comment character???
    let comment_char = exists('b:cmt') ? b:cmt : '#'

    " Grab the line and work out whether it's commented...
    let currline = getline(".")

    " If so, remove it and rewrite the line...
    if currline =~ '^' . comment_char
        let repline = substitute(currline, '^' . comment_char, "", "")
        call setline(".", repline)

    " Otherwise, insert it...
    else
        let repline = substitute(currline, '^', comment_char, "")
        call setline(".", repline)
    endif
endfunction

" Toggle comments down an entire visual selection of lines...
function! ToggleBlock () range
    " What's the comment character???
    let comment_char = exists('b:cmt') ? b:cmt : '#'

    " Start at the first line...
    let linenum = a:firstline

    " Get all the lines, and decide their comment state by examining the first...
    let currline = getline(a:firstline, a:lastline)
    if currline[0] =~ '^' . comment_char
        " If the first line is commented, decomment all...
        for line in currline
            let repline = substitute(line, '^' . comment_char, "", "")
            call setline(linenum, repline)
            let linenum += 1
        endfor
    else
        " Otherwise, encomment all...
        for line in currline
            let repline = substitute(line, '^\('. comment_char . '\)\?', comment_char, "")
            call setline(linenum, repline)
            let linenum += 1
        endfor
    endif
endfunction

" Set up the relevant mappings
nmap <silent> # :call ToggleComment()<CR>j0
vmap <silent> # :call ToggleBlock()<CR>

"=====[ Auto-setup for Perl scripts and modules ]===========
augroup Perl_Setup
    autocmd!
    autocmd BufNewFile *.p[lm] 0r !file_template <afile>
    autocmd BufNewFile *.p[lm] /^[ \t]*[#].*implementation[ \t]\+here/
augroup END

"=====[ Perltidy ]===========================================================
Nmap ;p   [Perltidy the current buffer]   :w<CR>:! perltidy -pbp -b -nst %<CR>:e!<CR>
Nmap ;pp  [Perltidy diff the current buffer] :call Perltidy_diff()<CR>

function! Perltidy_diff ()
    " Work out what the tidied file will be called...
    let perl_file = expand( '%' )
    let tidy_file = perl_file . '.tdy'

    call system( 'perltidy -nst ' . perl_file . ' -o ' . tidy_file )

    " Add the diff to the right of the current window...
    set splitright
    exe ":vertical diffsplit " . tidy_file

    " Clean up the tidied version...
    call delete(tidy_file)
endfunction

"=====[ cvsdiff ]===========================================================
Nmap ;c  [cvsdiff the current buffer]  :w<CR>:!git diff<CR>
Nmap ;cc [cvsdiff diff current buffer] :call CVS_diff()<CR>

function! CVS_diff ()
    " Work out what the tidied file will be called...
    let module = readfile('CVS/Repository')
    let file = expand( '%' )
    let head_file = 'head.txt'

    "    call system( 'perltidy -nst ' . perl_file . ' -o ' . tidy_file )

    " Add the diff to the right of the current window...
    set splitright
    exe ":vertical diffsplit " . head_file

    " Clean up the head version...
    call delete(head_file)
endfunction

"====[ insert markers ]===================================================
nmap mm :call Marker()<CR>

function! Marker ()
  let comment_char = exists('b:cmt') ? b:cmt : '#'
  let currline = getline('.')

  let marker = comment_char . '====[ ' . currline . ' ]' . repeat('=', 51-len(currline))

  let indx = line('.')
  call append(indx -1, marker)

endfunction


