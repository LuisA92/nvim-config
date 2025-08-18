local g = vim.g
local o = vim.o

-- Bullet configurations
g.bullets_enabled_file_types = { "markdown" }
vim.api.nvim_set_option("encoding", "UTF-8")
vim.cmd "filetype plugin on"
vim.cmd "syntax on"
--vim.wo.relativenumber = true

-- Terminal and editor settings
o.wrap = true
o.shell = "/bin/zsh"
vim.cmd "hi clear Conceal"
vim.cmd "autocmd WinResized * wincmd ="

g.ctrlp_match_func = { match = "cpsm#CtrlPMatch" }

vim.cmd [[
 if has('nvim') && !empty($CONDA_PREFIX)
  let g:python3_host_prog = $CONDA_PREFIX . '/bin/python3.10'
else
	let g:python3_host_prog = '/Library/Frameworks/Python.framework/Versions/3.9/bin/python3'
endif
let g:copilot_filetypes = {
      \ 'markdown': v:false,
      \ }
    ]]

o.scrolloff = 8
o.termguicolors = true

o.cursorline = true

o.number = true
o.mouse = "a"
o.clipboard = "unnamed"
o.ignorecase = true
o.hidden = true
o.smartcase = true
o.expandtab = true
o.tabstop = 2
o.shiftwidth = 2
o.softtabstop = 2
o.hlsearch = false
o.wrap = true
o.breakindent = true
o.linebreak = true
o.list = false

o.splitright = true
o.splitbelow = true

vim.diagnostic.config {
    virtual_text = true,
    virtual_lines = false,
    signs = true,
    underline = false,
}

----ale linter
--vim.cmd [[
--syntax on
--let g:ale_fix_on_save = 1
--let g:ale_lsp_suggestions = 0
--let g:ale_set_signs = 1
--let g:ale_virtualtext_cursor=1
--let g:ale_use_neovim_diagnostics_api = 0
--let g:ale_tex_proselint_executable='/usr/local/bin/proselint'
--]]

vim.cmd [[
    highlight Normal ctermbg=none guibg=none
    highlight NonText ctermbg=none guibg=none
]]

vim.cmd [[
  autocmd FileType markdown highlight markdownInlineCode guibg=NONE
  let g:netrw_nogx = 0
  let g:netrw_browsex_viewer = "open"  " For macOS
]]

--vim.cmd "colorscheme rose-pine-main"
--vim.cmd "colorscheme lackluster"
vim.cmd "colorscheme tokyonight-night"

vim.cmd [[  function OpenMarkdownPreview (url)
    execute "silent ! open -a Firefox -n --args --new-window " . a:url
  endfunction
  let g:mkdp_browserfunc = 'OpenMarkdownPreview'
  let g:nvim_markdown_preview_theme = 'solarized-dark'
  ]]

vim.api.nvim_create_autocmd("FileType", {
    callback = function()
        vim.opt_local.formatoptions:remove { "r", "o" }
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
        vim.opt_local.foldmethod = "expr"
        vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    end,
})

vim.cmd "filetype plugin on"
