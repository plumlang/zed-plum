; Indent the lines between an opening bracket and its closing one: blocks,
; tree, trait and kind bodies, match arms, lists, maps, arguments and
; parameters.

(_
  "["
  "]" @end) @indent

(_
  "{"
  "}" @end) @indent

(_
  "("
  ")" @end) @indent
