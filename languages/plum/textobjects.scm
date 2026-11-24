; Functions and methods: `af` is the whole declaration, `if` the body
; between the braces, or the expression after `=>`.

(function_declaration
  body: (block
    "{"
    (_)* @function.inside
    "}")) @function.around

(function_declaration
  "=>"
  body: (_) @function.inside) @function.around

(method_declaration
  body: (block
    "{"
    (_)* @function.inside
    "}")) @function.around

(method_declaration
  "=>"
  body: (_) @function.inside) @function.around

; A trait method without a body
(method_declaration
  !body) @function.around

; Trees, traits and kinds: `ac` is the declaration, `ic` its body

(tree_declaration
  body: (tree_body
    "{"
    (_)* @class.inside
    "}")) @class.around

(trait_declaration
  body: (tree_body
    "{"
    (_)* @class.inside
    "}")) @class.around

(kind_declaration
  body: (kind_body
    "{"
    (_)* @class.inside
    "}")) @class.around

; Adjacent line comments, doc comments, and block comments

(comment)+ @comment.around

(doc_comment)+ @comment.around

(block_comment) @comment.around
