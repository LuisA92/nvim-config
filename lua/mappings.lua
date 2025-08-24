local opts = { noremap = true, silent = true }
-- General Settings and Leader Key
vim.g.mapleader = " "
vim.keymap.set("n", "<Space>", "<Nop>", { silent = true })

-- luadev
vim.keymap.set("n", "<leader>sll", "<Plug>(Luadev-RunLine)>", { noremap = true })

-- Buffer and Window Management
vim.keymap.set("n", "<leader>bd", "<Cmd>lua require('snacks').bufdelete()<CR>", { noremap = true })
vim.keymap.set("n", "<S-l>", "<Cmd>bn<CR>", { desc = "Move to next buffer" })
vim.keymap.set("n", "<S-h>", "<Cmd>bn<CR>", { desc = "Move to previous buffer" })

--
vim.keymap.set("n", "<leader>sv", "<Cmd>vsplit<CR>", { noremap = true, desc = "Split window vertically" })
vim.keymap.set("n", "<leader>sh", "<Cmd>split<CR>", { noremap = true, desc = "Split window horizontally" })
vim.keymap.set("n", "<leader>ss", "<Cmd>split<CR>", { noremap = true })

-- Insert Mode Enhancements
vim.keymap.set("i", "<C-p>", "<Plug>luasnip-prev-choice", { noremap = true })

vim.keymap.set("i", "jk", "<C-W>", { noremap = true, desc = "Delete previous word 'jk'" })

vim.keymap.set("i", "<C-k>", "<Up>", { desc = "move up" })
vim.keymap.set("i", "<C-h>", "<Left>", { desc = "move left" })
vim.keymap.set("i", "<C-l>", "<Right>", { desc = "move right" })
vim.keymap.set("i", "<C-j>", "<Down>", { desc = "move down" })

-- Note Taking and Organization

vim.api.nvim_set_keymap("n", "<leader>zd", "<Cmd>ZkNew {group= 'journal',dir = '/Users/luis/master/notes/'}<CR>", opts)

vim.api.nvim_set_keymap("n", "<leader>zn", "<Cmd>ZkNew {title = vim.fn.input('Title: '), group = 'new'}<CR>", opts)

vim.api.nvim_set_keymap("n", "<leader>zp", "<Cmd>PeekOpen <CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>zo", "<Cmd>ZkNotes { sort = { 'modified' } }<CR>", opts)
vim.api.nvim_set_keymap(
    "n",
    "<leader>zo",
    "<Cmd>ZkNotes { sort = { 'modified' } }<CR><Cmd>lua vim.defer_fn(function() if vim.bo.filetype == 'markdown' then vim.opt_local.foldmethod = 'expr'; vim.opt_local.foldexpr = 'v:lua.vim.treesitter.foldexpr()' end end, 100)<CR>",
    opts
)
vim.api.nvim_set_keymap("n", "<leader>zt", "<Cmd>ZkTags<CR>", opts)
vim.api.nvim_set_keymap(
    "n",
    "<leader>pp",
    "<Cmd>!pandoc % -o $(read -p 'Title: '; echo $REPLY).pdf --from markdown --template eisvogel --listings<CR>",
    opts
)

-- change micromamba environment
vim.keymap.set("n", "<leader>fe", ':lua require("swenv.api").pick_venv()<cr>', { desc = "Search environments" })

-- Programming and Development Tools
vim.keymap.set("n", "<leader>gd", "<cmd>Neogen<cr>", { desc = "Generate docstring of current function" })

-- Vimtex mappings
vim.keymap.set("n", "<leader>ll", ":VimtexCompile<CR>")
vim.keymap.set("n", "<leader>lv", ":VimtexView<CR>")
vim.keymap.set("n", "<leader>ls", ":VimtexToggleMain<CR>")

--
vim.api.nvim_set_keymap(
    "n",
    "<leader>ss",
    ":SessionsSave<cr>:echo 'session saved'<CR>",
    { noremap = true, silent = false }
)

-- Better Window Navigation
vim.keymap.set("n", "<C-h>", require("smart-splits").move_cursor_left)
vim.keymap.set("n", "<C-j>", require("smart-splits").move_cursor_down)
vim.keymap.set("n", "<C-k>", require("smart-splits").move_cursor_up)
vim.keymap.set("n", "<C-l>", require("smart-splits").move_cursor_right)

