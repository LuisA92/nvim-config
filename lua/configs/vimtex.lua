--function find_project_root()
--local root_markers = { "main.tex", ".git" }
--local current_file = vim.fn.expand "%:p:h"
--local prev_file = ""

--while current_file ~= "/" and current_file ~= "" and current_file ~= prev_file do
--for _, marker in ipairs(root_markers) do
--if
--vim.fn.isdirectory(current_file .. "/" .. marker) == 1
--or vim.fn.filereadable(current_file .. "/" .. marker) == 1
--then
--return current_file
--end
--end
--prev_file = current_file
--current_file = vim.fn.fnamemodify(current_file, ":h")
--end

--return ""
--end

vim.g.vimtex_compiler_latexmk = {
    -- Specify the directory for auxiliary files
    aux_dir = "output",

    -- Specify the directory for all compilation output files
    out_dir = "output",

    -- Other options remain the same
    options = {
        "-lualatex",
        "-shell-escape",
        "-verbose",
        "-file-line-error",
        "-synctex=1",
        "-interaction=nonstopmode",
    },
}

vim.g.vimtex_compiler_engine = "lualatex" -- Use LuaTeX as the compilation engine
vim.g.tex_flavor = "latex"
vim.g.vimtex_view_general_viewer = "fancy-cat"
--vim.g.vimtex_view_method = "texshop"
--vim.g.vimtex_view_method = "mupdf"
--vim.g.vimtex_view_method = "sioyek"
vim.g.vimtex_view_skim_sync = 1
vim.g.vimtex_view_skim_activate = 1
vim.g.vimtex_quickfix_ignore_filters = { "Underfull", "Overfull" }

----vim.cmd [[
--let g:vimtex_view_general_viewer = 'okular'
----let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'
----]]
