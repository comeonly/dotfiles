" encoding
set encoding=utf-8
scriptencoding utf-8
set fileencoding=utf-8
set fileencodings=ucs-boms,utf-8,euc-jp,cp932
set fileformats=unix,dos,mac
set ambiwidth=double
""""""""""""""""""""
" Vundle
" git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
" vim +PluginInstall +qall
""""""""""""""""""""
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'

Plugin 'tpope/vim-fugitive'
Plugin 'scrooloose/nerdtree'
Plugin 'tpope/vim-surround'
Plugin 'airblade/vim-gitgutter'
Plugin 'kien/ctrlp.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'scrooloose/nerdcommenter'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'mattn/emmet-vim'
Plugin 'godlygeek/tabular'
Plugin 'tpope/vim-repeat'
Plugin 'w0rp/ale'
Plugin 'easymotion/vim-easymotion'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'Raimondi/delimitMate'
Plugin 'tpope/vim-unimpaired'
Plugin 'ap/vim-css-color'
Plugin 'jeetsukumaran/vim-buffergator'

Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'ervandew/supertab'

Plugin 'sheerun/vim-polyglot'

Plugin 'altercation/vim-colors-solarized'

call vundle#end()
filetype plugin indent on
""""""""""""""""""""
" base settings
""""""""""""""""""""
" tab indent
set expandtab
set tabstop=4 softtabstop=4 shiftwidth=4
set autoindent
set smartindent

" search
set incsearch
set ignorecase
set smartcase
set hlsearch

" cursor
set whichwrap=b,s,h,l,<,>,[,]
set cursorline
set backspace=indent,eol,start
set scrolljump=5
set scrolloff=3

" wild settings
set wildmenu
set wildmode=list:longest,full
set wildignore+=*.o,*.out,*.obj,.git,*.rbc,*.rbo,*.class,.svn,*.gem
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz
set wildignore+=*/vendor/gems/*,*/vendor/cache/*,*/.bundle/*,*/.sass-cache/*
set wildignore+=*/tmp/librarian/*,*/.vagrant/*,*/.kitchen/*,*/vendor/cookbooks/*
set wildignore+=*/tmp/cache/assets/*/sprockets/*,*/tmp/cache/assets/*/sass/*
set wildignore+=*.swp,*~,._*

" file save
set history=700
set undofile
set undodir=~/.vim/_undodir
set nobackup
set nowb
set noswapfile
set confirm
set hidden

" special charactors
set list
set listchars=tab:▸\ ,extends:>,trail:.,precedes:<
function! ZenkakuSpace()
    highlight ZenkakuSpace cterm=reverse ctermfg=DarkMagenta gui=reverse guifg=DarkMagenta
endfunction
if has('syntax')
    augroup ZenkakuSpace
        autocmd!
        autocmd ColorScheme       * call ZenkakuSpace()
        autocmd VimEnter,WinEnter * match ZenkakuSpace /　/
    augroup END
    call ZenkakuSpace()
endif

" color
set background=dark
let g:solarized_visibility = 'high'
let g:solarized_contrast = 'high'
let g:solarized_termcolors = 16
let g:solarized_termtrans = 1
colorscheme solarized

" mouse
if has('mouse')
    set mouse=a
    if has('mouse_sgr')
        set ttymouse=sgr
    elseif v:version > 703 || v:version is 703 && has('patch632')
        set ttymouse=sgr
    else
        set ttymouse=xterm2
    endif
endif

" save cursor position
if has('autocmd')
  augroup redhat
    " When editing a file, always jump to the last cursor position
    autocmd BufReadPost *
    \ if line("'\"") > 0 && line ("'\"") <= line("$") |
    \   exe "normal! g'\"" |
    \ endif
  augroup END
endif

" Cursor in terminal
" https://vim.fandom.com/wiki/Configuring_the_cursor
" 1 or 0 -> blinking block
" 2 solid block
" 3 -> blinking underscore
" 4 solid underscore
" Recent versions of xterm (282 or above) also support
" 5 -> blinking vertical bar
" 6 -> solid vertical bar
if &term =~ '^xterm'
    " normal mode
    let &t_EI .= "\<Esc>[0 q"
    " insert mode
    let &t_SI .= "\<Esc>[6 q"
endif

" window
set number
set ruler
set splitright

" misc
set nojoinspaces
set complete+=k
set completeopt-=preview
set laststatus=2
syntax enable
set nospell
set nofoldenable
""""""""""""""""""""
" filetype settings
""""""""""""""""""""
" augroup fileTypeIndent
"     autocmd!
"     autocmd BufNewFile,BufRead *.vue setlocal tabstop=2 softtabstop=2 shiftwidth=2
"     autocmd BufNewFile,BufRead *.js setlocal tabstop=2 softtabstop=2 shiftwidth=2
" augroup END
" autocmd FileType vue syntax sync fromstart
""""""""""""""""""""
" plugin settings
""""""""""""""""""""
let g:snips_author = 'Atunori Kamori <atunori.kamori@gmail.com>'

let g:UltiSnipsExpandTrigger='<C-j>'
let g:UltiSnipsJumpForwardTrigger='<C-j>'
let g:UltiSnipsJumpBackwardTrigger='<C-k>'

let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git\|vendor'

let g:airline_powerline_fonts = 1
let g:airline_theme='tomorrow'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'

let NERDTreeShowBookmarks=1
let NERDTreeIgnore=['\.pyc', '\~$', '\.swo$', '\.swp$', '\.DS_Store', '\.hg', '\.svn', '\.bzr']
let NERDTreeChDirMode=0
let NERDTreeQuitOnOpen=1
let NERDTreeMouseMode=2
let NERDTreeShowHidden=1
let NERDTreeKeepTreeInNewTab=1
let g:NERDTreeWinSize=30

let g:indent_guides_guide_size = 1
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_exclude_filetypes = ['help', 'nerdtree']

let g:ale_php_phpcs_standard = 'PSR2'
let g:ale_php_phpmd_executable = '$HOME/.composer/vendor/bin/phpmd'

let NERDSpaceDelims = 1
let g:ft = ''
""""""""""""""""""""
" map
""""""""""""""""""""
map <leader>n :NERDTreeToggle<CR>
cmap w!! w !sudo tee % >/dev/null
map Q gq
map <Down> gj
map <Up> gk
map j gj
map k gk
map <leader>h1 VypVr=
map <leader>h2 VypVr-

