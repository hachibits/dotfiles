unlet! skip_defaults_vim
silent! source $VIMRUNTIME/defaults.vim

let s:darwin = has('mac')

silent! if plug#begin('~/.vim/plugged')

if s:darwin
  let g:plug_url_format = 'git@github.com:%s.git'
else
  let $GIT_SSL_NO_VERIFY = 'true'
endif

Plug 'junegunn/seoul256.vim'
Plug 'junegunn/gv.vim'
Plug 'junegunn/fzf', { 'do': './install --all' }
Plug 'junegunn/fzf.vim'
if s:darwin
  Plug 'junegunn/vim-xmark'
endif
unlet! g:plug_url_format

function! BuildYCM(info)
  if a:info.status == 'installed' || a:info.force
    !./install.py --clang-completer --gocode-completer
  endif
endfunction
Plug 'Valloric/YouCompleteMe', { 'for': ['c', 'cpp'], 'do': function('BuildYCM') }

Plug 'mileszs/ack.vim', { 'on': 'Ack' }
Plug 'Yggdroot/indentLine', { 'on': 'IndentLinesEnable' }
autocmd! User indentLine doautocmd indentLine Syntax
if v:version >= 703
  Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
endif

Plug 'tpope/vim-fugitive'
if v:version >= 703
  Plug 'mhinz/vim-signify'
endif

call plug#end()
endif

filetype plugin indent on

syntax on
let g:seoul256_background = 235
silent! colo seoul256

autocmd FileType gitcommit set textwidth=72
set hidden

imap jk <Esc>
set backspace=indent,eol,start
set laststatus=2 
set number
set notgc

set list
set listchars=tab:\|\ ,

set hlsearch
set incsearch

set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

if has('termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
  hi StatusLine gui=reverse
endif

function! s:statusline_expr()
  let mod = "%{&modified ? '[+] ' : !&modifiable ? '[x] ' : ''}"
  let ro  = "%{&readonly ? '[RO] ' : ''}"
  let ft  = "%{len(&filetype) ? '['.&filetype.'] ' : ''}"
  let fug = "%{exists('g:loaded_fugitive') ? fugitive#statusline() : ''}"
  let sep = ' %= '
  let pos = ' %-12(%l : %c%V%) '
  let pct = ' %P'

  return '[%n] %F %<'.mod.ro.ft.fug.sep.pos.'%*'.pct
endfunction
let &statusline = s:statusline_expr()

set modelines=2
set synmaxcol=1000

" ctags
set tags=tags;/

let maplocalleader = "\\"

noremap <silent><leader>; :nohlsearch<cr>
      \:syntax sync fromstart<cr>
      \<c-l>

map <Tab> <C-W>W:cd %:p:h<CR>:<CR>

set foldmethod=indent
set foldnestmax=2
nnoremap <space> za
vnoremap <space> zf

vnoremap . :norm.<CR>

if executable('ag')
  let &grepprg = 'ag --nogroup --nocolor --column'
else
  let &grepprg = 'grep -rn $* *'
endif
command! -nargs=1 -bar Grep execute 'silent! grep! <q-args>' | redraw! | copen

" fzf
command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)
command! -bang -nargs=* F call fzf#vim#grep(g:rg_command .shellescape(<q-args>), 1, <bang>0)
nnoremap <silent> <Leader>f :Rg<CR>
nnoremap <silent> <Leader>ag :Ag <C-R><C-W><CR>

nnoremap <Leader>T :TagbarToggle<CR>

autocmd filetype cpp nnoremap <leader>x :w <bar> !g++ -std=c++17 % -o %:r<CR>
autocmd filetype cpp nnoremap <leader>r :!%:r<CR>
autocmd FileType python map <buffer> <leader>x :w<CR>:exec '!python3' shellescape(@%, 1)<CR>

ca Hash w !cpp -dD -P -fpreprocessed \| tr -d '[:space:]' \
 \| md5sum \| cut -c-6

function! s:gv_expand()
  let line = getline('.')
  GV --name-status
  call search('\V'.line, 'c')
  normal! zz
endfunction

autocmd! FileType GV nnoremap <buffer> <silent> + :call <sid>gv_expand()<cr>

let g:ycm_global_ycm_extra_conf = '~/dotfiles/ycm_global_extra_conf.py'
"let g:ycm_clangd_binary_path = "/opt/homebrew/opt/llvm/bin/clangd"
let g:ycm_max_diagnostics_to_display = 0
let g:ycm_autoclose_preview_window_after_completion = 1
"let g:ycm_confirm_extra_conf = 1

nnoremap <leader>gt :YcmCompleter GoTo<CR>
nnoremap <leader>gD :YcmCompleter GoToDeclaration<CR>
nnoremap <leader>gd :YcmCompleter GoToDefinition<CR>
nnoremap <leader>fi :YcmCompleter FixIt<CR>
nnoremap <leader>D :YcmCompleter GetType<CR>
nnoremap <leader>gp :YcmCompleter GetParent<CR>
nnoremap <leader>gti :YcmCompleter GoToInclude<CR>
nnoremap <leader>gr :YcmCompleter GoToReferences<CR>

autocmd BufWritePre *.h,*.hpp,*.c,*.cpp,*.hh,*cc YcmCompleter Format
