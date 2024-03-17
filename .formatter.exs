# Used by "mix format"
[
  import_deps: [:ecto_sql, :ecto, :plug],
  inputs: [
    "{mix,.formatter}.exs",
    "{config,lib,test}/**/*.{ex,exs}",
    "priv/repo/migrations/**/*.{ex,exs}"
  ]
]
