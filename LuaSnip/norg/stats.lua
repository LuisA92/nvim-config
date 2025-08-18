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


local in_mathzone = function()
  -- The `in_mathzone` function requires the VimTeX plugin
  return vim.fn['vimtex#syntax#in_mathzone']() == 1
end
-- Then pass the table `{condition = in_mathzone}` to any snippet you want to
-- expand only in math contexts.

return {
	s({trig='bin', snippetType = 'autosnippet'},
fmta(
	[[	
		\operatorname{Bin}(<>,<>)<>
	]],
	{
			i(1,"\\n"),
			i(2,"\\p"),
      i(0)
	}
	),
	{condition = in_mathzone}
),


	s({trig='norm', snippetType = 'autosnippet'},
fmta(
	[[	
		\mathcal{N}(<>,<>)<>
	]],
	{
			i(1,"\\mu"),
			i(2,"\\sigma^{2}"),
      i(0)
	}
	),
	{condition = in_mathzone}
),

	s({trig='exp', snippetType = 'autosnippet'},
fmta(
	[[	
		\mathbb{E}(<>)<>
	]],
	{
		c(1, {
			t("Y"),
		}),
     i(0)
	}
	),
	{condition = in_mathzone}
),

s({trig='iid', snippettype = 'autosnippet'},
	t("\\overset{\\text{i.i.d}}{\\sim}"),
	{condition = in_mathzone}
),
	s({trig='varr', snippetType = 'autosnippet'},
fmta(
	[[	
		\operatorname{Var}(<>)<>
	]],
	{
		c(1, {
			t("Y"),
		}),
     i(0)
	}
	),
	{condition = in_mathzone}
),



s({trig='arg', snippettype = 'autosnippet'},
	t("\\underset{\\theta}{\\operatorname{arg}} \\operatorname{max}"),
	{condition = in_mathzone}
),



}
