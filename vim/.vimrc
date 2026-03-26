vim9script

g:mapleader = " "
g:mapleader = " "

set nocompatible
syntax on

# Editor Settings
set t_Co=256
set incsearch
set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣
set listchars=tab:>·,trail:~
set list
#set relativenumber
set number
set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab
set wildmenu
set wildoptions=fuzzy
set updatetime=300
set hlsearch
set hidden
set smartindent
set mouse=a
set nocursorline
set hidden
set nowrap
set backspace=indent,eol,start
#set showmatch
set ignorecase
set smarttab
set incsearch
set encoding=utf-8

# Escape fixes for Kitty
&t_RV = ""
&t_ut = ""

# Change the cursor for insert/replace mode
# only works in VTE compatible terminals
&t_SI = "\<Esc>[6 q" # Insert
&t_SR = "\<Esc>[4 q" # Replace
&t_EI = "\<Esc>[2 q" # Normal

# Functions
def g:ToggleList()
  const fullChars = "eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣"
  const trailingChars = "tab:>·,trail:~"
  if (&listchars == fullChars)
    &listchars = trailingChars
  else
    &listchars = fullChars
  endif
enddef

# Keybinds
nnoremap <leader>tw :call ToggleList()<CR>
nnoremap <leader>dd :Ex<CR>
nnoremap ; :
set pastetoggle=<F2>
vmap F gq
nmap F gqap
nmap <silent> ;/ :nohlsearch<CR>
cmap w!! w !sudo tee % >/dev/null
nnoremap <leader>r :exe "%s/\\v\<" .. expand("<cword>") .. ">/" .. input("Replace \"" .. expand("<cword>") .. "\" by? ") .. "/g"<CR>
vnoremap <leader>r :<C-U>execute "'<,'>s/\\V" . escape(input('Replace: '), '/\') . "/" . escape(input('With: '), '/\') . "/g"<CR>
nnoremap = :norm 0f=1lD$<CR>
vnoremap = :norm 0f=1lD$<CR>

map <down> <nop>
map <left> <nop>
map <right> <nop>
imap <up> <nop>
imap <down> <nop>
imap <left> <nop>
imap <right> <nop>

# Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
# If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
# (see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX) && getenv('TERM_PROGRAM') != 'Apple_Terminal')
  if (has("termguicolors"))
    set termguicolors
  endif
endif

# Plugins
call plug#begin()

#Plug 'morhetz/gruvbox'
Plug 'junegunn/fzf.vim'
#Plug 'LunarWatcher/auto-pairs'
Plug 'tpope/vim-commentary'
#Plug 'danilo-augusto/vim-afterglow'

call plug#end()

# Theme
# set background=dark
#colorscheme afterglow
highlight Normal guibg=NONE ctermbg=NONE

# FZF
# Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

# Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-l> <plug>(fzf-complete-line)

nnoremap <leader>ff :Files<CR>
nnoremap <leader>fh :History<CR>
nnoremap <leader>rg :Rg<CR>
