defmodule PayCosern.Controllers.BillsController do
  import Plug.Conn

  def last_bill(conn, _params) do
    last_bill = PayCosern.Query.last_bill()

    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(200, Jason.encode!(last_bill))
  end

  def bills(conn, _params) do
    case PayCosern.get_cosern_data() do
      [] ->
        conn
        |> put_resp_header("content-type", "application/json")
        |> send_resp(200, Jason.encode!([]))

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

      data ->
        conn
        |> put_resp_header("content-type", "application/json")
        |> send_resp(200, Jason.encode!(data))
    end
  end
end
