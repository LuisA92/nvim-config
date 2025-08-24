local M = {}
local util = require "lspconfig.util"

-- helper: format current buffer with Ruff only

local function format_with_ruff(bufnr)
    vim.lsp.buf.format {
        async = false,
        bufnr = bufnr,
        filter = function(client)
            return client.name == "ruff"
        end,
    }
end

M.opts = {
    servers = {
        pyright = {
            settings = {
                pyright = {
                    disableTaggedHints = true,
                },
                python = {
                    analysis = {
                        autoImportCompletions = false,
                        autoSearchPaths = true,
                        useLibraryCodeForTypes = true,
                        diagnosticMode = "workspace",
                        venvPath = ".",
                        venv = ".venv",
                        diagnosticSeverityOverrides = {
                            reportUnusedImport = "none",
                            reportUnusedVariable = "none",
                            reportUnusedFunction = "none",
                            reportUnusedClass = "none",
                            reportUnusedParameter = "none",
                        },
                    },
                },
            },
            -- ensure Pyright never formats; Ruff is the formatter
            on_attach = function(client, bufnr)
                client.server_capabilities.documentFormattingProvider = false
                client.server_capabilities.documentRangeFormattingProvider = false
            end,
        },

        ruff = {
            root_dir = util.root_pattern("pyproject.toml", "ruff.toml", ".git"),
            cmd = { "uv", "run", "ruff", "server" },
            init_options = {
                settings = {
                    organizeImports = true, -- code action: source.organizeImports
                    fixAll = true, -- code action: source.fixAll
                },
            },
            on_attach = function(client, bufnr)
                -- advertise formatting from Ruff
                client.server_capabilities.documentFormattingProvider = true
                client.server_capabilities.documentRangeFormattingProvider = true

                -- format on save with Ruff (buffer-local)
                vim.api.nvim_create_autocmd("BufWritePre", {
                    buffer = bufnr,
                    callback = function()
                        format_with_ruff(bufnr)
                    end,
                    desc = "Ruff format on save",
                })

                -- handy keymaps (buffer-local)
                local map = function(lhs, rhs, desc)
                    vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = "Ruff: " .. desc })
                end
                map("<leader>cf", function()
                    format_with_ruff(bufnr)
                end, "Format file")
                map("<leader>co", function()
                    vim.lsp.buf.code_action { apply = true, context = { only = { "source.organizeImports" } } }
                end, "Organize imports")
                map("<leader>ca", function()
                    vim.lsp.buf.code_action { apply = true, context = { only = { "source.fixAll" } } }
                end, "Apply auto-fixes")
            end,
        },

        vale_ls = {
            init_options = {
                installVale = false,
                configPath = "/Users/luis/.vale.ini",
            },
            filetypes = { "markdown", "tex" },
        },

        lua_ls = {
            settings = {
                Lua = {
                    diagnostics = { globals = { "vim" } },
                    runtime = { version = "LuaJIT" },
                },
            },
        },
        texlab = {
            settings = {
                experimental = {
                    mathEnvironments = { "flalign", "flalign*" },
                },
            },
        },
    },
}

function M.setup(opts)
    local lspconfig = require "lspconfig"
    local blink_cmp = require "blink.cmp"

    -- base on_attach shared by all (adds hover/signature maps)
    local function base_on_attach(client, bufnr)
        local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
        end
        map("K", vim.lsp.buf.hover, "Hover Documentation")
        map("<C-k>", vim.lsp.buf.signature_help, "Signature Help")
    end

    for server, config in pairs(opts.servers) do
        config.capabilities = blink_cmp.get_lsp_capabilities(config.capabilities)

        -- chain shared on_attach with server-specific one (if provided)
        local server_on_attach = config.on_attach
        config.on_attach = function(client, bufnr)
            base_on_attach(client, bufnr)
            if server_on_attach then
                server_on_attach(client, bufnr)
            end
        end

        lspconfig[server].setup(config)
    end
end

return M
