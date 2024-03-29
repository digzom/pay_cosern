defmodule PayCosern.Controllers.AuthController do
  import Plug.Conn
  require Logger
  alias PayCosern.Repo
  alias PayCosern.Repo.Users, as: User

  def create(conn, %{"handle" => _handle, "password" => _password} = params) do
    with {:ok, inserted_data} <- params |> User.changeset_for_actions() |> Repo.insert(),
         %User{id: _id} = data <- Repo.preload(inserted_data, :cosern_accounts) do
      conn
      |> put_resp_header("content-type", "application/json")
      |> send_resp(200, Jason.encode!(data))
    else
      nil ->
        conn
        |> put_resp_header("content-type", "application/json")
        |> send_resp(400, Jason.encode!(%{}))

      {:error, changeset} ->
        errors = PayCosern.Utils.ErrorHandler.bad_request(changeset)

        conn
        |> put_resp_header("content-type", "application/json")
        |> send_resp(400, Jason.encode!(%{errors: errors}))
    end
  end
end
