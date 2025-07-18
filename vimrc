unlet! skip_defaults_vim
silent! source $VIMRUNTIME/defaults.vim

let s:darwin = has('mac')

silent! if plug#begin('~/.vim/plugged')

Plug 'junegunn/seoul256.vim'
Plug 'junegunn/gv.vim'
Plug 'junegunn/fzf', { 'do': './install --all' }
Plug 'junegunn/fzf.vim'
if s:darwin
  Plug 'junegunn/vim-xmark'
endif

function! BuildYCM(info)
  if a:info.status == 'installed' || a:info.force
    !./install.py --clang-completer --gocode-completer
  endif
endfunction
Plug 'Valloric/YouCompleteMe', { 'for': ['c', 'cpp'], 'do': function('BuildYCM') }
Plug 'tpope/vim-fugitive'
if v:version >= 703
  Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
endif
Plug 'rust-lang/rust.vim'

call plug#end()
endif

filetype plugin indent on
syntax on

set background=dark
let g:seoul256_background = 233
silent! colo seoul256

autocmd FileType gitcommit set textwidth=72
set hidden

imap jj <Esc>
set backspace=indent,eol,start
set laststatus=2
set number

set list
set listchars=tab:>·,trail:·

set hlsearch
set incsearch

set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

" ctags
set tags=tags;/

let maplocalleader = "\\"

noremap <silent><leader>; :nohlsearch<cr>
      \:syntax sync fromstart<cr>
      \<c-l>

map <Tab> <C-W>W:cd %:p:h<CR>:<CR>

nnoremap <space> za
vnoremap <space> zf

vnoremap . :norm.<CR>

" fzf
command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)
command! -bang -nargs=* F call fzf#vim#grep(g:rg_command .shellescape(<q-args>), 1, <bang>0)
nnoremap <silent> <Leader>f :Rg<CR>

nnoremap <Leader>T :TagbarToggle<CR>

autocmd FileType python map <buffer> <leader>x :w<CR>:exec '!python3' shellescape(@%, 1)<CR>
autocmd FileType python imap <buffer> <leader>x <esc>:w<CR>:exec '!python3' shellescape(@%, 1)<CR>
let g:python_recommended_style = 0
au Filetype python setlocal ts=2 sts=0 sw=2

let g:ycm_global_ycm_extra_conf = '~/.vim/ycm_extra_conf.py'
let g:ycm_autoclose_preview_window_after_completion = 1
"let g:ycm_confirm_extra_conf = 1

nnoremap <leader>t :YcmCompleter GoTo<CR>
nnoremap <leader>d :YcmCompleter GoToDefinition<CR>
