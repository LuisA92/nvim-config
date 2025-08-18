vim.cmd [[
let g:wiki_root = '/Users/luis/master/notes/'
let g:wiki_filetypes = ['md']

   let g:wiki_export = {
          \ 'args' : '--template eisvogel',
          \ 'from_format' : 'markdown',
          \ 'ext' : 'pdf',
          \ 'link_ext_replace': v:false,
          \ 'view' : v:false,
          \ 'output': '/Users/luis/Downloads/',
          \}
]]

vim.cmd [[
" Define the custom resolver function
function! MyWikiResolver(url) abort
  let l:url = deepcopy(a:url)

  let l:url.anchor = wiki#url#utils#extract_anchor(l:url.stripped)

  " Resolve the path relative to the root directory
  let l:root = wiki#get_root()
  let l:path = split(l:url.stripped, '#', 1)[0]
  let l:url.path = wiki#url#utils#resolve_path(l:path, l:root)

  return l:url
endfunction

" Configure the wiki plugin to use the custom resolver function
let g:wiki_link_schemes = {
      \ 'wiki': {
      \   'resolver': function('MyWikiResolver'),
      \ }
      \}
      ]]
