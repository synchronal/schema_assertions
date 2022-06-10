# Used by "mix format"
[
  import_deps: [:ecto],
  inputs: ["{mix,.formatter,.credo}.exs", "{config,lib,test}/**/*.{ex,exs}"],
  line_length: 120,
  subdirectories: ["priv/*/migrations"],
  export: [
    locals_without_parens: [
      assert_changeset_fields: :*,
      assert_changeset_invalid: :*,
      assert_changeset_valid: :*,
      assert_schema: 3
    ]
  ]
]
