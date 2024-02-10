import Config

config :pay_cosern, PayCosern.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "pay_cosern_dev",
  hostname: "localhost",
  pool_size: 10,
  migration_timestamps: [type: :utc_datetime_usec],
  adapter: Ecto.Adapters.Postgres,
  ssl: config_env() == :prod

config :pay_cosern,
  ecto_repos: [PayCosern.Repo],
  generators: [binary_id: true]

config :wallaby,
  driver: Wallaby.Chrome,
  chromedriver: [
    binary: "/usr/local/bin/chromedriver"
  ],
  capabilities: %{
    chromeOptions: %{
      args: [
        "--no-sandbox",
        "window-size=1280,800",
        "--disable-gpu",
        "--disabled-software-rasterizer",
        "--user-agent=Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
        "--disable-blink-features=AutomationControlled"
      ]
    }
  }
