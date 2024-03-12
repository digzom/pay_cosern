import Config

config :pay_cosern, PayCosern.Repo,
  database: "paycosern",
  show_sensitive_data_on_connection_error: true,
  hostname: "localhost",
  port: 27017

config :wallaby,
  driver: Wallaby.Chrome

config :wallaby, :chromedriver, binary: "/usr/bin/chromedriver"

config :pay_cosern,
  ecto_repos: [PayCosern.Repo]
