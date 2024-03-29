defmodule PayCosern.Controllers.SessionController do
  alias PayCosern.Repo
  import Plug.Conn

  def create(conn, %{"handle" => handle, "password" => password}) do
    with {:ok, user} <- authenticate_user(handle, password) do
      conn
      |> Guardian.Plug.sign_in(user)
      |> put_resp_header("content-type", "application/json")
      |> send_resp(200, Jason.encode!("foda-se"))
    else
      {:error, _reason} ->
        conn
        |> put_resp_header("content-type", "application/json")
        |> send_resp(200, Jason.encode!("foda-se"))
    end
  end

  defp authenticate_user(handle, password) do
    with %Repo.Users{} = user <- Repo.get_by!(Repo.Users, handle: handle),
         true <- Argon2.verify_pass(password, user.password_hash) do
      {:ok, user}
    else
      _error -> {:error, :deu_ruim}
    end
  end

  def delete(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> put_resp_header("content-type", "application/json")
    |> send_resp(200, Jason.encode!("foda-se"))
  end
end
