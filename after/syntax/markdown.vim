set wrap

unlet b:current_syntax
syntax include @Yaml syntax/yaml.vim
syntax region yamlFrontmatter start=/\%^---$/ end=/^---$/ keepend contains=@Yaml

autocmd FileType markdown highlight markdownInlineCode guibg=NONE

set tabstop=2


