vim.cmd [[
let g:bullets_checkbox_markers = ' x'
let g:bullets_enabled_file_types = ['markdown',]

let g:bullets_outline_levels = ['ROM', 'ABC', 'num', 'abc', 'rom', 'std-']

let g:bullets_delete_last_bullet_if_empty = 1

let g:bullets_custom_mappings = [
  \ ['nmap', 'o', '<Plug>(bullets-newline)'],
  \ ['nmap', '<leader>x', '<Plug>(bullets-toggle-checkbox)'],
  \ ['imap', '<C-t>', '<Plug>(bullets-demote)'],
  \ ]
]]
