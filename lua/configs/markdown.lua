require("render-markdown").setup {
    -- Whether Markdown should be rendered by default or not
    completions = { blink = { enabled = true } },
    patterns = {
        markdown = {
            disable = true,
            directives = {
                { id = 17, name = "conceal_lines" },
                { id = 18, name = "conceal_lines" },
            },
        },
    },
    enabled = true,
    -- Maximum file size (in MB) that this plugin will attempt to render
    -- Any file larger than this will effectively be ignored
    max_file_size = 1.5,
    -- Capture groups that get pulled from markdown
    -- Only intended to be used for plugin development / debugging
    log_level = "error",
    -- Filetypes this plugin will run on
    file_types = { "markdown" },
    -- Vim modes that will show a rendered view of the markdown file
    -- All other modes will be uneffected by this plugin
    render_modes = { "n", "c" },

    anti_conceal = {
        -- This enables hiding any added text on the line the cursor is on
        -- This does have a performance penalty as we must listen to the 'CursorMoved' event
        enabled = true,
    },

    latex = {
        -- Whether LaTeX should be rendered, mainly used for health check
        enabled = false,
        converter = "latex2text",
        --highlight = "RenderMarkdownMath",
    },

    heading = {
        -- Turn on / off heading icon & background rendering
        enabled = false,
        -- Turn on / off any sign column related rendering
        icons = { "" },
    },
    code = {
        -- Turn on / off code block & inline code rendering
        enabled = true,
        -- Turn on / off any sign column related rendering
        sign = true,
        -- Determines how code blocks & inline code are rendered:
        --  none: disables all rendering
        --  normal: adds highlight group to code blocks & inline code, adds padding to code blocks
        --  language: adds language icon to sign column if enabled and icon + name above code blocks
        --  full: normal + language
        style = "full",
        -- Amount of padding to add to the left of code blocks
        left_pad = 0,
        -- Determins how the top / bottom of code block are rendered:
        --  thick: use the same highlight as the code body
        --  thin: when lines are empty overlay the above & below icons
        border = "thin",
        -- Used above code blocks for thin border
        above = "▄",
        -- Used below code blocks for thin border
        below = "",
        -- Highlight for code blocks & inline code
        highlight = "RenderMarkdownCode",
        highlight_inline = "RenderMarkdownCodeInline",
    },
    dash = {
        -- Turn on / off thematic break rendering
        enabled = true,
        -- Replaces '---'|'***'|'___'|'* * *' of 'thematic_break'
        -- The icon gets repeated across the window's width
        icon = "─",
        -- Highlight for the whole line generated from the icon
        highlight = "RenderMarkdownDash",
    },
    bullet = {
        -- Turn on / off list bullet rendering
        enabled = true,
    },

    -- Checkboxes are a special instance of a 'list_item' that start with a 'shortcut_link'
    -- There are two special states for unchecked & checked defined in the markdown grammar
    checkbox = {
        -- Turn on / off checkbox state rendering
        enabled = true,
        unchecked = {
            -- Replaces '[ ]' of 'task_list_marker_unchecked'
            icon = "󰄱 ",
            -- Highlight for the unchecked icon
            highlight = "RenderMarkdownUnchecked",
            -- Highlight for item associated with unchecked checkbox
            scope_highlight = nil,
        },
        checked = {
            -- Replaces '[x]' of 'task_list_marker_checked'
            icon = "󰱒 ",
            -- Highlight for the checked icon
            highlight = "RenderMarkdownChecked",
            -- Highlight for item associated with checked checkbox
            scope_highlight = nil,
        },
        custom = {
            todo = { raw = "[-]", rendered = "󰥔 ", highlight = "RenderMarkdownTodo", scope_highlight = nil },
        },
    },
    quote = {
        -- Turn on / off block quote & callout rendering
        enabled = true,
        -- Replaces '>' of 'block_quote'
        icon = "▋",
        -- Highlight for the quote icon
        highlight = "RenderMarkdownQuote",
    },
    pipe_table = {
        -- Turn on / off pipe table rendering
        enabled = false,
    },
    -- Callouts are a special instance of a 'block_quote' that start with a 'shortcut_link'
    -- Can specify as many additional values as you like following the pattern from any below, such as 'note'
    --   The key in this case 'note' is for healthcheck and to allow users to change its values
    --   'raw': Matched against the raw text of a 'shortcut_link', case insensitive
    --   'rendered': Replaces the 'raw' value when rendering
    --   'highlight': Highlight for the 'rendered' text and quote markers
    callout = {
        note = { raw = "[!NOTE]", rendered = "󰋽 Note", highlight = "RenderMarkdownInfo" },
        theorem = { raw = "[!THEOREM]", rendered = "󱓷 Theorem", highlight = "RenderMarkdownInfo" },
        proof = { raw = "[!PROOF]", rendered = " Proof", highlight = "RenderMarkdownInfo" },
        definition = { raw = "[!DEFINITION]", rendered = "≜ Definition", highlight = "RenderMarkdownInfo" },
        lemma = { raw = "[!LEMMA]", rendered = "󱓷 Lemma", highlight = "RenderMarkdownInfo" },
        corollary = { raw = "[!COROLLARY]", rendered = "󱓷 Corollary", highlight = "RenderMarkdownInfo" },
        proposition = { raw = "[!PROPOSITION]", rendered = "󱓷 Proposition", highlight = "RenderMarkdownInfo" },
        tip = { raw = "[!TIP]", rendered = "󰌶 Tip", highlight = "RenderMarkdownSuccess" },
        important = { raw = "[!IMPORTANT]", rendered = "󰅾 Important", highlight = "RenderMarkdownHint" },
        warning = { raw = "[!WARNING]", rendered = "󰀪 Warning", highlight = "RenderMarkdownWarn" },
        caution = { raw = "[!CAUTION]", rendered = "󰳦 Caution", highlight = "RenderMarkdownError" },
        -- Obsidian: https://help.a.md/Editing+and+formatting/Callouts
        abstract = { raw = "[!ABSTRACT]", rendered = "󰨸 Abstract", highlight = "RenderMarkdownInfo" },
        todo = { raw = "[!TODO]", rendered = "󰗡 Todo", highlight = "RenderMarkdownInfo" },
        success = { raw = "[!SUCCESS]", rendered = "󰄬 Success", highlight = "RenderMarkdownSuccess" },
        question = { raw = "[!QUESTION]", rendered = "󰘥 Question", highlight = "RenderMarkdownWarn" },
        failure = { raw = "[!FAILURE]", rendered = "󰅖 Failure", highlight = "RenderMarkdownError" },
        danger = { raw = "[!DANGER]", rendered = "󱐌 Danger", highlight = "RenderMarkdownError" },
        bug = { raw = "[!BUG]", rendered = "󰨰 Bug", highlight = "RenderMarkdownError" },
        example = { raw = "[!EXAMPLE]", rendered = "󰉹 Example", highlight = "RenderMarkdownHint" },
        quote = { raw = "[!QUOTE]", rendered = "󱆨 Quote", highlight = "RenderMarkdownQuote" },
    },
    link = {
        -- Turn on / off inline link icon rendering
        enabled = true,
        -- Inlined with 'image' elements
        image = "󰥶 ",
        -- Inlined with 'inline_link' elements
        hyperlink = "󰌹 ",
        -- Applies to the inlined icon
        highlight = "RenderMarkdownLink",
    },
    sign = {
        -- Turn on / off sign rendering
        enabled = true,

        -- Applies to background of sign text
        highlight = "RenderMarkdownSign",
    },
    -- Window options to use that change between rendered and raw view
    win_options = {
        -- See :h 'conceallevel'
        conceallevel = {
            -- Used when not being rendered, get user setting
            default = vim.api.nvim_get_option_value("conceallevel", {}),
            -- Used when being rendered, concealed text is completely hidden
            rendered = 2,
        },
        -- See :h 'concealcursor'
        concealcursor = {
            -- Used when not being rendered, get user setting
            default = vim.api.nvim_get_option_value("concealcursor", {}),
            -- Used when being rendered, disable concealing text in all modes
            rendered = "",
        },
    },
    -- Mapping from treesitter language to user defined handlers
    -- See 'Custom Handlers' document for more info
    custom_handlers = {},
}
