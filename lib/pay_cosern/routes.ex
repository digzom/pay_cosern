defmodule PayCosern.Router do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get "/" do
    send_resp(conn, 200, "nothing to see here. Try to visit /bills to get the bills :)")
  end

  get "/health" do
    send_resp(conn, 200, "i'm alive!!!")
  end

  get "/bills" do
    with {:ok, data} <- PayCosern.dive() do
      conn
      |> put_resp_header("content-type", "application/json")
      |> send_resp(200, Jason.encode!(data))
    else
      {:error, :cant_find_element, error} ->
        conn
        |> put_resp_header("content-type", "application/json")
        |> send_resp(
          200,
          Jason.encode!(%{
            author_message: """
            it seems that some element can't be found. 
            This is a cosern problem, probably, but I will check it out eventually
            """,
            error_message: error
          })
        )

      error ->
        conn
        |> put_resp_header("content-type", "application/json")
        |> send_resp(
          200,
          Jason.encode!(%{
            author_message: """
            sorry pal, can't give you a feedback. But I will check it out
            """,
            error_message: error
          })
        )
    end
  end

  match _ do
    send_resp(conn, 404, "not found")
  end
end
