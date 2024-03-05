import Config

config :pay_cosern, PayCosern.Repo,
  database: "paycosern",
  hostname: "localhost",
  port: 27017

config :wallaby,
  driver: Wallaby.Chrome

config :wallaby, :chromedriver, binary: "/usr/bin/chromedriver"

config :pay_cosern,
  ecto_repos: [PayCosern.Repo]
