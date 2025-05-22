"gotta be first set nocompatible " Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl --ssl-revoke-best-effort -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

call plug#begin('~/.vim/plugged')
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'preservim/tagbar'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'romainl/vim-cool'

" colorschemes
"Plug 'morhetz/gruvbox'
Plug 'sainnhe/gruvbox-material'
"Plug 'ycm-core/YouCompleteMe', { 'do': './install.py --clangd-completer' }
" Plug 'justinmk/vim-sneak'
call plug#end()


"general settings
let mapleader = " "
set number relativenumber
set ignorecase
set ruler
set showcmd
set incsearch
set backupdir=~/.vim/tmp//,.
set directory=~/.vim/tmp//,.
set autoread
set clipboard=unnamed "windows
" set clipboard=unnamedplus "Linux
set laststatus=2
set confirm
set hidden
set nowrap
set linebreak
"set splitright
set splitbelow
"show the debug column on left all the time
set signcolumn=yes
set nostartofline
set hlsearch
set smartcase
set formatoptions-=o

" white space
set tabstop=4
set shiftwidth=4 
set softtabstop=4
set noexpandtab
set nosmarttab
set nolist
set listchars=tab:⇤–⇥,space:·,trail:·,precedes:⇠,extends:⇢,nbsp:×       " how white space is shown when ':set list'

"Universal ctags - Read local tag file, then global tag file in /usr/include
"To create to tags in /usr/include I used
"cd /usr/include/tags
"sudo ctags -I DECLSPEC -I SDLCALL -R --c++-kinds=+p --fields=+iaS --extras=+q .
"default tag locations below, probably for linux only
"set tags=./tags,tags,/usr/include/tags
"let &tags .= ','.expand("%:p:h")
command ResetTags set tags=./tags,tags
"For this to work, you need to have to main tags file open
command SetTags set tags=./tags,tags <bar> let &tags .= ','.expand("%:p")

"
" this was my attempt at trying to use the omnicomplete of ctags. It didn't
" really work
set complete=.,w,b,u,t
set omnifunc=syntaxcomplete#Complete

" custom mappings
map gg gg^
map G G^
map <leader>ev :e ~/.vimrc<CR>
map <leader>dz <C-]>
map <leader>dm <C-]>
map <leader>d <C-]>
map <leader>dt <C-]>zt
map <leader>db <C-]>zb
 "save path of current file
map <leader>p :let @+=expand("%:p:h")<CR>
map <leader>o :let @+=expand("%")<CR>
map <leader>h :b#<CR>
map <leader>j :bn<CR>
map <leader>k :bp<CR>
vnoremap * y /<C-r>0<CR>
vnoremap # y ?<C-r>0<CR>

" map <leader>bw :b# \| bw#<CR>

" fzf.vim
map <leader>f :Files<CR>
map <leader>b :Buffers<CR>
" <C-r>r paste in contents of r register
" this mapping allows to search for a whole word only and saves it in r
" register
nmap <leader>rr m'"ryiw<C-o>:let @r="\\<<C-r>r\\>"<CR>:Rg <C-r>r<CR>
nmap <leader>r m':Rg <C-r>r<CR>
vmap <leader>rr m'"ry:Rg <C-r>r<CR>
let g:fzf_vim = {}
let g:fzf_layout = { 'window': { 'width': 0.98, 'height': 0.8 } }
let g:fzf_preview_window = ['up:60%:hidden', 'ctrl-/']
let g:fzf_vim.grep_multi_line = 2

" Exuberant tags: rebuild tags in current folder
"nmap <leader>tt :!(cd %:p:h;ctags *.[ch])&<CR>
nmap <leader>tt :!(cd %:p:h;ctags *)&<CR>
"This unsets the "last search pattern" register by hitting return
" nnoremap <silent> <CR> :noh<CR>
nnoremap <silent> <leader>/ :noh<CR>

noremap <C-e> 5<C-e>
noremap <C-y> 5<C-y>

" window mappings
nmap <C-h> <C-w>h
nmap <C-l> <C-w>l
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
"
" maximize window in new tab
nmap <C-w>\ :tab split<CR>
nmap <leader>> 30zl
nmap <leader>< 30zh
nmap Y y$
nmap <F8> :TagbarToggle<CR>

" insert mode: correct current whole word
imap <C-h> <Esc>dbxi
" insert blank line between brackets
" inoremap {<CR> {<CR>}<C-o>O
" Don't insert blank line between brackets
inoremap {<CR> {<CR>}<Esc>%

" useful maps when editing text files with wrap turned on
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'

"you complete me
set completeopt-=preview
"show pop up only on <leader>;
nmap <leader>; <plug>(YCMHover)
let g:ycm_auto_hover=''

"vim-airline plugin
"let g:airline#extensions#tabline#enabled = 1
"let g:airline#extensions#tabline#show_buffers = 0
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
" reorder status line just to have a little bit of orange in the bottom right
function! AirlineInit()
	let g:airline_section_z = "%p%% : %l/%L :%c"
	let g:airline_section_warning = g:airline_section_z
	let g:airline_section_z = g:airline_section_y
	let g:airline_section_y = ""
	"let g:airline_section_y = g:airline_section_x
	"let g:airline_section_x = ""
endfunction
augroup vimrcAirline
	autocmd User AirlineAfterInit call AirlineInit()
augroup END

" this block of code is only neccessary in WSL, it restores the cursor being a
" block in normal mode rather than a vertical line
" cursor shape
if &term =~? 'rxvt' || &term =~? 'xterm' || &term =~? 'st-'
    " 1 or 0 -> blinking block
    " 2 -> solid block
    " 3 -> blinking underscore
    " 4 -> solid underscore
    " Recent versions of xterm (282 or above) also support
    " 5 -> blinking vertical bar
    " 6 -> solid vertical bar
    " Insert Mode
    let &t_SI .= "\<Esc>[6 q"
    " Normal Mode
    let &t_EI .= "\<Esc>[2 q"
endif

"wsl: remove ding
"ex: happens on escape press while in normal mode
set visualbell
set t_vb=

" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2019 Jan 26
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings, bail
" out.
if v:progname =~? "evim"
  finish
endif

" Get the defaults that most users want.
source $VIMRUNTIME/defaults.vim

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file (restore to previous version)
  if has('persistent_undo')
    " set undofile	" keep an undo file (undo changes after closing)
  endif
endif

"if &t_Co > 2 || has("gui_running")
  " Switch on highlighting the last used search pattern.
"  set hlsearch
"endif

" Put these in an autocmd group, so that we can delete them easily.
augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=80
augroup END

" Add optional packages.
"
" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
" The ! means the package won't be loaded right away but when plugins are
" loaded during initialization.
if has('syntax') && has('eval')
  packadd! matchit
endif

"gruvbox-materials
if has('termguicolors')
	set termguicolors
endif
" For dark version.
set background=dark
" Set contrast.
" This configuration option should be placed before `colorscheme gruvbox-material`.
" Available values: 'hard', 'medium'(default), 'soft'
let g:gruvbox_material_background = 'hard'
" For better performance
let g:gruvbox_material_better_performance = 1
colorscheme gruvbox-material

syntax on

" My modifications to color scheme
"hi MatchParen cterm=bold ctermbg=none ctermfg=darkblue
