; Functions and methods

(function_declaration
  "branch" @context
  name: (identifier) @name) @item

(method_declaration
  "branch" @context
  name: (identifier) @name) @item

; Trees, traits and kinds, with their fields and cases

(tree_declaration
  "tree" @context
  name: (type_identifier) @name) @item

(trait_declaration
  "trait" @context
  name: (type_identifier) @name) @item

(kind_declaration
  "kind" @context
  name: (type_identifier) @name) @item

(field_declaration
  name: (identifier) @name) @item

(kind_case
  name: (identifier) @name) @item

; Top-level constants

(source_file
  (constant_declaration
    "root" @context
    name: (identifier) @name) @item)
