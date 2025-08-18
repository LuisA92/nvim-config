local M = {}

M.opts = {
    servers = {
        pyright = {
            settings = {
                python = {
                    analysis = {
                        autoImportCompletions = false,
                        autoSearchPaths = true,
                        useLibraryCodeForTypes = true,
                        diagnosticMode = "workspace",
                    },
                },
            },
        },

        ruff = {
            init_options = {
                configuration = {
                    "/Users/luis/.config/ruff/ruff.toml",
                },
            },
        },

        vale_ls = {
            init_options = {
                installVale = true,
                configPath = "/Users/luis/.vale.ini",
            },
            filetypes = { "markdown", "tex" },
        },

        texlab = {
            settings = {
                experimental = {
                    mathEnvironments = {
                        "flalign",
                        "flalign*",
                    },
                },
            },
        },
    },
}

function M.setup(opts)
    local lspconfig = require "lspconfig"
    local blink_cmp = require "blink.cmp"

    local on_attach = function(client, bufnr)
        local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
        end

        map("K", vim.lsp.buf.hover, "Hover Documentation")
        map("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")
    end

    for server, config in pairs(opts.servers) do
        config.capabilities = blink_cmp.get_lsp_capabilities(config.capabilities)
        config.on_attach = on_attach
        lspconfig[server].setup(config)
    end
end

return M
