set nocompatible               " be iMproved
filetype off                   " required!
"filetype plugin on

set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#begin()

" let Vundle manage Vundle
" required!
Bundle 'VundleVim/Vundle.vim'

Plugin 'surround.vim'
Plugin 'SuperTab'
Plugin 'endwise.vim'
Plugin 'Syntastic'
Plugin 'matchit.zip'
Plugin 'L9'
Plugin 'FuzzyFinder'
Plugin 'vim-json-bundle'

Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
Plugin 'flazz/vim-colorschemes'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-repeat'
Plugin 'koron/nyancat-vim'

" Navigation
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'

" Searching
Plugin 'ack.vim'
Plugin 'kien/ctrlp.vim'

" Language Syntax
Plugin 'vim-coffee-script'
Plugin 'jnwhiteh/vim-golang'
Plugin 'groenewege/vim-less'
Plugin 'mustache/vim-mustache-handlebars'

" Ruby-specific
Plugin 'vim-ruby/vim-ruby'
Plugin 'ngmy/vim-rubocop'
Plugin 'ecomba/vim-ruby-refactoring'
Plugin 'thoughtbot/vim-rspec'

call vundle#end()

filetype plugin indent on     " required!
"
" Brief help
" :PluginList          - list configured bundles
" :PluginInstall(!)    - install(update) bundles
" :PluginSearch(!) foo - search(or refresh cache first) for foo
" :PluginClean(!)      - confirm(or auto-approve) removal of unused bundles
"
" see :h vundle for more details or wiki for FAQ
" NOTE: comments after Bundle command are not allowed..

let mapleader = ";"
colorscheme jellybeans
syntax on
set t_RV=0 " STOP PUTTING ME INTO REPLACE/CHANGE MODE!!!

" line number
set nu

" tabs
set expandtab
set shiftwidth=2
set softtabstop=2

" no wraps
set nowrap

set scrolloff=3

" Searching
set hlsearch
set incsearch

"set cursorline

"remove right-hand scroll bar
set guioptions-=r

set statusline=%F[%{strlen(&fenc)?&fenc:'none'},%{&ff}]%h%m%r%y%=%c,%l/%L\ %P
set laststatus=2
set lazyredraw

nmap Y y$
nmap <space> zz
nnoremap <esc> :noh<return><esc>
map <leader>e :NERDTreeToggle<cr>
map <leader>f :NERDTreeFind<cr>
let g:NERDTreeWinSize = 40

nnoremap j gj
nnoremap k gk
map <D-j> gT
map <D-k> gt

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
noremap <C-l> <C-w>l

inoremap jk <Esc>
nnoremap JJJJ <Nop>

" CtrlP
"unlet g:ctrlp_user_command

set wildignore+=vendor/gems,tmp/*,coverage,public,spec/javascripts/generated,db/bootstrap/,*/db/migrate/
set wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn,*.json,*.pdf,*.epub,*.ipa,*.jpeg,*.jpg,*.log,*.cache

nmap <D-t> :CtrlP<cr>
let g:ctrlp_match_window_bottom = 0
let g:ctrlp_max_height = 20
let g:ctrlp_dotfiles = 0
let g:ctrlp_switch_buffer = 2
let g:ctrlp_working_path_mode = 0
let g:ctrlp_max_files = 0
let g:ctrlp_max_depth = 40


" Save on focus lost
au FocusLost * :wa

" Remove trailing whitespace
autocmd BufWritePre * :%s/\s\+$//e

" Open the next item and keeping the focus in the quickfix window
autocmd BufWinEnter quickfix noremap <buffer> j :cn<CR><C-w><C-p>

" Open the previous item keeping the focus in the quickfix window
autocmd BufWinEnter quickfix noremap <buffer> k :cp<CR><C-w><C-p>

" Ignore the enter key
autocmd BufWinEnter quickfix noremap <buffer> <Enter> <Nop>

au FileType xml exe ":silent 1,$!xmllint --format --recover - 2>/dev/null"

" For local replace
nnoremap gr gd[{V%:s/<C-R>///gc<left><left><left>

" For global replace
nnoremap gR gD:%s/<C-R>///gc<left><left><left>

nnoremap <M-j> :m .+1<CR>== nnoremap <C-k> :m .-2<CR>==
inoremap <M-j> <Esc>:m .+1<CR>==gi
inoremap <M-k> <Esc>:m .-2<CR>==gi
vnoremap <M-j> :m '>+1<CR>gv=gv
vnoremap <M-k> :m '<-2<CR>gv=gv

nmap <leader>r magg=G`a<space>

nmap <silent> <leader>ul :t.<CR>Vr=

" upper/lower first char of word
nmap <leader>U mQgewvU`Q
nmap <leader>L mQgewvu`Q


" upper/lower word
nmap <leader>u mQviwU`Q
nmap <leader>l mQviwu`Q

" highlight OverLength ctermbg=red ctermfg=white guibg=#592929
" match OverLength /\%101v.\+/

command Pry :normal A<CR>binding.pry
nmap <leader>pry :Pry<CR>==

"nmap <Leader>a=> :Tabularize /=><CR>
"vmap <Leader>a=> :Tabularize /=><CR>
"nmap <Leader>a= :Tabularize /=<CR>
"vmap <Leader>a= :Tabularize /=<CR>
"nmap <Leader>a: :Tabularize /:/l0 \zs<CR>
"vmap <Leader>a: :Tabularize /:/l0 \zs<CR>

" RSpec vim bindings
map <Leader>t :call RunCurrentSpecFile()<CR>
nmap <Leader>t :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>
map <Leader>a :call RunAllSpecs()<CR>

"nmap <Leader>> :%s/:\(\w*\) .*=>/\1: /gc
"vmap <Leader>> :%s/:\(\w*\) .*=>/\1: /gc

" bye bye pry
":g/binding.pry/d

"condenses multiple blank lines
":%s/\n\{3,}/\r\r/e

"%s/"\([^"]*\)"/'\1'/gc  "Replaces double with single quotes

imap <D-/> <leader>c<space>
nmap <D-/> <leader>c<space>
vmap <D-/> <leader>c<space>

nmap <Leader>y :%y+<CR>

nmap <leader>xml :%!xmllint --format -<CR>

" Ensure correct ruby is used for linting (NOT SYSTEM RUBY)
let g:syntastic_ruby_checkers=['~/.rbenv/shims/ruby']

set autoread
let NERDTreeIgnore=[]
