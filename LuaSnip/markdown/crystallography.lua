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

s({trig='rmerge', snippetType = 'autosnippet'},
t(
		'R_{\\text{merge}}'
	),
	{condition = in_mathzone}
),

s({trig='rpim', snippetType = 'autosnippet'},
t(
		'R_{\\text{P.I.M}}'
	),
	{condition = in_mathzone}
),

s({trig='fobs', snippetType = 'autosnippet'},
t(
		'F_{\\text{obs}}'
	),
	{condition = in_mathzone}
),
s({trig='fcalc', snippetType = 'autosnippet'},
t(
		'\\mathbf{F}_{\\text{calc}}'
	),
	{condition = in_mathzone}
),

s({trig='reciprocal space'},
t(
		'\\mathbb{R}^{*}'
	,
	{condition = in_mathzone}
	)
),


--s({trig='rpim', snippetType = 'autosnippet'},
--t(
		--'R_{\\text{P.I.M}}'
	--),
	--{condition = in_mathzone}
--),

--s({trig='rpim', snippetType = 'autosnippet'},
--t(
		--'R_{\\text{P.I.M}}'
	--),
	--{condition = in_mathzone}
--),

--s({trig='rpim', snippetType = 'autosnippet'},
--t(
		--'R_{\\text{P.I.M}}'
	--),
	--{condition = in_mathzone}
--),

--s({trig='rpim', snippetType = 'autosnippet'},
--t(
		--'R_{\\text{P.I.M}}'
	--),
	--{condition = in_mathzone}
--),

--s({trig='rpim', snippetType = 'autosnippet'},
--t(
		--'R_{\\text{P.I.M}}'
	--),
	--{condition = in_mathzone}
--),

--s({trig='rpim', snippetType = 'autosnippet'},
--t(
		--'R_{\\text{P.I.M}}'
	--),
	--{condition = in_mathzone}
--),
}