-- Miscellaneous
vim.keymap.set("n", "<leader>w", "<Cmd>write<CR>", { desc = "Save" })

-- Terminal Keymaps
function _G.set_terminal_keymaps()
    local opts = { buffer = 0 }
    vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
    vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
    vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
    vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
    vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
    vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd "autocmd! TermOpen term://* lua set_terminal_keymaps()"

-- Previwer to see boilerplate directory contents
-- local previewers = require "telescope.previewers"

-- local function directory_previewer(opts)
--     opts = opts or {}
--     local cwd = opts.cwd or vim.loop.cwd()
--
--     return previewers.new_buffer_previewer {
--         get_buffer_by_name = function(_, entry)
--             return entry.value
--         end,
--
--         define_preview = function(self, entry, status)
--             if self.state.bufnr then
--                 vim.api.nvim_buf_delete(self.state.bufnr, { force = true })
--             end
--             self.state.bufnr = vim.api.nvim_create_buf(false, true)
--
--             local directory_contents = vim.fn.systemlist(string.format("ls -1 %s", entry.value))
--             vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, directory_contents)
--
--             vim.api.nvim_buf_set_option(self.state.bufnr, "filetype", "dir")
--             vim.api.nvim_buf_set_option(self.state.bufnr, "bufhidden", "wipe")
--
--             --local win = vim.api.nvim_win_set_buf(status.preview_win, self.state.bufnr)
--             --vim.api.nvim_win_set_option(status.preview_win, 'wrap', false)
--         end,
--     }
-- end
--
-- Select a directory to use as boilerplate
-- function _G.select_boilerplate(callback)
--     local function get_subdirectories(parent_directory)
--         local subdirectories = {}
--         local handle = io.popen("find " .. parent_directory .. ' -type d -maxdepth 1 ! -name ".*"')
--         for directory in handle:lines() do
--             if directory ~= parent_directory then
--                 table.insert(subdirectories, directory)
--             end
--         end
--         handle:close()
--         return subdirectories
--     end
--
--     local boilerplate_directories = {
--         "/Users/luis/master/tex_templates/article/",
--     }
--     local parent_directory = "/Users/luis/master/tex_templates" -- Replace with the desired parent directory path
--     local subdirectories = get_subdirectories(parent_directory)
--     for _, directory in ipairs(subdirectories) do
--         table.insert(boilerplate_directories, directory)
--     end
--
--     local function set_directory(prompt_bufnr)
--         local entry = require("telescope.actions.state").get_selected_entry(prompt_bufnr)
--         require("telescope.actions").close(prompt_bufnr)
--         callback(entry.value)
--     end
--     require("telescope").extensions.my_boilerplate_picker = function()
--         require("telescope.pickers")
--             .new({}, {
--                 prompt_title = "Select a boilerplate directory",
--                 finder = require("telescope.finders").new_table {
--                     results = boilerplate_directories,
--                 },
--                 sorter = require("telescope.sorters").get_generic_fuzzy_sorter(),
--                 previewer = directory_previewer(),
--                 attach_mappings = function(prompt_bufnr, map)
--                     map("i", "<CR>", function()
--                         set_directory(prompt_bufnr)
--                     end)
--                     map("n", "<CR>", function()
--                         set_directory(prompt_bufnr)
--                     end)
--                     return true
--                 end,
--             })
--             :find()
--     end
--     require("telescope").extensions.my_boilerplate_picker()
-- end
--
-- function _G.copy_boilerplate()
--     _G.select_boilerplate(function(boilerplate_directory)
--         if not boilerplate_directory then
--             return
--         end
--
--         require("telescope").extensions.file_browser.file_browser {
--             prompt_title = "Select starting path",
--             cwd = "/Users/luis/master/", -- Change this to your preferred starting directory
--             attach_mappings = function(_, map)
--                 map("i", "<C-CR>", function(prompt_bufnr)
--                     local starting_path = require("telescope.actions.state").get_selected_entry(prompt_bufnr)
--                     require("telescope.actions").close(prompt_bufnr)
--
--                     local new_directory_name = vim.fn.input("New directory at " .. starting_path.value .. ":")
--                     if new_directory_name == "" then
--                         return
--                     end
--                     local new_directory = vim.fn.fnamemodify(starting_path.value, ":p") .. new_directory_name
--
--                     -- Delay the execution to ensure previous message is cleared
--                     vim.defer_fn(function()
--                         -- Check if the new directory already exists
--                         if vim.fn.glob(new_directory) ~= "" then
--                             vim.api.nvim_echo(
--                                 { { "Directory already exists: ", "ErrorMsg" }, { new_directory, "None" } },
--                                 true,
--                                 {}
--                             )
--                             return
--                         end
--
--                         local command = string.format("cp -r %s %s", boilerplate_directory, new_directory)
--                         vim.cmd("! " .. command)
--
--                         vim.api.nvim_echo(
--                             { { "New directory created at:", "SuccessMsg" }, { new_directory, "None" } },
--                             true,
--                             {}
--                         )
--                     end, 0)
--                 end)
--
--                 map("n", "<C-CR>", function(prompt_bufnr)
--                     local starting_path = require("telescope.actions.state").get_selected_entry(prompt_bufnr)
--                     require("telescope.actions").close(prompt_bufnr)
--
--                     local new_directory_name =
--                         vim.fn.input("Enter name for the new directory at " .. starting_path.value .. ": ")
--                     if new_directory_name == "" then
--                         return
--                     end
--                     local new_directory = vim.fn.fnamemodify(starting_path.value, ":p") .. new_directory_name
--
--                     -- Delay the execution to ensure previous message is cleared
--                     vim.defer_fn(function()
--                         -- Check if the new directory already exists
--                         if vim.fn.glob(new_directory) ~= "" then
--                             vim.api.nvim_echo(
--                                 { { "Directory already exists: ", "ErrorMsg" }, { new_directory, "None" } },
--                                 true,
--                                 {}
--                             )
--                             return
--                         end
--
--                         local command = string.format("cp -r %s %s", boilerplate_directory, new_directory)
--                         vim.cmd("! " .. command)
--
--                         vim.api.nvim_echo(
--                             { { "New directory created at:", "SuccessMsg" }, { new_directory, "None" } },
--                             true,
--                             {}
--                         )
--                     end, 0)
--                 end)
--                 return true
--             end,
--         }
--     end)
-- end
--
-- vim.api.nvim_set_keymap("n", "<leader>cd", "<cmd>lua _G.copy_boilerplate()<CR>", { noremap = true, silent = false })

