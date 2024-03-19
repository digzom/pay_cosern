defmodule PayCosern.Guardian do
  alias PayCosern.Query.Users
  alias PayCosern.Repo
  use Guardian, otp_app: :my_app

  def subject_for_token(%{id: id}, _claims) do
    sub = to_string(id)
    {:ok, sub}
  end

  def subject_for_token(_, _) do
    {:error, :reason_for_error}
  end

  def resource_from_claims(%{"sub" => id}) do
    resource = Repo.get(Users, id)
    {:ok, resource}
  end

  def resource_from_claims(_claims) do
    {:error, :reason_for_error}
  end
end
