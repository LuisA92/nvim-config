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

-- Custom condition: check if line starts with #
local starts_with_hash = function()
    local line = vim.api.nvim_get_current_line()
    return line:match "^#"
end

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

    -- Only check for math if we're in a comment line
    if not line:match "^#" then
        return false
    end

    -- Simple check: look for $ or $$ patterns around cursor
    local before_cursor = line:sub(1, col)
    local after_cursor = line:sub(col + 1)

    -- Check if we have $ before and $ after (simple inline math)
    local has_dollar_before = before_cursor:match ".*%$[^%$]*$"
    local has_dollar_after = after_cursor:match "^[^%$]*%$"

    -- Check if we have $$ before and $$ after (display math)
    local has_double_before = before_cursor:match ".*%$%$[^%$]*$"
    local has_double_after = after_cursor:match "^[^%$]*%$%$"

    return (has_dollar_before and has_dollar_after) or (has_double_before and has_double_after)
end

return {
    s(
        { trig = "nnn", snippetType = "autosnippet", dscr = "New code cell" },
        fmta(
            [[
# %%
<>
]],
            {
                i(1),
            },
            { delimiters = "<>" },
            { condition = line_begin } -- manually specifying angle bracket delimiters
        )
    ),
    s(
        { trig = "nnm", snippetType = "autosnippet", dscr = "New markdown cell" },
        fmta(
            [[
# %% [markdown]
<>
]],
            {
                i(1),
            },
            { delimiters = "<>" },
            { condition = line_begin } -- manually specifying angle bracket delimiters
        )
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
}