function open_current_file_in_obsidian()
    local bufname = vim.api.nvim_buf_get_name(0)
    local vault_name = "notes" -- Replace with your actual vault name
    local path = vim.fn.fnamemodify(bufname, ":p:~:.") -- Get the path relative to home directory

    -- Remove the .md extension
    path = path:gsub("%.md$", "")

    local function urlencode(str)
        return str:gsub("([^%w _%%%-%.~])", function(c)
            return string.format("%%%02X", string.byte(c))
        end):gsub(" ", "%%20")
    end

    local encoded_vault = urlencode(vault_name)
    local encoded_path = urlencode(path)

    local uri = ("obsidian://open?vault=%s&file=%s"):format(encoded_vault, encoded_path)
    uri = vim.fn.shellescape(uri)

    local cmd = "open"
    local args = { uri }

    local cmd_with_args = cmd .. " " .. table.concat(args, " ")
    vim.fn.jobstart(cmd_with_args, {
        on_exit = function(_, exit_code)
            if exit_code ~= 0 then
                print("Failed to open Obsidian with exit code: " .. exit_code)
            end
        end,
    })
end

-- Map the function to a keybinding
vim.api.nvim_set_keymap(
    "n",
    "<leader>oo",
    "<cmd>lua open_current_file_in_obsidian()<CR>",
    { noremap = true, silent = false }
)

-- todo-comments.nvim
vim.keymap.set("n", "]t", function()
    require("todo-comments").jump_next()
end, { desc = "Next todo comment" })

vim.keymap.set("n", "[t", function()
    require("todo-comments").jump_prev()
end, { desc = "Previous todo comment" })
