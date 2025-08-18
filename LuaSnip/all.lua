local fmt = require("luasnip.extras.fmt").fmt
local ls = require "luasnip"
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep
local line_begin = require("luasnip.extras.expand_conditions").line_begin

-- Custom condition: check if line starts with #
local starts_with_hash = function()
    local line = vim.api.nvim_get_current_line()
    return line:match "^#"
end

return {
    s(
        { trig = "j;", snippetType = "autosnippet", dscr = "Expands 'j;' into '\\' " },
        fmta(
            "\\<>",
            {
                i(1),
            },
            { delimiters = "<>" } -- manually specifying angle bracket delimiters
        )
    ),
    s(
        { trig = "jl", snippetType = "autosnippet", dscr = "Expands 'jl' into '$$' " },
        fmta(
            "$<>$",
            {
                i(1),
            },
            { delimiters = "<>" } -- manually specifying angle bracket delimiters
        )
    ),
}
