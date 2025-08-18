require("mason").setup()

local lspconfig = require "lspconfig"
local lsp_defaults = lspconfig.util.default_config

lsp_defaults.capabilities = require("blink.cmp").get_lsp_capabilities(lsp_defaults.capabilities)

lspconfig.sqlls.setup {
    on_attach = function(client, bufnr)
        require("sqls").on_attach(client, bufnr)
    end,
}
lspconfig.cssls.setup {}

require("cmp_pandoc").setup {
    enable_nabla = true,
}

-- Keybindings
vim.api.nvim_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", { noremap = true, silent = true })
--vim.api.nvim_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', { noremap = true, silent = true })
--
--
--
local function join_paths(...)
    local sep = package.config:sub(1, 1) -- Get the path separator (usually '/' or '\')
    local result = table.concat({ ... }, sep)
    return result
end

local function get_python_path(workspace)
    -- Use activated virtualenv.
    if vim.env.VIRTUAL_ENV then
        return join_paths(vim.env.VIRTUAL_ENV, "bin", "python")
    end

    -- Find and use virtualenv from pipenv in workspace directory.
    local match = vim.fn.glob(join_paths(workspace, "Pipfile"))
    if match ~= "" then
        local venv = vim.fn.trim(vim.fn.system("PIPENV_PIPFILE=" .. match .. " pipenv --venv"))
        return join_paths(venv, "bin", "python")
    end

    -- Fallback to system Python.
    return vim.fn.exepath "python3" or vim.fn.exepath "python" or "python"
end

require("lspconfig").pyright.setup {
    on_attach = function()
        require("lsp_signature").on_attach {
            hint_enable = false,
        }
    end,
    on_init = function(client)
        client.config.settings.python.pythonPath = get_python_path(client.config.root_dir)
    end,
    settings = {
        python = {
            analysis = {
                autoImportCompletions = false,
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
                venvPath = "/Users/luis/micromamba/envs/",
                venv = "integrator",
            },
        },
    },
}

vim.cmd [[
set pumheight=10
]]
