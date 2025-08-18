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


CheckPreviousLine = function()
  local previous_line = vim.fn.getline(vim.fn.line('.') - 1)
  if (previous_line == "```mermaid") then
    return true
  else
    return false
	end
end


Is_even_line = function()
  local line_number = vim.fn.line('.')
  if ((line_number % 2) == 0) then  -- an even-numbered line
    return true
  else  -- an odd-numbered line
    return false
  end
end

return{
	--s({trig="test", snippetType="autosnippet"},
   --fmta(
			 --[[
				--flowchart LR
			--]]
	 --),
   --{condition = CheckPreviousLine}
--),

		--Snippet to insert a mermaid chart
		s({trig="merm",  dscr="A generic new environmennt",snippetType = 'autosnippet'},
			fmt(
				[[
					```mermaid
					{}
					```
				]],
			 	{
					c(1, {
						fmt([[
									flowchart LR
										{} --> {}
								]],
								{
								i(1,'A'),i(2,'B')}),
						fmt([[
									flowchart TD
										{} --> {}
								]],
								{
								i(1,'A'),i(2,'B')}),
						fmt([[
									stateDiagram
										direction LR
										{} --> {}
								]],
								{
								i(1,'[*]'),i(2,'A')}),
				})
				}
			),
			{condition = line_begin}
		),


}
