set nocompatible               " be iMproved
filetype off                   " required!
"filetype plugin on

set ttyfast

let s:editor_root=expand("~/.config/nvim")

let &rtp = &rtp . ',' . s:editor_root . '/dein/github.com/Shougo/dein.vim/'
call dein#begin(s:editor_root . '/dein')
call dein#add('Shougo/dein.vim')


call dein#add('surround.vim')
call dein#add('SuperTab')
call dein#add('endwise.vim')
call dein#add('Syntastic')
call dein#add('matchit.zip')
call dein#add('L9')
call dein#add('FuzzyFinder')
call dein#add('vim-json-bundle')
call dein#add('editorconfig/editorconfig-vim')

call dein#add('rstacruz/sparkup', {'rtp': 'vim/'})
call dein#add('flazz/vim-colorschemes')
call dein#add('tpope/vim-fugitive')
call dein#add('tpope/vim-repeat')
call dein#add('koron/nyancat-vim')

" Navigation
call dein#add('scrooloose/nerdcommenter')
call dein#add('scrooloose/nerdtree')

" TMux navigation helper
call dein#add('christoomey/vim-tmux-navigator')
call dein#add('jgdavey/tslime.vim')

" Searching
call dein#add('mileszs/ack.vim')
call dein#add('kien/ctrlp.vim')

" Language Syntax
call dein#add('vim-coffee-script')
call dein#add('jnwhiteh/vim-golang')
call dein#add('groenewege/vim-less')
call dein#add('mustache/vim-mustache-handlebars')

" Ruby-specific
call dein#add('vim-ruby/vim-ruby')
call dein#add('ngmy/vim-rubocop')
call dein#add('ecomba/vim-ruby-refactoring')
call dein#add('thoughtbot/vim-rspec')

call dein#end()

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

if has('nvim')
  " Terminal mode esc using leader, in case a terminal app needs to listen to Esc
  tnoremap <leader><Esc> <C-\><C-n>
endif

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
noremap <C-l> <C-w>l

inoremap jk <Esc>
nnoremap JJJJ <Nop>

" CtrlP
"unlet g:ctrlp_user_command

set wildignore+=vendor/gems,tmp/*,coverage,public,spec/javascripts/generated,db/bootstrap/,*/db/migrate/,node_modules/*,dist/*,*/tmp/*
set wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn,*.json,*.pdf,*.epub,*.ipa,*.jpeg,*.jpg,*.log,*.cache,*.sublime-project,*.sublime-workspace

let g:ctrlp_custom_ignore = {
  \ 'dir': 'node_modules\|dist\|tmp\|bower_components',
  \ 'file': '\.sublime-\w*',
  \ }

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

" Setup Rspec to send command to another rmux pane
let g:rspec_command = 'call Send_to_Tmux("bundle exec rspec {spec}\n")'

" Ensure Send_to_Tmux() always goes to the current session and window
let g:tslime_always_current_session = 1
let g:tslime_always_current_window  = 1

" Set ack search command to ignore non-useful directories
let g:ack_default_options = " -s -H --no-color --no-group --column --ignore-dir=coverage --ignore-dir=log --ignore-dir=tmp --ignore-dir=dist --ignore-dir=node_modules"

set autoread
let NERDTreeIgnore=[]
