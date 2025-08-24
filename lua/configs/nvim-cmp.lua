--LocalVariables
local cmp = require "cmp"
local lspkind = require "lspkind"
local luasnip = require "luasnip"
local lspconfig = require "lspconfig"
local util = require "lspconfig/util"
local path = util.path

local luasnip = require "luasnip"
require("luasnip.loaders.from_lua").load { paths = "~/.config/nvim/LuaSnip/" }

require("luasnip").config.set_config {
    region_check_events = "InsertEnter",
    delete_check_events = "InsertLeave",
    enable_autosnippets = true,
    store_selection_keys = "<Tab>",
    update_events = "TextChanged,TextChangedI",
}

function MoveCursorRight()
    vim.api.nvim_input "<Right>"
end

local unlinkgrp = vim.api.nvim_create_augroup("UnlinkSnippetOnModeChange", { clear = true })

local function has_close_delimiter_after()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    local line_text = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
    local next_char = line_text:sub(col + 1, col + 1)
    local close_delimiters = { ")", "}", "]", '"', "$" }
    for _, delim in ipairs(close_delimiters) do
        if next_char == delim then
            return true
        end
    end
    return false
end

vim.api.nvim_create_autocmd("ModeChanged", {
    group = unlinkgrp,
    pattern = { "s:n", "i:*" },
    desc = "Forget the current snippet when leaving the insert mode",
    callback = function(evt)
        if luasnip.session and luasnip.session.current_nodes[evt.buf] and not luasnip.session.jump_active then
            luasnip.unlink_current()
        end
    end,
})

local function has_close_bracket_after()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    local line_text = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
    return col ~= #line_text and line_text:sub(col + 1, col + 1) == ")"
end

-- Enable LSP
--vim.api.nvim_command 'autocmd FileType tex lua require("lspconfig").texlab.setup{}'

lspconfig.texlab.setup {
    cmd = { "/usr/local/bin/texlab" },
    settings = {
        texlab = {
            experimental = {
                mathEnvironments = {
                    "flalign",
                    "flalign*",
                },
            },
            --symbols = {},
        },
    },
}

--function to jump between luasnip
local function has_words_before()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
end

local types = require "cmp.types"

-- Global setup.
cmp.setup {
    enabled = true,
    preselect = types.cmp.PreselectMode.None,
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
        end,
    },
    window = {
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-buffer",
        documentation = cmp.config.window.bordered(),
    },
    mapping = {
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<CR>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Insert,
            select = false,
        },

        ["<Tab>"] = cmp.mapping(function(fallback)
            if has_close_bracket_after() and not cmp.visible() then
                MoveCursorRight()
            elseif cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    },
    sources = cmp.config.sources {
        { name = "jupynium", priority = 1000 },
        { name = "nvim_lsp" },
        { name = "buffer", keyword_length = 3 },
        { name = "neorg" },
        { name = "luasnip", keyword_length = 2 },
        { name = "orgmode" },
        { name = "cmp_pandoc" },
        { name = "path" },
        --{ name = "omni", trigger_characters = { "(" }, keyword_length = 1 },
    },
    completion = {
        completeopt = "menu,menuone,noselect",
    },

    formatting = {
        format = lspkind.cmp_format {
            maxwidth = 25,
            mode = "symbol",
            menu = {
                otter = "[🦦]",
                buffer = "[BUF]",
                nvim_lsp = "[LSP]",
                nvim_lua = "[API]",
                omni = "[OMNI]",
                path = "[PATH]",
                luasnip = "[SNIP]",
                cmp_pandoc = "[REF]",
            },
        },
    },
}

--require("lspconfig").jedi_language_server.setup{}

cmp.setup.filetype("python", {
    enabled = true,
    preselect = types.cmp.PreselectMode.None,
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
        end,
    },
    window = {
        --completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = {
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<CR>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Insert,
            select = false,
        },
        ["<Tab>"] = cmp.mapping(function(fallback)
            if has_close_bracket_after() and not cmp.visible() then
                MoveCursorRight()
            elseif cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    },
    sources = cmp.config.sources {
        { name = "otter" },
        { name = "nvim_lsp", keyword_length = 1 },
        { name = "luasnip", keyword_length = 2 },
        { name = "buffer", keyword_length = 3 },
        { name = "path" },
    },
    completion = {
        completeopt = "menu,menuone,noselect",
    },
    formatting = {
        format = lspkind.cmp_format {
            maxwidth = 25,
            menu = {
                nvim_lsp = "[LSP]",
                luasnip = "[SNIP]",
                path = "[PATH]",
                buffer = "[BUF]",
            },
        },
    },
})

cmp.setup.filetype({ "tex" }, {
    enabled = true,
    preselect = types.cmp.PreselectMode.None,
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
        end,
    },
    window = {
        --completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = {
        ["<C-l>"] = cmp.mapping(function(fallback)
            if luasnip.choice_active() then
                luasnip.change_choice(1)
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<CR>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Insert,
            select = false,
        },
        ["<Tab>"] = cmp.mapping(function(fallback)
            if has_close_delimiter_after() and not cmp.visible() then
                MoveCursorRight()
            elseif cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    },
    sources = cmp.config.sources {
        { name = "nvim_lsp", keyword_length = 2 },
        { name = "luasnip", keyword_length = 2 },
        { name = "buffer", keyword_length = 2 },
        { name = "path" },
    },
    completion = {
        completeopt = "menu,menuone,noselect",
    },
    formatting = {
        format = lspkind.cmp_format {
            maxwidth = 25,
            menu = {
                nvim_lsp = "[LSP]",
                luasnip = "[SNIP]",
                path = "[PATH]",
                nvim_lua = "[API]",
                buffer = "[BUF]",
            },
        },
    },
})

-- `/` cmdline setup.
cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline(),
    source = {
        { name = "nvim_lsp_document_symbol" },
        { name = "buffer" },
    },
    --sources = cmp.config.sources({
    --{ name = "nvim_lsp_document_symbol" },
    --}, {
    --{ name = "buffer" },
    --}),
})

---- `:` cmdline setup.
cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    formatting = {
        format = lspkind.cmp_format {
            mode = "symbol_text",
            maxwidth = 20,
        },
    },
    sources = cmp.config.sources({
        { name = "fuzzy_path" },
    }, {
        { name = "cmdline" },
    }),
})

--------------------------------------------------
-- Global Config
--masonConfig
require("mason").setup()
require("mason-lspconfig").setup {
    ensure_installed = { "cssls" },
}

local lspconfig = require "lspconfig"
local lsp_defaults = lspconfig.util.default_config

lsp_defaults.capabilities =
    vim.tbl_deep_extend("force", lsp_defaults.capabilities, require("cmp_nvim_lsp").default_capabilities())

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
                venvPath = ".",
                venv = ".venv",

                -- venvPath = "/Users/luis/micromamba/envs/",
                --venv = "integrator",
            },
        },
    },
}

vim.cmd [[
set pumheight=10
]]
