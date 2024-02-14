defmodule PayCosern.Router do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get "/hello" do
    send_resp(conn, 200, "world")
  end

  get "/bills" do
    data = PayCosern.get_bills()

    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(200, Jason.encode!(data))
  end

  match _ do
    send_resp(conn, 404, "not found")
  end
end
