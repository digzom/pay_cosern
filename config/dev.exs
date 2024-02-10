import Config

config :pay_cosern, PayCosern.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "pay_cosern_dev",
  hostname: "localhost",
  pool_size: 10
