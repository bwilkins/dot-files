{ pkgs, config, ... }:

{
  programs.neovim = {
    enable = true;

    withRuby = false;
    withPython3 = true;

    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      # dealing with parens
      vim-surround

      # tab completion
      supertab

      # auto-add end after 'do'
      vim-endwise

      syntastic
      matchit-zip
      vim-json

      editorconfig-vim
      sparkup
      vim-colorschemes
      vim-css-color
      vim-fugitive
      vim-repeat

      # navigation
      nerdcommenter
      nerdtree

      # tmux integration
      vim-tmux-navigator
      tslime-vim

      # Searching
      neovim-fuzzy

      # Language syntax/support
      vim-ruby
      vim-nix
      vim-orgmode
    ];

    extraConfig = ''
      set nocompatible
      filetype off
      set ttyfast

      filetype plugin indent on
      colorscheme jellybeans

      set nu
      " set nowrap

      set expandtab
      set tabstop=2
      set softtabstop=2
      set shiftwidth=2

      set nobackup
      set nowritebackup
      set noswapfile

      set hidden

      set ignorecase
      set smartcase

      let mapleader = ';'

      set scrolloff=3

      set hlsearch
      set incsearch

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
			map <C-j> gT
			map <C-k> gt

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

			set wildignore+=vendor/gems,tmp/*,coverage,public,spec/javascripts/generated,db/bootstrap/,*/db/migrate/,node_modules/*,dist/*,*/tmp/*
			set wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn,*.json,*.pdf,*.epub,*.ipa,*.jpeg,*.jpg,*.log,*.cache,*.sublime-project,*.sublime-workspace

      let g:ctrlp_custom_ignore = {
      \ 'dir': 'node_modules\|dist\|tmp\|bower_components',
      \ 'file': '\.sublime-\w*',
      \ }

      nmap <C-p> :FuzzyOpen<cr>


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

      " move lines around in different modes
      nnoremap <M-j> :m .+1<CR>==
      nnoremap <M-k> :m .-2<CR>==
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
      nmap <leader>u mqviwu`q
      nmap <leader>l mQviwu`Q


      imap <C-/> <leader>c<space>
      nmap <C-/> <leader>c<space>
      vmap <C-/> <leader>c<space>

      nmap <Leader>y :%y+<CR>

      nmap <leader>xml :%!xmllint --format -<CR>

      " Ensure correct ruby is used for linting (NOT SYSTEM RUBY)
      " let g:syntastic_ruby_checkers=['~/.rbenv/shims/ruby']

      " Ensure Send_to_Tmux() always goes to the current session and window
      let g:tslime_always_current_session = 1
      let g:tslime_always_current_window  = 1

      set autoread
      let NERDTreeIgnore=[]
    '';
  };
}
