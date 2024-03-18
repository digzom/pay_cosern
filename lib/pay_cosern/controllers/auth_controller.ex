defmodule PayCosern.Controllers.AuthController do
  import Plug.Conn
  alias PayCosern.Repo.CosernAccounts
  alias PayCosern.Repo
  alias PayCosern.Repo.Users

  def create_account(
        conn,
        %{
          "login" => _login,
          "password" => _password,
          "handle" => handle
        } = params
      ) do
    user_id = Repo.get_by!(Users, handle: handle) |> Map.get(:id)

    params = Map.put(params, "users_id", user_id)

    with {:ok, inserted_data} <- params |> CosernAccounts.changeset() |> Repo.insert() do
      conn
      |> put_resp_header("content-type", "application/json")
      |> send_resp(200, Jason.encode!(inserted_data))
    else
      {:error, _changeset} ->
        conn
        |> put_resp_header("content-type", "application/json")
        |> send_resp(200, Jason.encode!(%{message: "ok"}))
    end

    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(200, Jason.encode!(%{message: "ok"}))
  end

  def create(conn, %{"handle" => _handle, "password" => _password} = params) do
    with {:ok, inserted_data} <- params |> Users.changeset() |> Repo.insert() do
      conn
      |> put_resp_header("content-type", "application/json")
      |> send_resp(200, Jason.encode!(inserted_data))
    else
      {:error, _changeset} ->
        conn
        |> put_resp_header("content-type", "application/json")
        |> send_resp(200, Jason.encode!(%{message: "ok"}))
    end
  end
end
