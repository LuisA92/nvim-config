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

-- Summary: When `SELECT_RAW` is populated with a visual selection, the function
-- returns an insert node whose initial text is set to the visual selection.
-- When `SELECT_RAW` is empty, the function simply returns an empty insert node.
local get_visual = function(args, parent)
    if #parent.snippet.env.SELECT_RAW > 0 then
        return sn(nil, i(1, parent.snippet.env.SELECT_RAW))
    else -- If SELECT_RAW is empty, return a blank insert node
        return sn(nil, i(1))
    end
end

return {
    s(
        { trig = "deff", snippetType = "autosnippet", dscr = "Create a definition callout" },
        fmt(
            [[
          > [!DEFINITION] Definition: {}
				]],
            {
                i(0),
            }
        ),
        { condition = line_begin }
    ),

    s(
        { trig = "thh", snippetType = "autosnippet", dscr = "Create a theorem callout" },
        fmt(
            [[
          > [!THEOREM] Theorem: {}
				]],
            {
                i(0),
            }
        ),
        { condition = line_begin }
    ),

    s(
        { trig = "propp", snippetType = "autosnippet", dscr = "Create a proposition callout" },
        fmt(
            [[
          > [!PROPOSITION] PROPOSITION: {}
				]],
            {
                i(0),
            }
        ),
        { condition = line_begin }
    ),

    s(
        { trig = "corr", snippetType = "autosnippet", dscr = "Create a definition callout" },
        fmt(
            [[
          > [!COROLLARY] Corollary: {}
				]],
            {
                i(0),
            }
        ),
        { condition = line_begin }
    ),

    s(
        { trig = "corr", snippetType = "autosnippet", dscr = "Create a corollary callout" },
        fmt(
            [[
          > [!COROLLARY] Corollary: {}
				]],
            {
                i(0),
            }
        ),
        { condition = line_begin }
    ),

    s(
        { trig = "exx", snippetType = "autosnippet", dscr = "Create an example callout" },
        fmt(
            [[
          > [!EXAMPLE] Example: {}
				]],
            {
                i(0),
            }
        ),
        { condition = line_begin }
    ),

    s(
        { trig = "prr", snippetType = "autosnippet", dscr = "Create a proof callout" },
        fmt(
            [[
          > [!EXAMPLE] Example: {}
				]],
            {
                i(0),
            }
        ),
        { condition = line_begin }
    ),
}
