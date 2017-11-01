syntax enable
set background=dark
colorscheme solarized
set number
set expandtab
set shiftwidth=2
set tabstop=2
set laststatus=2
set backspace=indent,eol,start

let g:airline_theme='murmur'

"enable the list of buffers
let g:airline#extensions#tabline#enabled = 1

:nnoremap <Tab> :bnext<CR>
:nnoremap <S-Tab> :bprevious<CR>

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 1
let g:syntastic_ruby_checkers = ['rubocop']
" List certain whitespace characters
set listchars=tab:>·,trail:~,extends:>,precedes:<
set list

call plug#begin('~/.vim/plugged')
Plug 'fatih/vim-hclfmt'
Plug 'vim-airline/vim-airline'
Plug 'terryma/vim-expand-region'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdtree'
Plug 'vim-ruby/vim-ruby'
Plug 'vim-syntastic/syntastic'
Plug 'qpkorr/vim-bufkill'
Plug 'airblade/vim-gitgutter'
call plug#end()
