call plug#begin()

" LSP
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'

" LSP config
Plug 'neovim/nvim-lspconfig'

" Null-ls
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-lua/plenary.nvim'

" Autocompletion
Plug 'hrsh7th/nvim-cmp'                  " Completion framework
Plug 'hrsh7th/cmp-nvim-lsp'              " LSP completions
Plug 'hrsh7th/cmp-buffer'                " Buffer completions
Plug 'hrsh7th/cmp-path'                  " Path completions
Plug 'L3MON4D3/LuaSnip'                  " Snippets plugin

Plug 'windwp/nvim-autopairs'             " Pairs
Plug 'rust-lang/rust.vim'                " Rust syntax and utilities
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' } " Go tools

call plug#end()

" ---------------------------
" General Settings
" ---------------------------
set nocompatible               " Grow past generational trauma
set number                     " Show line numbers
set relativenumber             " Show relative line numbers
set tabstop=8                  " Set tab width
set shiftwidth=8               " Indentation
set softtabstop=8              " Spaces per tab in editing
set noexpandtab                  " Use spaces instead of tabs
set autoindent                 " Automatically indent
set smartindent                " Smarter indentation for code
set clipboard=unnamedplus      " Use system clipboard
set termguicolors              " Enable true color
set mouse=a                    " Enable mouse support
syntax enable                  " Enable syntax and plugins
filetype plugin on
set path+=**                   " Vim fuzzy finding (idk if i will use this or telescope, but anyway)
set wildmenu
command! MakeTags !ctags -R .

" ---------------------------
" File Browser 
" ---------------------------
let g:netrw_banner=0           " No banner
let g:netrw_browse_split=4     " Open in prior window
let g:netrw_altv=1             " Open splits to the right
let g:netrw_liststyle=3        " Tree view

" ---------------------------
" Snippets
" ---------------------------

"nnoremap ,html :-1read $HOME/some/path

" ---------------------------
" LSP
" ---------------------------
lua << EOF
require("mason").setup()  -- Initialize Mason

require("mason-lspconfig").setup({
    ensure_installed = {
        "pyright",
 diploma-contra-burro       "gopls",
        "rust_analyzer",
        "clangd",
    },
    automatic_installation = true,
})

local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

require("mason-lspconfig").setup_handlers({
    function(server_name)  -- Default handler
        lspconfig[server_name].setup({
            capabilities = capabilities,
        })
    end,
})
EOF

" ---------------------------
" Autocompletion
" ---------------------------
lua << EOF
local cmp = require("cmp")

cmp.setup({
    mapping = {
        ["<C-y>"] = cmp.mapping.confirm({ select = true }),  -- Confirm selection
        ["<C-Space>"] = cmp.mapping.complete(),             -- Trigger completion
    },
    sources = {
        { name = "nvim_lsp" },
        { name = "buffer" },
        { name = "path" },
    },
})
EOF

" ---------------------------
" Treesitter
" ---------------------------
lua << EOF
require("nvim-treesitter.configs").setup({
    ensure_installed = { "python", "go", "rust", "c", "lua" },
    highlight = {
        enable = true,  -- Enable highlighting
    },
})
EOF

" ---------------------------
" Null-ls
" ---------------------------
lua << EOF
local null_ls = require("null-ls")

null_ls.setup({
    sources = {
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.rustfmt,
        null_ls.builtins.formatting.goimports,
        null_ls.builtins.formatting.clang_format,
    },
})
EOF

" ---------------------------
" Key Mappings
" ---------------------------
" Basic LSP Keybindings
nnoremap gd <cmd>lua vim.lsp.buf.definition()<CR>    " Go to definition
nnoremap gr <cmd>lua vim.lsp.buf.references()<CR>    " Show references
nnoremap K <cmd>lua vim.lsp.buf.hover()<CR>         " Hover documentation
nnoremap <leader>ca <cmd>lua vim.lsp.buf.code_action()<CR> " Code actions

" Telescope Keybindings
nnoremap <leader>ff <cmd>Telescope find_files<CR>   " Find files
nnoremap <leader>fg <cmd>Telescope live_grep<CR>   " Live grep
nnoremap <leader>fb <cmd>Telescope buffers<CR>     " List buffers
nnoremap <leader>fh <cmd>Telescope help_tags<CR>   " Find help

" ---------------------------
" Language-Specific Plugins
" ---------------------------
" Rust
autocmd FileType rust nnoremap <leader>r <cmd>!cargo run<CR>   " Run Rust project

" Go
autocmd FileType go nnoremap <leader>b <cmd>!go build<CR>      " Build Go project
autocmd FileType go nnoremap <leader>r <cmd>!go run %<CR>      " Run current Go file
