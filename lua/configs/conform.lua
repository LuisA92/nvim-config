require("mason").setup()
require("mason-lspconfig").setup {
    ensure_installed = { "ltex", "cssls", "ruff" },
}

require("conform").setup {
    formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
        rust = { "rustfmt", lsp_format = "fallback" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        --markdown = { "prettierd", "prettier" },
    },
}
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function(args)
        require("conform").format { bufnr = args.buf }
    end,
})
