defmodule PayCosern.MixProject do
  use Mix.Project

  def project do
    [
      app: :pay_cosern,
      version: "0.1.0",
      elixir: "~> 1.16.1",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  defp aliases() do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate"],
      "ecto.reset": ["ecto.drop", "ecto.setup"]
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
      {:wallaby, "~> 0.30"},
      {:oban, "~> 2.16"},
      {:poolboy, "~> 1.5.2"},
      {:ecto_sqlite3, "~> 0.13"}
    ]
  end
end
