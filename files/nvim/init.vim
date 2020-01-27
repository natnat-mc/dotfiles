" plugin options
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_theme = 'alduin'
let g:javascript_conceal_function             = "ƒ"
let g:javascript_conceal_null                 = "ø"
let g:javascript_conceal_this                 = "@"
let g:javascript_conceal_return               = "⇚"
let g:javascript_conceal_undefined            = "¿"
let g:javascript_conceal_NaN                  = "ℕ"
let g:javascript_conceal_prototype            = "¶"
let g:javascript_conceal_static               = "•"
let g:javascript_conceal_super                = "Ω"
let g:javascript_conceal_arrow_function       = "⇒"
let g:javascript_conceal_noarg_arrow_function = "🞅"

" load plugins
call plug#begin(stdpath('config') . '/plug')
Plug 'tpope/vim-sensible'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'sliminality/wild-cherry-vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'leafo/moonscript-vim', {'for': 'moonscript'}
Plug 'nikvdp/ejs-syntax', {'for': 'ejs'}
Plug 'VaiN474/vim-etlua', {'for': 'etlua'}
Plug 'groenewege/vim-less', {'for': 'less'}
Plug 'elzr/vim-json', {'for': 'json'}
Plug 'cakebaker/scss-syntax.vim', {'for': 'scss'}
Plug 'hail2u/vim-css3-syntax', {'for': 'css'}
Plug 'leafgarland/typescript-vim', {'for': 'typescript'}
Plug 'pangloss/vim-javascript', {'for': 'javascript'}
Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'}
Plug 'rstacruz/vim-hyperstyle'
call plug#end()

" custom settings
set mouse=a
set number
set switchbuf=usetab,newtab
set list lcs=tab:\|\ 
set conceallevel=1
set hidden

" autocompletion
inoremap <silent><expr> <c-space> coc#refresh()
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" tab shortcuts
nmap <C-A-left> :tabprevious<CR>
imap <C-A-left> <ESC>:tabprevious<CR>i
tmap <C-A-left> <C-\><C-n>:tabprevious<CR>i
nmap <C-A-right> :tabnext<CR>
imap <C-A-right> <ESC>:tabnext<CR>i
tmap <C-A-right> <C-\><C-n>:tabnext<CR>i
nmap <C-A-up> :tabedit 
nmap <C-A-down> :tabclose<CR>

" buffer shortcuts
nmap <C-left> :bp!<CR>
imap <C-left> <ESC>:bp!<CR>i
nmap <C-right> :bn!<CR>
imap <C-right> <ESC>:bn!<CR>i
nmap <C-up> :edit 
nmap <C-down> :bd<CR>

" build/run
nmap <C-b> :!make<CR>
nmap <C-A-b> :exec ':!make -C '.system('dirname "'.simplify(getcwd().'/'.bufname('%')).'"')<CR>
nmap <C-r> :!make run<CR>
nmap <C-A-r> :exec ':!make run -C '.system('dirname "'.simplify(getcwd().'/'.bufname('%')).'"')<CR>
nmap <C-f> :exec ':!./'.bufname('%')<CR>
nmap <C-A-f> :exec ':! chmod +x '.bufname('%')<CR>
nmap <C-A-m> :!./% 

" clipboard
nmap <C-d> dd
imap <C-d> <ESC>ddi
nmap <C-y> :'a,'by<CR>
imap <C-y> <ESC>:'a,'by<CR>i
nmap <C-A-y> :'a,'bd<CR>
imap <C-A-y> <ESC>:'a,'bd<CR>i
nmap <C-k> :'a,'bw !xsel -bi<CR><CR>
imap <C-k> <ESC>:'a,'bw !xsel -bi<CR><CR>i
nmap <C-A-k> :r !xsel -bo<CR>
imap <C-A-k> <ESC>:r !xsel -bo<CR>i

" selection
nmap <C-a> ma
imap <C-a> <ESC>mai
nmap <C-b> mb
imap <C-b> <ESC>mbi
nmap <C-A-a> :1mark a<CR>:$mark b<CR>
imap <C-A-a> <ESC>:1mark a<CR>:$mark b<CR>i
nmap <C-A-b> mamb
imap <C-A-b> <ESC>mambi

" show numbers
nmap <C-n> :set number<CR>
nmap <C-A-n> :set nonumber<CR>

" misc
nmap s/ :s/
nmap sn :noh<CR>
nmap ! :!

" NERDTree
nmap <C-t> :NERDTreeToggle<CR>
imap <C-t> <ESC>:NERDTreeToggle<CR>

