call plug#begin("~/.vim/plugged")
  " Plugin Section

" Theme - Sublime with Airline
Plug 'rakr/vim-one'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Deoplete - Autocomplete
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

" Debugger
Plug 'szw/vim-maximizer'
Plug 'puremourning/vimspector'

" WIP
" Unit test coverage
Plug 'kalekseev/vim-coverage.py', { 'do': ':UpdateRemotePlugins' }

" Snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" Fzf Fuzzy Finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Python Plugins
Plug 'zchee/deoplete-jedi'

" C and Rust Plugins
Plug 'deoplete-plugins/deoplete-clang'
Plug 'cespare/vim-toml'

" Javascript Plugins
Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern' }
Plug 'othree/jspc.vim', { 'for': ['javascript', 'javascript.jsx'] }

" HTML Tag Completion
" https://docs.emmet.io/abbreviations/syntax/
Plug 'mattn/emmet-vim'

" Camel case navigation for w,e,b
Plug 'bkad/CamelCaseMotion'

" Commenter - gc and gcc
Plug 'tpope/vim-commentary'

" Pair bracket completion
Plug 'jiangmiao/auto-pairs'

" Git plugin
Plug 'tpope/vim-fugitive'

" Linter and formatter
Plug 'dense-analysis/ale'
Plug 'sheerun/vim-polyglot'

" NerdTREE and file nav
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ryanoasis/vim-devicons'
call plug#end()

" Config Section

" Python3 Location
let g:python3_host_prog = expand('/Library/Frameworks/Python.framework/Versions/3.9/bin/python3')

" New map leader from \ to 'space'
:let mapleader = " "

" Vim Theme
colorscheme one
set background=dark

" Deoplete theme
let g:deoplete#enable_at_startup = 1
call deoplete#custom#option('num_processes', 4)
let g:UltiSnipsExpandTrigger="<C-q>"
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

" HTML Tag Creation
let g:user_emmet_leader_key='<C-Z>'

let g:AutoPairsShortcutToggle = '<C-F>'

" Airline theme with buffer tabline
let g:airline_theme='one'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1

" Fzf Options
let g:fzf_preview_window = 'right:50%'
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6  }  }

" Launch pudb | insert pudb statement
nmap <leader>da oimport pudb; pudb.set_trace()<Esc>
nmap <leader>z :MaximizerToggle!<CR>

" VimSpector
let g:vimspector_enable_mappings = 'HUMAN'
noremap <leader>dd :call vimspector#Launch()<CR>




" CamelCase movement
let g:camelcasemotion_key = '<leader>'
vmap ,i <Esc>l,bv,e
omap ,i :normal v,i<CR>

" Tab and space standards
set expandtab shiftwidth=2 softtabstop=2 smarttab

" NERDTree config
let NERDTreeDirArrows = 1
nnoremap <C-t> :NERDTreeToggle<CR>
let g:NERDTreeGitStatusUseNerdFonts = 1
let g:NERDTreeShowHidden=1
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Ale linting configs
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠'
highlight ALEErrorSign ctermbg=NONE ctermfg=red
highlight ALEWarningSign ctermbg=NONE ctermfg=yellow
let g:ale_fix_on_save = 0
let g:ale_sign_column_always = 1

" JS and Python Ale linting
" For Angular linting see the below blog 
" https://www.bitovi.com/blog/angular-upgrades-painless-migration-from-tslint-to-eslint
let g:ale_linters = {
\  'javascript': ['eslint'],
\  'jsx': ['eslint'],
\  'typescript': ['eslint', 'tsserver'],
\  'python': ['pylint'],
\  'vim': ['vint'],
\  'cpp': ['clang'],
\  'c': ['clang'],
\  'rust': ['analyzer'],
\}

let g:ale_fixers = {
\  'javascript': ['eslint'],
\  'typescript': ['eslint'],
\  'jsx': ['eslint'],
\}


" Copy and Paste from Clipboard
vnoremap <C-c> :w !pbcopy<CR><CR>
noremap <C-v> :r !pbpaste<CR><CR>

" move among buffers with CTRL
map <C-J> :bnext<CR>
map <C-K> :bprev<CR>

" Nmaps for Git
nmap <leader>gs :Git<CR>
nmap <leader>gd :Gdiff<CR>
nmap <leader>gf :diffget //3<CR>
nmap <leader>gj :diffget //2<CR>
nmap <leader>gc :Git commit<CR>
nmap <leader>gp :Git push<CR>


" Enables cursor line position tracking:
set cursorline
" Removes the underline causes by enabling cursorline:
highlight clear CursorLine

" Set paste mode hot key
function! TogglePaste()
  if(&paste == 0)
    set paste
    echo "Paste Mode Enabled"
  else
    set nopaste
        echo "Paste Mode Disabled"
        endif
endfunction

map <leader>p :call TogglePaste()<cr>

" Set hybrid line numbers with a toggle to remove
set number relativenumber

" Toggle between hybrid line numbering
function! ToggleHybridLines()
  if(&relativenumber == 0)
    set relativenumber
    echo "Hybrid Lines Enabled"
  else
    set norelativenumber
    echo "Hybrid Lines Disabled"
  endif
endfunction

map <leader>l :call ToggleHybridLines()<cr>

" Smart case for searches
set ignorecase
set smartcase

" makes * and # work on visual mode too.
function! s:VSetSearch(cmdtype)
  let temp = @s
  norm! gv"sy
  let @/ = '\V' . substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', 'g')
  let @s = temp
endfunction

xnoremap * :<C-u>call <SID>VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch('?')<CR>?<C-R>=@/<CR><CR>

" recursively vimgrep for word under cursor or selection if you hit leader-star
if maparg('<leader>*', 'n') == ''
  nmap <leader>* :execute 'noautocmd vimgrep /\V' . substitute(escape(expand("<cword>"), '\'), '\n', '\\n', 'g') . '/ **'<CR>
endif
if maparg('<leader>*', 'v') == ''
  vmap <leader>* :<C-u>call <SID>VSetSearch()<CR>:execute 'noautocmd vimgrep /' . @/ . '/ **'<CR>
endif
