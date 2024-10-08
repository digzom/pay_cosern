defmodule PayCosern.Repo.CosernAccounts do
  alias PayCosern.Repo.Bills
  alias PayCosern.Repo.Users
  use Ecto.Schema
  use TypedEctoSchema
  import Ecto.Changeset

  @derive {Jason.Encoder, except: [:__meta__, :users, :bills]}

  typed_schema "cosern_accounts" do
    field :login, :string
    field :password, :string, redact: true

    has_many :bills, Bills

    many_to_many :users, Users, join_through: "users_cosern_accounts"

    timestamps()
  end

  def changeset(params \\ %{}), do: changeset(%__MODULE__{}, params)

  def changeset(cosern_account, params) do
    cosern_account
    |> cast(params, [:login, :password])
    |> validate_required([:login, :password])
    |> unique_constraint(:login)
  end
end
