; Plumlang highlights for Zed.
;
; When several patterns capture the same node, Zed uses the one that comes
; LAST in this file, so general patterns come first and more specific ones
; after them. Capture names are the ones Zed themes style; a name with a
; suffix (`keyword.control`, `function.builtin`) falls back to its prefix in
; themes that do not style the suffix.

; Punctuation

[
  "("
  ")"
  "["
  "]"
  "{"
  "}"
] @punctuation.bracket

[
  ","
  "."
  ":"
] @punctuation.delimiter

; Operators

[
  "+"
  "-"
  "*"
  "/"
  "//"
  "%"
  "**"
  "&"
  "|"
  "^"
  "~"
  "<<"
  ">>"
  "=="
  "!="
  "<"
  "<="
  ">"
  ">="
  "="
  "+="
  "-="
  "*="
  "/="
  "//="
  "%="
  "**="
  "&="
  "|="
  "^="
  "<<="
  ">>="
  "??"
  "?."
  "?"
  ".."
  "..="
  "->"
  "=>"
] @operator

; Keywords

[
  "and"
  "or"
  "not"
  "in"
  "is"
  "as"
] @keyword.operator

[
  "plant"
  "root"
  "tree"
  "trait"
  "kind"
  "branch"
  "weak"
  "seed"
  "spawn"
] @keyword

[
  "if"
  "else"
  "match"
  "for"
  "while"
  "return"
  "try"
  "catch"
  "finally"
  "throw"
  (break_statement)
  (continue_statement)
] @keyword.control

(for_statement
  "in" @keyword.control)

(seed_statement
  "as" @keyword)

; Variables

(identifier) @variable

((identifier) @type
  (#match? @type "^[A-Z]"))

((identifier) @constant
  (#match? @constant "^_*[A-Z][A-Z0-9_]*$"))

(constant_declaration
  name: (identifier) @constant)

(self) @variable.special

(super) @variable.special

(wildcard) @variable.special

; Fields and keyword arguments

(field_declaration
  name: (identifier) @property)

(member_expression
  field: (identifier) @property)

((member_expression
  field: (identifier) @constant)
  (#match? @constant "^_*[A-Z][A-Z0-9_]*$"))

(keyword_argument
  name: (identifier) @property)

; Parameters

(parameter
  name: (identifier) @variable.parameter)

(lambda_parameter
  name: (identifier) @variable.parameter)

; Functions

(call_expression
  function: (identifier) @function)

((call_expression
  function: (identifier) @constructor)
  (#match? @constructor "^[A-Z]"))

((call_expression
  function: (identifier) @function.builtin)
  (#any-of? @function.builtin
    "drop" "ask" "len" "int" "float" "str" "byte" "type_of" "assert" "exit" "set"))

(call_expression
  function: (member_expression
    field: (identifier) @function.method))

(function_declaration
  name: (identifier) @function)

(method_declaration
  name: (identifier) @function.method)

; Types

(type_identifier) @type

((type_identifier) @type.builtin
  (#any-of? @type.builtin
    "int" "float" "bool" "str" "byte" "list" "map" "set" "Channel" "Json"))

(tree_declaration
  name: (type_identifier) @type)

(trait_declaration
  name: (type_identifier) @type)

(kind_declaration
  name: (type_identifier) @enum)

(kind_case
  name: (identifier) @variant)

; Imports

(seed_statement
  path: (relative_path) @string.special)

; Literals

(integer) @number

(float) @number

(boolean) @boolean

(none) @constant.builtin

(string) @string

(escape_sequence) @string.escape

(format_specifier) @string.special

(interpolation
  "{" @punctuation.special
  "}" @punctuation.special)

; Comments

(comment) @comment
