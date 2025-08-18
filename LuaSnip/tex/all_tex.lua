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

local in_mathzone = function()
    -- The `in_mathzone` function requires the VimTeX plugin
    return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end
-- Then pass the table `{condition = in_mathzone}` to any snippet you want to
-- expand only in math contexts.

return {

    s(
        { trig = "j;", regTrig = true, wordTrig = false, snippetType = "autosnippet", dscr = "Expands 'jl' into '\\' " },
        fmta(
            "\\<>",
            {
                i(1),
            },
            { delimiters = "<>" } -- manually specifying angle bracket delimiters
        )
    ),

    s(
        { trig = "figg", snippetType = "autosnippet" },
        fmta(
            [[
					\begin{figure}[h!tb]
					\centering
					\includegraphics[width = <>\textwidth]{<>}
					\caption{<>}
					\label{fig:<>}
					\end{figure}
				]],
            {
                i(1, ".5"),
                i(2),
                i(3),
                i(4, " "),
            }
        ),
        { condition = line_begin }
    ),

    s(
        { trig = "code", snippetType = "autosnippet" },
        fmta(
            [[
				\\begin{figure}[hb]
				\\definecolor{bg}{rgb}{0.16, 0.17, 0.20}
					\begin{minted}[bgcolor=bg]{python}
						<>
					\\end{minted}
				\\caption{<>}
				\\label{fig:code1}
				\\end{figure}
				]],
            {
                i(1),
                i(2),
            }
        ),
        { condition = line_begin }
    ),

    s(
        { trig = "emm", snippetType = "autosnippet" },
        fmta([[\emph{<>}]], {
            i(1),
        })
    ),

    s(
        { trig = "bff", snippetType = "autosnippet" },
        fmta([[\textbf{<>}]], {
            i(1),
        })
    ),
}
