import Config

config :pay_cosern, PayCosern.Repo,
  database: "paycosern",
  show_sensitive_data_on_connection_error: true,
  hostname: "localhost",
  port: 27017

config :wallaby,
  driver: Wallaby.Chrome

config :wallaby, :chromedriver,
  binary: "/usr/bin/chromedriver",
  chromedriver: [
    capabilities: %{
      chromeOptions: %{
        args: [
          "--no-sandbox",
          "window-size=1280,1000",
          "--headless",
          "--disable-gpu",
          "--disabled-software-rasterizer",
          "--user-agent=Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.6167 Safari/537.36",
          "--disable-blink-features=AutomationControlled"
        ]
      }
    }
  ]

config :pay_cosern,
  ecto_repos: [PayCosern.Repo]

config :pay_cosern, Oban,
  engine: Oban.Engines.Lite,
  queues: [default: 10],
  repo: PayCosern.Repo,
  plugins: [
    {Oban.Plugins.Cron,
     crontab: [
       {"* 10/6 * * *", PayCosern.Jobs.UpdateBills}
     ]}
  ]

config :pay_cosern, PayCosern.Guardian,
  issuer: "pay_cosern",
  secret_key: "83YO8a77w4tnrSEQjVO81lWhD7c5QdB1MIjcM3726Is52zPR4K4FFQTFSmVEcY9y"
