defmodule PayCosern.Controllers.BillsController do
  import Plug.Conn

  def last_bill(conn, %{"account_id" => account_id}) do
    last_bill = PayCosern.get_last_bill(account_id)

    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(200, Jason.encode!(last_bill))
  end

  def bills(conn, %{"account_id" => account_id}) do
    case PayCosern.get_all_bills(account_id) do
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

  def bills(conn, _) do
    conn |> put_resp_header("content-type", "text/plain") |> send_resp(404, "nothing to see here")
  end
end
