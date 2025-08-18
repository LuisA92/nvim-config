--local settings = {
--lua = { require("formatter.filetypes.lua").stylua },
--typescript = { require("formatter.filetypes.typescript").prettier },
--json = { require("formatter.filetypes.json").fixjson },
--markdown = { require("formatter.filetypes.markdown").prettierd },
--latex = { require("formatter.filetypes.latex").latexindent },

--["*"] = {
--require("formatter.filetypes.any").remove_trailing_whitespace,
--function()
---- Ignore already configured types.
--local defined_types = require("formatter.config").values.filetype
--if defined_types[vim.bo.filetype] ~= nil then
--return nil
--end
--vim.lsp.buf.format { async = true }
--end,
--},
--}

--require("formatter").setup {
--logging = false,
--log_level = vim.log.levels.WARN,
--filetype = settings,
--}

--local augroup = vim.api.nvim_create_augroup

--local autocmd = vim.api.nvim_create_autocmd

--augroup("__formatter__", { clear = true })
--autocmd("BufWritePost", {
--group = "__formatter__",
--command = ":FormatWrite",
--})
