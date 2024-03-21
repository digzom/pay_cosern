defmodule PayCosern.MixProject do
  use Mix.Project

  @app_name :pay_cosern

  def project do
    [
      app: :pay_cosern,
      version: "0.1.0",
      elixir: "~> 1.16.1",
      name: "#{@app_name}",
      archives: [mix_gleam: "~> 0.6.2"],
      compilers: [:gleam] ++ Mix.compilers(),
      releases: [
        pay_cosern: [
          applications: [ex_unit: :permanent]
        ]
      ],
      erlc_paths: [
        "build/dev/erlang/#{@app_name}/_gleam_artefacts"
      ],
      erlc_include_path: "build/dev/erlang/#{@app_name}/include",
      prune_code_paths: false,
      deps: deps(),
      aliases: aliases()
    ]
  end

  defp aliases() do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "deps.get": ["deps.get", "gleam.deps.get"]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :ecto, :cowboy, :plug],
      mod: {PayCosern.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto_sql, "~>  3.6"},
      {:postgrex, ">=  0.0.0"},
      {:floki, "~> 0.35.0"},
      {:plug, "~>  1.12"},
      {:cowboy, "~>  2.9"},
      {:plug_cowboy, "~> 2.0"},
      {:jason, "~> 1.2.2"},
      {:wallaby, "~> 0.30", runtime: true},
      {:oban, "~> 2.16"},
      {:poolboy, "~> 1.5.2"},
      {:ecto_sqlite3, "~> 0.13"},
      {:timex, "~> 3.0"},
      {:argon2_elixir, "~> 4.0"},
      {:guardian, "~> 2.3.2"},
      {:gleam_stdlib, "~> 0.34 or ~> 1.0"},
      {:gleeunit, "~> 1.0", only: [:dev, :test], runtime: false},
      {:typed_ecto_schema, "~> 0.4.1", runtime: false}
    ]
  end
end
