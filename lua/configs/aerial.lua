require("aerial").setup {
    backends = { "lsp", "treesitter" },
    filter_kind = false,
    highlight_on_hover = true,
    layout = {
        default_direction = "prefer_left",
    },
}
