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

vim.cmd [[
    highlight Normal ctermbg=none guibg=none
    highlight NonText ctermbg=none guibg=none
]]

vim.cmd [[
  autocmd FileType markdown highlight markdownInlineCode guibg=NONE
  let g:netrw_nogx = 0
  let g:netrw_browsex_viewer = "open"  " For macOS
]]

--Colorscheme
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
--
-- vim.api.nvim_create_autocmd("FileType", {
--     pattern = "markdown",
--     callback = function()
--         vim.opt_local.foldmethod = "expr"
--         vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
--     end,
-- })

vim.cmd "filetype plugin on"

-- Smart Python host detection for Neovim
local function detect_python()
    local cwd = vim.fn.getcwd()
    local candidates = {
        cwd .. "/.venv/bin/python",
        cwd .. "/venv/bin/python",
    }

    for _, p in ipairs(candidates) do
        if vim.fn.executable(p) == 1 then
            return p
        end
    end

    -- Conda fallback
    local conda = vim.env.CONDA_PREFIX
    if conda and vim.fn.executable(conda .. "/bin/python") == 1 then
        return conda .. "/bin/python"
    end

    -- pyenv fallback (optional)
    local ok, pyenv_python = pcall(function()
        return vim.fn.systemlist("pyenv which python3")[1]
    end)
    if ok and pyenv_python and vim.fn.executable(pyenv_python) == 1 then
        return pyenv_python
    end

    -- System python
    if vim.fn.executable "python3" == 1 then
        return vim.fn.exepath "python3"
    end
    return "python"
end

-- Set provider at startup
vim.g.python3_host_prog = detect_python()

-- Update provider whenever you change directories
vim.api.nvim_create_autocmd("DirChanged", {
    callback = function()
        local p = detect_python()
        if p ~= vim.g.python3_host_prog then
            vim.g.python3_host_prog = p
        end
    end,
})

vim.cmd [[
let g:typst_pdf_viewer =  'tdf'
    ]]
