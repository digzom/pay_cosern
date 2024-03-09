Application.load(:wallaby)
Application.put_env(:wallaby, :max_wait_time, 10_000)

defmodule PayCosern do
  require Logger
  alias PayCosern.Utils.Extract
  alias Wallaby.Browser
  alias Wallaby.Query

  @url "https://servicos.neoenergiacosern.com.br/area-logada/Paginas/login.aspx"
  @bills_url "https://servicos.neoenergiacosern.com.br/servicos-ao-cliente/Pages/historicoconsumo.aspx"

  def dive() do
    {:ok, session} =
      Wallaby.start_session(
        chromedriver: [
          binary: "/usr/bin/chromedriver"
        ],
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
      )

    try do
      IO.puts("Visiting Cosern...\n")
      page = Browser.visit(session, @url)

      IO.puts("Entering the matrix...\n")
      login_input = Query.css(".cpfcnpj")
      password_input = Query.css(".password")

      Browser.fill_in(page, login_input, with: System.get_env("LOGIN"))
      Browser.fill_in(page, password_input, with: System.get_env("PASSWORD"))

      IO.inspect(Browser.current_url(page))
      Browser.send_keys(page, [:enter])

      checkbox = Query.xpath("//input[@value='007007590371']")
      IO.puts("We are inside.\n")

      found_checkbox = Browser.find(page, checkbox)

      Wallaby.Element.click(found_checkbox)

      IO.puts("Visiting bills page...\n")
      Browser.visit(session, @bills_url)

      IO.puts("Waiting for this page to load... Let's wait some seconds.")
      :timer.sleep(6_000)

      IO.puts("Yep, it's slow as fuck.")
      :timer.sleep(4_000)

      IO.puts("How's your family?")
      :timer.sleep(2_000)

      IO.puts("I'm sure that you will never forget this shit again lol")
      :timer.sleep(1_000)

      bills_data =
        Browser.find(page, Query.css("#DataTables_Table_1 > tbody > tr > td", count: :any))

      with {:ok, parsed_data} <- Extract.parse_raw_data(bills_data),
           {:ok, extracted_data} <- Extract.from_parsed_data(parsed_data) do
        {:ok, extracted_data}
      else
        error ->
          Logger.error(error)
      end
    rescue
      error in Wallaby.QueryError ->
        Logger.error(error)
        {:error, :cant_find_element, error.message}

      error ->
        Logger.error(error)

        {:error, :something_gone_wrong,
         "the cosern website is experiencing some issues, sorry bro"}
    end
  end
end
