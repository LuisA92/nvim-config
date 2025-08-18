"augroup FormatAutogroup
  "autocmd!
  "autocmd BufWritePost * FormatWrite
"augroup END

" Match jupytext markdown content lines (lines starting with "# " but not "# %%")
syntax match jupytextMarkdownLine "^# [^%].*$" contains=@markdownTop
syntax include @markdownTop syntax/markdown.vim
highlight link jupytextMarkdownLine Comment
