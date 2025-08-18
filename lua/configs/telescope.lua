require("plenary.filetype").add_file "foo"

local path_actions = require "telescope_insert_path"
local actions = require "telescope.actions"
local builtin = require "telescope.builtin"
local fb = require("telescope").extensions.file_browser.file_browser

local fb_actions = require("telescope").extensions.file_browser.actions

local finders = require "telescope.finders"
local pickers = require "telescope.pickers"
local conf = require("telescope.config").values

-- My custom template loader
vim.notify = require "notify"

local function notify_markdown(msg, type, title)
    vim.notify(msg, type, {
        title = title,
        on_open = function(win)
            local buf = vim.api.nvim_win_get_buf(win)
            vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
        end,
    })
end

function SelectLatexTemplate()
    pickers
        .new({}, {
            prompt_title = "Select LaTeX Template",
            finder = finders.new_oneshot_job {
                "find",
                "/Users/luis/master/tex_templates",
                "-maxdepth",
                "1",
                "-type",
                "d",
                "-or",
                "-type",
                "f",
            },
            sorter = conf.generic_sorter {},
            attach_mappings = function(_, map)
                map("i", "<CR>", function(bufnr)
                    local selection = require("telescope.actions.state").get_selected_entry()
                    actions.close(bufnr)
                    if not selection then
                        notify_markdown("No template selected", "error", "SelectLatexTemplate")
                        return
                    end
                    local current_dir = vim.loop.cwd()
                    local dest_dir = vim.fn.input("Destination Directory: ", current_dir .. "/", "dir")
                    if dest_dir == "" then
                        notify_markdown("Destination directory not provided", "error", "SelectLatexTemplate")
                        return
                    end
                    local new_project_name = vim.fn.input "New Project Name: "
                    if new_project_name == "" then
                        notify_markdown("Project name not provided", "error", "SelectLatexTemplate")
                        return
                    end

                    local command = '/Users/luis/master/scripts/bash/tex_template.sh "'
                        .. selection.value
                        .. '" "'
                        .. dest_dir
                        .. '" "'
                        .. new_project_name
                        .. '"'

                    local success, output = pcall(function()
                        return vim.fn.systemlist(command)
                    end)

                    if not success then
                        notify_markdown("Error executing command", "error", "SelectLatexTemplate")
                    else
                        local output_str = table.concat(output, "\n")
                        local formatted_path = "`" .. dest_dir .. "/" .. new_project_name .. "`"
                        if vim.v.shell_error ~= 0 then
                            notify_markdown("Directory " .. formatted_path .. " exists", "error", "SelectLatexTemplate")
                        else
                            local formatted_path = "`" .. dest_dir .. "/" .. new_project_name .. "`"
                            notify_markdown("Created " .. formatted_path, "info", "SelectLatexTemplate")
                        end
                    end
                end)
                return true
            end,
        })
        :find()
end

vim.api.nvim_set_keymap("n", "<leader>iT", "<cmd>lua SelectLatexTemplate()<CR>", { noremap = true, silent = true })

