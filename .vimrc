colorscheme delek
hi DiffAdd ctermbg=green
hi DiffChange ctermbg=brown
hi DiffDelete ctermbg=darkred
hi DiffText ctermbg=brown

autocmd BufEnter *.ps1 colorscheme elflord
autocmd BufEnter *.ps1 highlight ExtraWhiteSpace ctermbg=magenta guibg=pink
autocmd BufEnter *.psm1 colorscheme elflord
autocmd BufEnter *.psm1 highlight ExtraWhiteSpace ctermbg=magenta guibg=pink

"Indentation
set nowrap
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab

au FileType go setl sw=8 sts=8 ts=8 noet
au FileType py setl sw=4 sts=4 ts=4 noet
"au FileType markdown setl wrap linebreak


"yaml stuff
autocmd BufEnter *.yaml highlight Tabs ctermbg=red guibg=pink
autocmd BufEnter *.yaml match Tabs /\t/
autocmd BufEnter *.yml highlight Tabs ctermbg=red guibg=pink
autocmd BufEnter *.yml match Tabs /\t/

set number
"set colorcolumn=100

"Wennmo complaining about trailing whitespaces
hi ExtraWhiteSpace ctermbg=magenta
match ExtraWhiteSpace /\s\+$/
     

hi CommentComment ctermbg=darkgreen ctermfg=white
2match CommentComment /\(COMMENT\)\|\(NOTE\)/
"COMMENT
"NOTE

nmap <silent> <C-i> "=nr2char(getchar())<cr>P

"Bind \g to jump to imported file (with relative path).
"The following three lines do that.
"TODO make it more generic with a regex instead
"E.g. this one: [.\/A-Za-z0-9\-_]\+\.[a-z_]\+\(:[0-9]\+\)\?

"Set wd to file-dir
"set autochdir
"Make <Tab> trigger completion
set wildcharm=<Tab>

"Get file-name - end-of-line and then yank what's in single-quotes.
"Then open the yanked file in a new tab.
nmap \g g_hT'yt':tabe <C-r>0<Tab><CR>

nmap \v :exec 'vim /' . expand('<cword>') . '/ *'

"Solve with regex for more complicated patterns... but harder to navigate
"nmap \x ^/[.\/A-Za-z0-9\-_]\+\.[a-z_]\+\(:[0-9]\+\)\?<CR>yn :tabe <C-r>0

"Discipline
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

nnoremap ,v :vsplit<space>
nnoremap ,h :split<space>

"Search and highlighting
hi Search ctermbg=darkgrey

nnoremap \h :set hlsearch <CR>
nnoremap \H :set nohlsearch <CR>

"Pasting
nnoremap \p :set paste <CR>
nnoremap \P :set nopaste <CR>

"Number
nnoremap \n :set nonumber <CR>
nnoremap \N :set number <CR>

"Copy to windows clipboard
nnoremap cx :! echo '<C-R>0' <bar> clip.exe<CR><CR>

set undofile
set undoreload=10000
set undodir=~/.vim/undo//
set directory=~/.vim/swap//

augroup autosourcing
  autocmd!
  autocmd BufWritePost .vimrc source %
augroup END


set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'PProvost/vim-ps1'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'leafgarland/typescript-vim'
Plugin 'bogado/file-line'
"Plugin 'fatih/vim-go'


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
