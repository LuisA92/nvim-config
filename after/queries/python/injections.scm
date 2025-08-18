; extends

; Fixed pattern - escape the % character
((comment) @injection.content
  (#lua-match? @injection.content "^# |")
  (#set! injection.language "markdown")
  (#offset! @injection.content 0 2 0 0))
