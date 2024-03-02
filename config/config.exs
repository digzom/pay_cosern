import Config

config :pay_cosern, PayCosern.Repo,
  database: "paycosern",
  hostname: "localhost",
  port: 27017

config :wallaby,
  driver: Wallaby.Chrome

config :wallaby, :chromedriver, binary: "/usr/local/bin/chromedriver"
