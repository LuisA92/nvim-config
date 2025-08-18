local luasnip = require "luasnip"
require("luasnip.loaders.from_lua").load { paths = "~/.config/nvim/LuaSnip/" }

require("luasnip").config.set_config {
    region_check_events = "InsertEnter",
    delete_check_events = "InsertLeave",
    enable_autosnippets = true,
    store_selection_keys = "<Tab>",
    update_events = "TextChanged,TextChangedI",
}