-- Telescope defaults
require("telescope").setup {

    defaults = {
        file_ignore_patterns = {
            "%.aux",
            "%.lof",
            "%.log",
            "%.lot",
            ".*%-E$", -- Ignore files ending with -E0
            "%.fls,%.out",
            "%.toc",
            "%.vrb",
            "%.snm",
            "%.out",
            "%.jpg",
            "%.xml",
            "%.afdesign",
            "%.pdf",
            "%.svg",
            "%.jpeg",
            "%.fmt",
            "%.fot",
            "%.cb",
            "%.cb2",
            ".%.lb",
            "%.fdb_latexmk",
            "%.synctex",
            "%.synctex",
            "%.synctex.gz",
            "%.synctex.gz",
            "%.pdfsync",
            "%.fls",
            "packer_compiled.lua",
        },
        layout_strategy = "vertical",
        layout_config = {
            --horizontal = {preview_cutoff = 15,
            --preview_width = .5
            --},
            vertical = { prompt_position = "bottom", preview_cutoff = 5, preview_height = 0.45 },
        },
        mappings = {
            i = {
                ["<C-j>"] = "move_selection_next",
                ["<C-b>"] = function(prompt_bufnr)
                    actions.close(prompt_bufnr)
                    fb()
                end,
                ["<C-k>"] = "move_selection_previous",
                ["<C-n>"] = "cycle_history_next",
                ["<C-p>"] = "cycle_history_prev",
            },
            n = {
                -- E.g. Type `[i`, `[I`, `[a`, `[A`, `[o`, `[O` to insert relative path and select the path in visual mode.
                -- Other mappings work the same way with a different prefix.
                ["["] = path_actions.insert_reltobufpath_visual,
                ["]"] = path_actions.insert_abspath_visual,
                ["{"] = path_actions.insert_reltobufpath_insert,
                ["}"] = path_actions.insert_abspath_insert,
                ["-"] = path_actions.insert_reltobufpath_normal,
                ["="] = path_actions.insert_abspath_normal,
                -- If you want to get relative path that is relative to the cwd, use
                -- `relpath` instead of `reltobufpath`
                -- You can skip the location postfix if you specify that in the function name.
                -- ["<C-o>"] = path_actions.insert_relpath_o_visual,
            },
        },
    },
    extensions = {
        undo = {
            use_delta = true,
            side_by_side = true,
            layout_strategy = "vertical",
            layout_config = {
                preview_height = 0.8,
            },
        },
        file_browser = {
            -- use the "ivy" theme if you want
            theme = "ivy",
            layout_config = {
                --horizontal = {preview_cutoff = 15,
                --preview_width = .5
                --},
                vertical = {
                    prompt_position = "bottom",
                    preview_cutoff = 10,
                    preview_height = 0.45,
                },
            },
        },
        fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
        },

        media_files = {
            -- filetypes whitelist
            filetypes = { "png", "pdf", "jpg", "jpeg" },
            find_cmd = "fd",
            image_stretch = 300,
        },

        bibtex = {
            -- Depth for the *.bib file
            depth = 1,
            -- Custom format for citation label
            custom_formats = {},
            -- Format to use for citation label.
            -- Try to match the filetype by default, or use 'plain'
            format = "",
            -- Path to global bibliographies (placed outside of the project)
            global_files = { "/Users/luis/master/notes/Doeke.bib" },
            -- Define the search keys to use in the picker
            search_keys = { "author", "year", "title" },
            -- Template for the formatted citation
            citation_format = "[@{{label}}](file://{{file}})",
            -- Only use initials for the authors first name
            citation_trim_firstname = true,
            --Title for markdown notes
            note_title = "@{{label}}.md",
            --Directory path for new markdown notes
            annotation_path = "/Users/luis/master/notes/",
            -- Max number of authors to write in the formatted citation
            -- following authors will be replaced by "et al."
            citation_max_auth = 2,
            -- Context awareness disabled by default
            context = true,
            -- Fallback to global/directory .bib files if context not found
            -- This setting has no effect if context = false
            context_fallback = true,
            -- Wrapping in the preview window is disabled by default
            wrap = false,
        },
    },
}

require("telescope").load_extension "fzf"
require("telescope").load_extension "media_files"
require("telescope").load_extension "bibtex"
require("telescope").load_extension "find_template"
require("telescope").load_extension "neoclip"
--require("telescope").load_extension "orgmode"
require("telescope").load_extension "undo"
require "telescope_insert_path"
require("telescope").load_extension "file_browser"
--require "telescope._extensions.distant.search"
require("telescope").load_extension "aerial"
--vim.api.nvim_set_keymap("n", "<leader>fb", ":Telescope file_browser<CR>", { noremap = true })
require("telescope").load_extension "workspaces"
vim.cmd [[
    augroup TelescopeTransparency
        autocmd!
        autocmd VimEnter * hi TelescopeNormal guibg=none ctermbg=none
        autocmd VimEnter * hi TelescopeBorder guibg=none ctermbg=none
        autocmd VimEnter * hi TelescopePromptNormal guibg=none ctermbg=none
        autocmd VimEnter * hi TelescopePromptBorder guibg=none ctermbg=none
        autocmd VimEnter * hi TelescopeResultsNormal guibg=none ctermbg=none
        autocmd VimEnter * hi TelescopeResultsBorder guibg=none ctermbg=none
        autocmd VimEnter * hi TelescopePreviewNormal guibg=none ctermbg=none
        autocmd VimEnter * hi TelescopePreviewBorder guibg=none ctermbg=none
    augroup END
]]
