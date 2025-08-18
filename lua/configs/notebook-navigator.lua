local M = {}

M.keys = {
    {
        "]h",
        function()
            require("notebook-navigator").move_cell "d"
        end,
    },
    {
        "[h",
        function()
            require("notebook-navigator").move_cell "u"
        end,
    },
    { "<leader>x", "<cmd>lua require('notebook-navigator').run_cell()<cr>" },
    { "<leader>X", "<cmd>lua require('notebook-navigator').run_and_move()<cr>" },
    { "<leader>b", "<cmd>lua require('notebook-navigator').add_cell_below()<cr>" },
    { "<leader>a", "<cmd>lua require('notebook-navigator').add_cell_after()<cr>" },
}

M.setup = function()
    local nn = require "notebook-navigator"
    nn.setup {
        activate_hydra_keys = nil,
        syntax_highlight = false,
        cell_markers = {
            python = "# -",
        },
    }
end

return M
