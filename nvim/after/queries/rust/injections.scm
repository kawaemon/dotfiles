; parse inside python! macro as actual Python code.
(
  (macro_invocation
    (identifier) @_macro_name
    (token_tree) @python)

   (#eq? @_macro_name "python")
   (#offset! @python 0 1 0 -1)
)
