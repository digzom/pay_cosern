defmodule PayCosern.Controllers.AuthController do
  import Plug.Conn
  alias PayCosern.Utils
  alias PayCosern.Repo.CosernAccounts
  alias Ecto.Changeset
  alias PayCosern.Repo
  alias PayCosern.Repo.Users, as: User

  def create_account(conn, %{"login" => login, "password" => password, "handle" => handle}) do
    with %User{id: _user_id} = user <- PayCosern.get_user_by_handle_with_accounts(handle),
         %Changeset{valid?: true} = assoc <-
           PayCosern.create_users_cosern_accounts_assoc(user, %{
             login: login,
             password: password
           }),
         {:ok, inserted_data} <- Repo.update(assoc) do
      conn
      |> put_resp_header("content-type", "application/json")
      |> send_resp(200, Jason.encode!(inserted_data))
    else
      nil ->
        error =
          Utils.ErrorHandler.bad_request("O handle não pode conectar-se com esta conta.", %{
            handle: handle
          })

        conn
        |> put_resp_header("content-type", "application/json")
        |> send_resp(
          error.code,
          Jason.encode!(error)
        )

      %Ecto.Changeset{valid?: false} = changeset ->
        errors = PayCosern.Utils.ErrorHandler.bad_request(changeset)

        conn
        |> put_resp_header("content-type", "application/json")
        |> send_resp(200, Jason.encode!(%{errors: errors}))

      data ->
        raise FunctionClauseError.message(data)
        errors = PayCosern.Utils.ErrorHandler.internal(message: "something_bad_happened")

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

  def delete(conn, %{"login" => login, "handle" => user_handle}) do
    with %User{id: _user_id} = user <- PayCosern.get_user_by_handle_with_accounts(user_handle),
         %Ecto.Changeset{} = user_changeset <- remove_association(user, login),
         {:ok, updated_user} <- Repo.update(user_changeset) do
      conn
      |> put_resp_header("content-type", "application/json")
      |> send_resp(200, Jason.encode!(updated_user))
    else
      nil ->
        conn
        |> put_resp_header("content-type", "application/json")
        |> send_resp(400, Jason.encode!(%{}))

      %Ecto.Changeset{} = changeset ->
        errors = Utils.ErrorHandler.bad_request(changeset)

        conn
        |> put_resp_header("content-type", "application/json")
        |> send_resp(400, Jason.encode!(errors))

      %Utils.ErrorHandler{code: code} = error ->
        conn
        |> put_resp_header("content-type", "application/json")
        |> send_resp(code, Jason.encode!(error))
    end
  end

  def remove_association(%User{} = user, account_login) do
    with %CosernAccounts{users: users, login: login} <- get_account(account_login),
         true <- Enum.map(users, & &1.id) |> Enum.member?(user.id) do
      updated_relations =
        Enum.filter(user.cosern_accounts, fn account ->
          account.login != login
        end)

      Ecto.Changeset.change(user, %{cosern_accounts: updated_relations})
    else
      false ->
        Utils.ErrorHandler.bad_request("not_associated_account", %{login: account_login})

      nil ->
        Utils.ErrorHandler.not_found("account_does_not_exist", %{login: account_login})
    end
  end

  defp get_account(account_login) do
    Repo.get_by(CosernAccounts, login: account_login) |> Repo.preload(:users)
  end
end
