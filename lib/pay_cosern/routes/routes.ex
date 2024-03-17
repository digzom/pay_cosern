defmodule PayCosern.Router do
  alias Plug.Conn
  use Plug.Router

  plug :match
  plug :dispatch

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart],
    pass: ["text/*"],
    json_decoder: Jason

  get "/" do
    conn
    |> put_resp_content_type("text/html")
    |> send_resp(
      200,
      "<p style='font-size: 70px'>nothing to see here. Try to visit <a href='/bills'>/bills</a> to get the bills :)</p>"
    )
  end

  get "/health" do
    send_resp(conn, 200, "<p style='font-size: 150px'>i'm alive!!!</p>")
  end

  get "/last_bill", do: to_action(PayCosern.Controllers.BillsController, :last_bill, conn)
  get "/bills", do: to_action(PayCosern.Controllers.BillsController, :bills, conn)
  post "/authenticate", do: to_action(PayCosern.Controllers.AuthController, :sign_in, conn)

  post "/create_account" do
    to_action(PayCosern.Controllers.AuthController, :create_account, conn)
  end

  match _ do
    send_resp(conn, 404, "not found")
  end

  def to_action(module, action, %Conn{params: params} = conn) do
    {_, body, conn} = read_body(conn)
    body = decode_body(body)
    params = Map.merge(params, body)

    apply(module, action, [conn, params])
  end

  def decode_body(body) when body in [nil, "", false], do: %{}

  def decode_body(body) do
    Jason.decode!(body)
  end
end
