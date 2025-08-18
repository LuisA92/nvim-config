local ls = require("luasnip")
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

return {

s({trig="j;", snippetType = 'autosnippet',dscr="Expands 'jl' into '\\' "},
			fmta(
				"\\<>",
				{
					i(1),
				},
				{delimiters = "<>"} -- manually specifying angle bracket delimiters
			)
		),

		s({trig=".lnk", dscr="A generic new environmennt"},
			fmta(
				[[
					[<>](<>)
				]],
				{
					i(1),
					i(2)
				}
			)
			)
}
