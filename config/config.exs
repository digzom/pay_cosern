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
  driver: Wallaby.Chrome
