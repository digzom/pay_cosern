defmodule PayCosern.Repo.UsersCosernAccounts do
  use Ecto.Schema
  alias PayCosern.Repo.CosernAccounts
  alias PayCosern.Repo.Users

  schema "users_cosern_accounts" do
    belongs_to :users, Users
    belongs_to :cosern_accounts, CosernAccounts

    timestamps()
  end
end
