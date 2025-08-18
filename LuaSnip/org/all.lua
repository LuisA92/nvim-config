local ls = require "luasnip"
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep
local line_begin = require("luasnip.extras.expand_conditions").line_begin

local postfix = require("luasnip.extras.postfix").postfix

local function current_date()
    return os.date "%Y-%m-%d %A"
end

return {

    s(
        { trig = "todo", snippetType = "autosnippet", dscr = "Org flavored TODO template" },
        fmta(
            [[
	* TODO <>
	]],
            {
                i(1),
            }
        ),
        { condition = line_begin }
    ),
}
