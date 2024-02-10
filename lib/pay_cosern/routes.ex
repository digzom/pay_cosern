defmodule PayCosern.Router do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get "/hello" do
    send_resp(conn, 200, "world")
  end

  get "/bills" do
    send_resp(conn, 200, Jason.encode!(%{tai: 1}))
  end

  match _ do
    send_resp(conn, 404, "not found")
  end
end
