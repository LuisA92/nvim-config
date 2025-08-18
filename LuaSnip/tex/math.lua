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
local extras = require "luasnip.extras"

local get_visual = function(args, parent)
    if #parent.snippet.env.SELECT_RAW > 0 then
        return sn(nil, i(1, parent.snippet.env.SELECT_RAW))
    else -- If SELECT_RAW is empty, return a blank insert node
        return sn(nil, i(1))
    end
end

-- Include this `in_mathzone` function at the start of a snippets file...
local in_mathzone = function()
    -- The `in_mathzone` function requires the VimTeX plugin
    return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end
-- Then pass the table `{condition = in_mathzone}` to any snippet you want to
-- expand only in math contexts.

return {

    s({ trig = "...", snippetType = "autosnippet" }, t "\\ldots", { condition = in_mathzone }),

    s(
        { trig = "([^%a])bb", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
        fmta("<>\\mathbb{<>}", {
            f(function(_, snip)
                return snip.captures[1]
            end),
            d(1, get_visual),
        }),
        { condition = in_mathzone }
    ),

    s(
        { trig = "([^%a])mf", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
        fmta("<>\\mathfrak{<>}", {
            f(function(_, snip)
                return snip.captures[1]
            end),
            d(1, get_visual),
        }),
        { condition = in_mathzone }
    ),

    s(
        { trig = "([^%a])mc", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
        fmta("<>\\mathcal{<>}", {
            f(function(_, snip)
                return snip.captures[1]
            end),
            d(1, get_visual),
        }),
        { condition = in_mathzone }
    ),

    --Delimiters
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

    s(
        { trig = "([%a%)%]%}])00", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
        fmta("<>_{<>}", {
            f(function(_, snip)
                return snip.captures[1]
            end),
            t "0",
        }),
        { condition = in_mathzone }
    ),

    s(
        { trig = "([%a%d%$%)%s%]%}])sp", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
        fmta(
            [[
		<>^{<>}
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
        { trig = "([%a%d%$%)%s%]%}])sb", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
        fmta(
            [[
		<>_{<>}
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
        { trig = "eee", snippetType = "autosnippet" },
        fmta(
            [[
					\begin{equation}
						\label{eq:}
							<>
					\end{equation}
				]],
            {
                i(0),
            }
        ),
        { condition = line_begin }
    ),

    s(
        { trig = "matrix", snippetType = "autosnippet" },
        fmta(
            [[
					\begin{bmatrix}
							<> \\
					\end{bmatrix}
				]],
            {
                i(0),
            }
        ),
        { condition = in_mathzone }
    ),

    s(
        { trig = ".align", snippetType = "autosnippet" },
        fmta(
            [[
					\begin{flalign*}
							%\label{eq:}
							<>
					\end{flalign*}
				]],
            {
                i(0),
            }
        ),
        { condition = line_begin }
    ),

    s(
        { trig = "enum", snippetType = "autosnippet" },
        fmta(
            [[
					\begin{enumerate}
							\item <>
					\end{enumerate}
				]],
            {
                i(1),
            }
        ),
        { condition = line_begin }
    ),

    s(
        { trig = "item", snippetType = "autosnippet" },
        fmta(
            [[
					\begin{itemize}
							\item <>
					\end{itemize}
				]],
            {
                i(1),
            }
        ),
        { condition = line_begin }
    ),

    s(
        { trig = "new", snippetType = "autosnippet", dscr = "A generic new environmennt" },
        fmta(
            [[
					\begin{<>}
							<>
					\end{<>}
				]],
            {
                i(1),
                i(2),
                extras.rep(1),
            }
        ),
        { condition = line_begin }
    ),

    s(
        { trig = "ff", snippetType = "autosnippet" },
        fmta("\\frac{<>}{<>}", {
            i(1),
            i(2),
        }),
        { condition = in_mathzone } -- `condition` option passed in the snippet `opts` table
    ),

    s(
        { trig = "tt", snippetType = "autosnippet" },
        fmta("\\text{<>}", {
            i(1),
        }),
        { condition = in_mathzone }
    ),

    s(
        { trig = "bf", snippetType = "autosnippet" },
        fmta(
            [[
			\mbf{<>}
		]],
            {
                i(1),
            }
        ),
        { condition = in_mathzone }
    ),

    -- LEFT/RIGHT PARENTHESES
    s(
        { trig = "([^%a])paren", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
        fmta("<>\\PARENS{<>}", {
            f(function(_, snip)
                return snip.captures[1]
            end),
            d(1, get_visual),
        })
    ),

    -- LEFT/RIGHT SQUARE BRACES
    s(
        { trig = "([^%a])l%[", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
        fmta("<>\\left[<>\\right", {
            f(function(_, snip)
                return snip.captures[1]
            end),
            d(1, get_visual),
        })
    ),
    -- LEFT/RIGHT ANGLE
    s(
        { trig = "([^%a])l%<", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
        fmta("<>\\langle <>\\rangle", {
            f(function(_, snip)
                return snip.captures[1]
            end),
            d(1, get_visual),
        })
    ),

    -- LEFT/RIGHT CURLY BRACES
    s(
        { trig = "([^%a])l%{", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
        fmta("<>\\{<>\\", {
            f(function(_, snip)
                return snip.captures[1]
            end),
            d(1, get_visual),
        })
    ),

    -- For entering single characters
    s(
        { trig = ".v", snippetType = "autosnippet" },
        fmta("$<>\\v<>$", {
            f(function(_, snip)
                return snip.captures[1]
            end),
            d(1, get_visual),
        })
    ),

    s(
        { trig = "([%a%$%)%s%]%}])pof", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
        fmta(
            [[
		<>p(<>|<>)
	]],
            {
                f(function(_, snip)
                    return snip.captures[1]
                end),
                d(1, get_visual),
                d(2, get_visual),
            }
        )
    ),

    s({ trig = "by", snippetType = "autosnippet" }, t "\\times", { condition = in_mathzone }),

    s({ trig = "mu", snippetType = "autosnippet" }, t "\\mu", { condition = in_mathzone }),

    s({ trig = "sigma", snippetType = "autosnippet" }, t "\\sigma", { condition = in_mathzone }),

    s({ trig = "theta", snippetType = "autosnippet" }, t "\\theta", { condition = in_mathzone }),

    s({ trig = "beta", snippetType = "autosnippet" }, t "\\beta", { condition = in_mathzone }),

    s({ trig = "lambda", snippetType = "autosnippet" }, t "\\lambda", { condition = in_mathzone }),

    s({ trig = "alpha", snippetType = "autosnippet" }, t "\\alpha", { condition = in_mathzone }),

    s({ trig = "rho", snippetType = "autosnippet" }, t "\\rho", { condition = in_mathzone }),

    s({ trig = "mu", snippetType = "autosnippet" }, t "\\mu", { condition = in_mathzone }),

    s({ trig = "psi", snippetType = "autosnippet" }, t "\\psi", { condition = in_mathzone }),

    s({ trig = "vphi", snippetType = "autosnippet" }, t "\\varphi", { condition = in_mathzone }),

    s({ trig = "phi", snippetType = "autosnippet" }, t "\\phi", { condition = in_mathzone }),
    s(
        { trig = "lsm", snippetType = "autosnippet" },
        fmta(
            [[
		\sum \limits_{<>}^{<>}<>
	]],
            { i(1, "k = 1"), i(2, "n"), i(0) }
        ),
        { condition = in_mathzone }
    ),

    s(
        { trig = "lms", snippetType = "autosnippet" },
        fmta(
            [[
		\limits_{<>}^{<>}<>
	]],
            { i(1, "n = 1"), i(2), i(0) }
        ),
        { condition = in_mathzone }
    ),

    s(
        { trig = "deg", snippetType = "autosnippet" },
        fmta(
            [[
		<>^\circ <>
	]],
            {
                f(function(_, snip)
                    return snip.captures[1]
                end),
                i(0),
            }
        ),
        { condition = in_mathzone }
    ),

    s(
        { trig = "vvw", snippetType = "autosnippet" },
        fmt(
            [[
					<>
				]],
            {
                c(1, {
                    fmt("$\\mathbf{w}$ <1>", i(1), { delimiters = "<>" }),
                    fmt("$\\mathbf{w}^{<1>}$<2>", { i(1), i(0) }, { delimiters = "<>" }),
                }),
            },
            { delimiters = "<>" }
        )
    ),

    s(
        { trig = "vvy", dscr = "A generic new environmennt", snippetType = "autosnippet" },
        fmt(
            [[
					<>
				]],
            {
                c(1, {
                    fmt("$\\mathbf{y}$ <1>", i(1), { delimiters = "<>" }),
                    fmt("$\\mathbf{y}^{<1>}$<2>", { i(1), i(0) }, { delimiters = "<>" }),
                }),
            },
            { delimiters = "<>" }
        )
    ),

    s(
        { trig = "vvh", dscr = "A generic new environmennt", snippetType = "autosnippet" },
        fmt(
            [[
					<>
				]],
            {
                c(1, {
                    fmt("$\\mathbf{h}$ <1>", i(1), { delimiters = "<>" }),
                    fmt("$\\mathbf{h}^{<1>}$<2>", { i(1), i(0) }, { delimiters = "<>" }),
                }),
            },
            { delimiters = "<>" }
        )
    ),

    --s(
    --{ trig = "vvs", dscr = "A generic new environmennt", snippetType = "autosnippet" },
    --fmt(
    --[[
					--<>
				--]]
    --{
    --c(1, {
    --fmt("$\\mathbf{s}$ <1>", i(1), { delimiters = "<>" }),
    --fmt("$\\mathbf{s}^{<1>}$<2>", { i(1), i(0) }, { delimiters = "<>" }),
    --}),
    --},
    --{ delimiters = "<>" }
    --)
    --),

    s(
        { trig = "vvz", dscr = "A generic new environmennt", snippetType = "autosnippet" },
        fmt(
            [[
					<>
				]],
            {
                c(1, {
                    fmt("$\\mathbf{z}$ <1>", i(1), { delimiters = "<>" }),
                    fmt("$\\mathbf{z}^{<1>}$<2>", { i(1), i(0) }, { delimiters = "<>" }),
                }),
            },
            { delimiters = "<>" }
        )
    ),

    s(
        { trig = "vvv", dscr = "A generic new environmennt", snippetType = "autosnippet" },
        fmt(
            [[
					<>
				]],
            {
                c(1, {
                    fmt("$\\mathbf{v}$ <1>", i(1), { delimiters = "<>" }),
                    fmt("$\\mathbf{v}^{<1>}$<2>", { i(1), i(0) }, { delimiters = "<>" }),
                }),
            },
            { delimiters = "<>" }
        )
    ),

    s(
        { trig = "vvx", dscr = "A generic new environmennt", snippetType = "autosnippet" },
        fmt(
            [[
					<>
				]],
            {
                c(1, {
                    fmt("$\\mathbf{x}$ <1>", i(1), { delimiters = "<>" }),
                    fmt("$\\mathbf{x}^{<1>}$<2>", { i(1), i(0) }, { delimiters = "<>" }),
                }),
            },
            { delimiters = "<>" }
        )
    ),

    s(
        { trig = "lvx", snippetType = "autosnippet" },
        fmta(
            [[
			<><>
		]],
            {
                c(1, {
                    t "\\mathbf{x}_{1}, \\ldots, \\mathbf{x}_{k}",
                    t "\\mathbf{X}_{1}, \\ldots, \\mathbf{X}_{k}",
                }),
                i(0),
            }
        ),
        { condition = in_mathzone }
    ),

    s(
        { trig = "lx", snippetType = "autosnippet" },
        fmta(
            [[
		<><>
	]],
            {
                c(1, {
                    t "x_{1}, \\ldots, x_{k}",
                    t "X_{1}, \\ldots, X_{k}",
                }),
                i(0),
            }
        ),
        { condition = in_mathzone }
    ),

    s(
        { trig = "ly", snippetType = "autosnippet" },
        fmta(
            [[
		<><>
	]],
            {
                c(1, {
                    t "y_{1}, \\ldots, y_{k}",
                    t "Y_{1}, \\ldots, Y_{k}",
                }),
                i(0),
            }
        ),
        { condition = in_mathzone }
    ),

    s(
        { trig = "lvy", snippetType = "autosnippet" },
        fmta(
            [[
		<><>
	]],
            {
                c(1, {
                    t "\\mathbf{y}_{1}, \\ldots, \\mathbf{y}_{k}",
                    t "\\mathbf{Y}_{1}, \\ldots, \\mathbf{Y}_{k}",
                }),
                i(0),
            }
        ),
        { condition = in_mathzone }
    ),

    s(
        { trig = "prod", snippetType = "autosnippet" },
        fmta(
            [[
		\prod_{<>}^{<>}
	]],
            {
                i(1),
                i(0),
            }
        ),
        { condition = in_mathzone }
    ),

    s(
        { trig = "int", snippetType = "autosnippet" },
        fmta("\\int_{<>}^{<>} <>", {
            i(1, "-1"),
            i(2, "1"),
            i(3),
        }),
        { condition = in_mathzone }
    ),

    s(
        { trig = "sum", snippetType = "autosnippet" },
        fmta("\\sum_{<>}^{<>} <>", {
            i(1, "i=1"),
            i(2, "N"),
            i(3),
        }),
        { condition = in_mathzone }
    ),
    --MathTimePro2 Only
    --
}
