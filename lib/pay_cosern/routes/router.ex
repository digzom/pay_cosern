defmodule PayCosern.Router do
  use Plug.Router

  plug PayCosern.Plug.Authorize
  plug PayCosern.Plug.OrganizeParams
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
  post "/sign_in", do: to_action(PayCosern.Controllers.SessionController, :create, conn)

  post "/cosern_account" do
    to_action(PayCosern.Controllers.CosernAccountController, :create_account, conn)
  end

  delete "/cosern_account" do
    to_action(PayCosern.Controllers.CosernAccountController, :delete, conn)
  end

  post "/account" do
    to_action(PayCosern.Controllers.AuthController, :create, conn)
  end

  match _ do
    send_resp(conn, 404, "not found")
  end

  def to_action(module, action, %Plug.Conn{request_path: _path} = conn) do
    apply(module, action, [conn, conn.params])
  end
end
