defmodule PayCosern.Repo.CosernAccounts do
  alias PayCosern.Repo.Bills
  alias PayCosern.Repo.Users
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, except: [:__meta__]}

  schema "cosern_accounts" do
    field :login, :string
    field :password, :string, redact: true

    has_many :bills, Bills

    belongs_to :users, Users
  end

  def changeset(cosern_account, params \\ %{}) do
    cosern_account
    |> cast(params, [:login, :password])
    |> validate_required([:login, :password])
    |> unique_constraint(:login)
  end
end
