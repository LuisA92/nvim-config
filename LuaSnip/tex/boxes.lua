local fmt = require('luasnip.extras.fmt').fmt
local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep
local line_begin = require("luasnip.extras.expand_conditions").line_begin


local get_visual = function(args, parent)
  if (#parent.snippet.env.SELECT_RAW > 0) then
    return sn(nil, i(1, parent.snippet.env.SELECT_RAW))
  else  -- If SELECT_RAW is empty, return a blank insert node
    return sn(nil, i(1))
  end
end

-- Include this `in_mathzone` function at the start of a snippets file...
local in_mathzone = function()
  -- The `in_mathzone` function requires the VimTeX plugin
  return vim.fn['vimtex#syntax#in_mathzone']() == 1
end
-- Then pass the table `{condition = in_mathzone}` to any snippet you want to
-- expand only in math contexts.


return {

	s({trig="exx", snippetType = 'autosnippet', dscr="A generic new environmennt"},
			fmta(
				[[
					\begin{example}[<>]
						\normalfont
						\label{ex:<>}
							<>
					\end{example}
				]],
				{
					i(1),
					rep(1),
					i(0),
				}
			),
			{condition = line_begin}
		),


	s({trig="theor", snippetType = 'autosnippet', dscr="A generic new environmennt"},
			fmta(
				[[
					\begin{theorem}[<>]
						\normalfont
						\label{theorem:<>}
							<>
					\end{theorem}
				]],
				{
					i(1),
					rep(1),
					i(0),
				}
			),
			{condition = line_begin}
		),

	s({trig="deff", snippetType = 'autosnippet', dscr="A generic new environmennt"},
			fmta(
				[[
					\begin{definition}[<>]
						\label{def:<>}
							<>
					\end{definition}
				]],
				{
					i(1),
					i(2),
					i(0),
				}
			),
			{condition = line_begin}



		)
}
