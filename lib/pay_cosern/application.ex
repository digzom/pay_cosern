defmodule PayCosern.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: PayCosern.Worker.start_link(arg)
      # {PayCosern.Worker, arg}
      {Plug.Cowboy, scheme: :http, plug: PayCosern.Router, options: [port: 4000]},
      {Oban, Application.fetch_env!(:pay_cosern, Oban)},
      PayCosern.Repo
    ]

    opts = [strategy: :one_for_one, name: PayCosern.Supervisor]

    Supervisor.start_link(children, opts)
  end
end
