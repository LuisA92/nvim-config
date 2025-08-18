local g = vim.g
local o = vim.o

o.wrap = true

require("nvim-treesitter.configs").setup {
    highlight = {
        enable = false,
    },
}

--ale linter
vim.cmd [[
syntax on
let g:ale_fix_on_save = 1
let g:ale_fixers = {'tex': ['latexindent','remove_trailing_lines']}
let g:ale_lsp_suggestions = 1
let g:ale_set_signs = 1
let g:ale_virtualtext_cursor=1
let g:ale_use_neovim_diagnostics_api = 1
let g:ale_tex_proselint_executable='/usr/local/bin/proselint'
let g:ale_linters = {'tex':['vale','chktek','texlab']}
]]
