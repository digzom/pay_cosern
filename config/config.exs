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

config :pay_cosern, Oban,
  engine: Oban.Engines.Lite,
  queues: [default: 10],
  repo: PayCosern.Repo,
  plugins: [
    {Oban.Plugins.Cron,
     crontab: [
       {"0 3 * * *", PayCosern.Jobs.UpdateBills},
     ]}
  ]
