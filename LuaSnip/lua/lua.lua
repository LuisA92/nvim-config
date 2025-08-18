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

CheckCrystallography = function()
    local current_file = vim.api.nvim_buf_get_name(0)
    local current_line = vim.api.nvim_win_get_cursor(0)[1]
    if string.match(current_file, "crystallography.lua") then
        return true
    else
        return false
    end
end

return {
    s(
        { trig = "snip", dscr = "New lua snippet template" },
        fmta(
            [[
			s({trig='<>', snippetType = 'autosnippet'},
			fmta(
				[[
					<>
				<>
				),
				<>
			)
		]],
            {
                i(1, "trigger name"),
                i(2, "snippet"),
                t "]]",
                i(3),
            }
        )
    ),
    s(
        { trig = "mathsnip" },
        fmta(
            [[
			s({trig='<>', },
			fmta(
				[[
					<>
				<>
				),
				{condition = in_mathzone}
			)
		]],
            {
                i(1, "trigger name"),
                i(2, "snippet"),
                t "]]",
            }
        )
    ),
}
