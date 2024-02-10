defmodule PayCosern do
  alias Wallaby.Browser
  alias Wallaby.Query

  @url "https://servicos.neoenergiacosern.com.br/area-logada/Paginas/login.aspx"
  @bills_url "https://servicos.neoenergiacosern.com.br/servicos-ao-cliente/Pages/2-via-conta.aspx"

  def get_data() do
    {:ok, session} =
      Wallaby.start_session(
        chromedriver: [
          binary: "/usr/local/bin/chromedriver"
        ],
        capabilities: %{
          chromeOptions: %{
            args: [
              "--no-sandbox",
              "window-size=1280,1000",
              "--disable-gpu",
              "--disabled-software-rasterizer",
              "--user-agent=Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
              "--disable-blink-features=AutomationControlled"
            ]
          }
        }
      )

    page = Browser.visit(session, @url)

    login_input = Query.css(".cpfcnpj")
    password_input = Query.css(".password")

    Browser.fill_in(page, login_input, with: "970.978.374-20")
    Browser.fill_in(page, password_input, with: "12457836@")

    Browser.send_keys(page, [:enter])

    checkbox = Query.xpath("//input[@value='007007590371']")

    found_checkbox = Browser.find(page, checkbox)

    Wallaby.Element.click(found_checkbox)

    bills_page = Browser.visit(session, @bills_url)
  end
end
