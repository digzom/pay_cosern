defmodule PayCosern.Controllers.AuthController do
  import Plug.Conn

  def sign_in(conn, %{"handle" => _handle, "password" => _password}) do
    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(200, Jason.encode!(%{message: "ok"}))
  end

  def create_account(conn, %{"handle" => _handle, "password" => _password} = params) do
    IO.inspect(PayCosern.Repo.Users.changeset(params))

    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(200, %{message: "ok"})
  end
end
