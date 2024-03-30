defmodule PayCosern.Controllers.SessionController do
  alias PayCosern.Repo
  import Plug.Conn

  def create(conn, %{"handle" => handle, "password" => password}) do
    with {:ok, user_token, user} <- authenticate_user(handle, password) do
      conn
      |> put_resp_header("content-type", "application/json")
      |> send_resp(
        200,
        Jason.encode!(%{
          user: %{
            id: user["id"],
            handle: user["handle"],
            email: user["email"]
          },
          authentication_token: user_token
        })
      )
    else
      {:error, _reason} ->
        conn
        |> put_resp_header("content-type", "application/json")
        |> send_resp(401, Jason.encode!("foda-se"))
    end
  end

  defp authenticate_user(handle, password) do
    with %Repo.Users{} = user <- Repo.get_by!(Repo.Users, handle: handle),
         {:ok, %Repo.Users{id: user_id} = user} <- verify_password(password, user),
         {:ok, user_payload} <- create_user_payload(user) do
      PayCosern.Guardian.encode_and_sign(%{id: user_id}, user_payload, token_type: "user_token")
    end
  end

  def delete(conn, _) do
    conn
    |> PayCosern.Guardian.Plug.sign_out()
    |> put_resp_header("content-type", "application/json")
    |> send_resp(200, Jason.encode!("foda-se"))
  end

  defp verify_password(password, user) do
    if Argon2.verify_pass(password, user.password_hash) do
      {:ok, user}
    else
      {:error, :wrong_credentials}
    end
  end

  defp create_user_payload(%Repo.Users{} = user) do
    {:ok,
     %{
       id: user.id,
       handle: user.handle,
       email: user.email
     }}
  end
end
