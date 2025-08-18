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

local get_visual = function(args, parent)
    if #parent.snippet.env.SELECT_RAW > 0 then
        return sn(nil, i(1, parent.snippet.env.SELECT_RAW))
    else -- If SELECT_RAW is empty, return a blank insert node
        return sn(nil, i(1))
    end
end

local in_mathzone = function()
    -- The `in_mathzone` function requires the VimTeX plugin
    return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end
-- Then pass the table `{condition = in_mathzone}` to any snippet you want to
-- expand only in math contexts.

return {

    s(
        { trig = "binom", snippetType = "autosnippet" },
        fmta(
            [[
		\binom{<>}{<>}<>
	]],
            {
                i(1, "n"),
                i(2, "k"),
                i(0),
            }
        ),
        { condition = in_mathzone }
    ),

    s(
        { trig = "binn", snippetType = "autosnippet" },
        fmta(
            [[
		\operatorname{Bin}(<>,<>)<>
	]],
            {
                i(1, "n"),
                i(2, "p"),
                i(0),
            }
        ),
        { condition = in_mathzone }
    ),

    s(
        { trig = "binn", snippetType = "autosnippet" },
        fmta(
            [[
		\operatorname{Bin}(<>,<>)<>
	]],
            {
                i(1, "n"),
                i(2, "p"),
                i(0),
            }
        ),
        { condition = in_mathzone }
    ),

    s({ trig = "iid", snippettype = "autosnippet" }, t "\\overset{\\text{i.i.d}}{\\sim}", { condition = in_mathzone }),

    s(
        { trig = "([^%a])ee", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
        fmta(
            [[
		<>=<>
	]],
            {
                f(function(_, snip)
                    return snip.captures[1]
                end),
                d(1, get_visual),
            }
        ),
        { condition = in_mathzone }
    ),

    s(
        { trig = "([%s])aa", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
        fmta(
            [[
		<>&<>
	]],
            {
                f(function(_, snip)
                    return snip.captures[1]
                end),
                d(1, get_visual),
            }
        ),
        { condition = in_mathzone }
    ),

    s(
        { trig = "arg", snippettype = "autosnippet" },
        t "\\underset{\\theta}{\\operatorname{arg}} \\operatorname{max}",
        { condition = in_mathzone }
    ),
}
