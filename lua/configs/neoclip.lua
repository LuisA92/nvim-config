require('neoclip').setup({
              history = 1000,
              enable_persistent_history = true,
              length_limit = 1048576,
              continuous_sync = true,
              db_path = vim.fn.stdpath("data") .. "/databases/neoclip.sqlite3",
              filter = nil,
              preview = true,
              default_register = '"',
              default_register_macros = 'q',
              enable_macro_history = true,
              content_spec_column = false,
              on_paste = {
                set_reg = true,
              },
              on_replay = {
                set_reg = false,
              },
              keys = {
                telescope = {
                  i = {
                    select = "<nop>",
                    paste = "<nop>",
                    paste_behind = "<cr>",
                    replay = "<nop>",
                    delete = "<c-d>",
                    custom = {},
                  },
                  n = {
                    select = "<nop>",
                    paste = "<nop>",
                    paste_behind = "<cr>",
                    replay = "<nop>",
                    delete = "dd",
                    custom = {},
                  }
                },
              },
            })
