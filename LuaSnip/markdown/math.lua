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

local in_mathzone = function()
    local line = vim.api.nvim_get_current_line()
    local col = vim.api.nvim_win_get_cursor(0)[2]

    -- First check single-line math patterns (existing logic)
    local before_cursor = line:sub(1, col)
    local after_cursor = line:sub(col + 1)

    -- Check if we have $ before and $ after (simple inline math)
    local has_dollar_before = before_cursor:match ".*%$[^%$]*$"
    local has_dollar_after = after_cursor:match "^[^%$]*%$"

    if has_dollar_before and has_dollar_after then
        return true
    end

    -- Check if we have $$ before and $$ after on same line (display math)
    local has_double_before = before_cursor:match ".*%$%$[^%$]*$"
    local has_double_after = after_cursor:match "^[^%$]*%$%$"

    if has_double_before and has_double_after then
        return true
    end

    -- Now check for multi-line $$ blocks
    local buf = vim.api.nvim_get_current_buf()
    local current_row = vim.api.nvim_win_get_cursor(0)[1] - 1 -- 0-indexed
    local total_lines = vim.api.nvim_buf_line_count(buf)

    -- Helper function to check if a line contains a standalone $$ delimiter
    local function is_standalone_delimiter(line_text)
        return line_text:match "^%s*%$%$%s*$" ~= nil
    end

    -- Count standalone $$ delimiters before current position
    local delimiter_count = 0

    -- Check all lines before current line
    for row = 0, current_row - 1 do
        local line_text = vim.api.nvim_buf_get_lines(buf, row, row + 1, false)[1] or ""
        if is_standalone_delimiter(line_text) then
            delimiter_count = delimiter_count + 1
        end
    end

    -- Check current line - only count delimiter if cursor is after it
    local current_line = vim.api.nvim_buf_get_lines(buf, current_row, current_row + 1, false)[1] or ""
    if is_standalone_delimiter(current_line) then
        local delimiter_pos = current_line:find "%$%$"
        if delimiter_pos and col > delimiter_pos + 1 then -- col is 0-indexed, add 2 for $$
            delimiter_count = delimiter_count + 1
        end
    end

    -- If odd number of standalone $$ delimiters, we're inside a math block
    return delimiter_count % 2 == 1
end

return {

    s({ trig = "...", snippetType = "autosnippet" }, t "\\ldots", { condition = in_mathzone }),

    s(
        { trig = "([^%a])mb", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
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
        {
            trig = "([%a%d%$%)%s%]%}])sb",
            wordTrig = false,
            regTrig = true,
            snippetType = "autosnippet",
        },
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
        {
            condition = function()
                -- Get the line to the cursor
                local line_to_cursor = vim.api.nvim_get_current_line():sub(1, vim.fn.col "." - 1)

                -- Check if the line starts with a ">" (quote)
                local is_quote = line_to_cursor:match "^%s*>"

                -- If the line starts with ">", allow expansion
                if is_quote then
                    return true
                end

                -- Otherwise, check if we're in a mathzone
                return in_mathzone()
            end,
        }
    ),

    --s(
    --{ trig = "([%a%d%$%)%s%]%}])sb", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
    --fmta(
    --[[
		--<>_{<>}
	--]]
    --,
    --{
    --f(function(_, snip)
    --return snip.captures[1]
    --end),
    --d(1, get_visual),
    --}
    --),
    --{ condition = in_mathzone }
    --),

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
			\mathbf{<>}
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
        { trig = ".vv", snippetType = "autosnippet" },
        fmta("$<>\\mathbf{<>}$", {
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

    s(
        { trig = "vvs", dscr = "A generic new environmennt", snippetType = "autosnippet" },
        fmt(
            [[
					<>
				]],
            {
                c(1, {
                    fmt("$\\mathbf{s}$ <1>", i(1), { delimiters = "<>" }),
                    fmt("$\\mathbf{s}^{<1>}$<2>", { i(1), i(0) }, { delimiters = "<>" }),
                }),
            },
            { delimiters = "<>" }
        )
    ),

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
        fmta("\\int_{<>}^{<>} <> \\, d<>", {
            i(1, "i = 1"),
            i(2, "N"),
            i(3),
            i(4, "x"),
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
