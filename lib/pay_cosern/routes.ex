defmodule PayCosern.Router do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

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

  get "/bills" do
    with {:ok, data} <- PayCosern.get_cosern_data() do
      conn
      |> put_resp_header("content-type", "application/json")
      |> send_resp(200, Jason.encode!(data))
    else
      {:error, :cant_find_element, error_message} ->
        conn
        |> put_resp_header("content-type", "application/json")
        |> send_resp(
          200,
          Jason.encode!(%{
            author_message: """
            it seems that some element can't be found. 
            This is a cosern problem, probably, but I will check it out eventually
            """,
            error_message: error_message
          })
        )

      {:error, :something_gone_wrong, message} ->
        conn
        |> put_resp_header("content-type", "application/json")
        |> send_resp(
          200,
          Jason.encode!(%{
            author_message: """
            sorry pal, can't give you a feedback. But I will check it out
            """,
            error_message: message
          })
        )
    end
  end

  match _ do
    send_resp(conn, 404, "not found")
  end
end
