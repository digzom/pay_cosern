defmodule PayCosern.Controllers.AuthController do
  import Plug.Conn
  alias Ecto.Changeset
  alias PayCosern.Repo.CosernAccounts
  alias PayCosern.Repo
  alias PayCosern.Repo.Users, as: User

  def create_account(conn, %{"login" => login, "password" => password, "handle" => handle}) do
    with %User{id: _user_id} = user <-
           Repo.get_by(User, handle: handle) |> PayCosern.Repo.preload(:cosern_accounts),
         %User{id: _user_id} = user <- PayCosern.Repo.preload(user, :cosern_accounts),
         %Changeset{changes: _changes} = changeset <- PayCosern.Repo.Users.changeset(user, %{}),
         %Changeset{changes: _changes} = assoc_changeset <-
           Ecto.Changeset.put_assoc(changeset, :cosern_accounts, [
             %CosernAccounts{login: login, password: password}
           ]),
         {:ok, inserted_data} <- Repo.update(assoc_changeset) do
      conn
      |> put_resp_header("content-type", "application/json")
      |> send_resp(200, Jason.encode!(inserted_data))
    else
      nil ->
        conn
        |> put_resp_header("content-type", "application/json")
        |> send_resp(
          400,
          Jason.encode!(%{message: "O handle não pode conectar-se com esta conta."})
        )

      {:error, changeset} ->
        errors = PayCosern.Utils.ErrorHandler.format_errors(changeset)

        conn
        |> put_resp_header("content-type", "application/json")
        |> send_resp(200, Jason.encode!(%{errors: errors}))
    end
  end

  def create(conn, %{"handle" => _handle, "password" => _password} = params) do
    with {:ok, inserted_data} <- params |> User.changeset_for_actions() |> Repo.insert(),
         %User{id: _id} = data <- Repo.preload(inserted_data, :cosern_accounts) do
      conn
      |> put_resp_header("content-type", "application/json")
      |> send_resp(200, Jason.encode!(data))
    else
      {:error, changeset} ->
        errors = PayCosern.Utils.ErrorHandler.format_errors(changeset)

        conn
        |> put_resp_header("content-type", "application/json")
        |> send_resp(400, Jason.encode!(%{errors: errors}))
    end
  end
end
