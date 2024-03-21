defmodule PayCosern.Repo.CosernAccounts do
  alias PayCosern.Repo.Bills
  alias PayCosern.Repo.Users
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, except: [:__meta__, :users, :bills]}

  schema "cosern_accounts" do
    field :login, :string
    field :password, :string, redact: true

    has_many :bills, Bills

    many_to_many :users, Users, join_through: "users_cosern_accounts"

    timestamps()
  end

  def changeset(params \\ %{}), do: changeset(%__MODULE__{}, params)

  def changeset(cosern_account, %{user: user} = params) do
    cosern_account
    |> cast(params, [:login, :password])
    |> cast_assoc(:users)
    |> validate_required([:login, :password])
    |> unique_constraint(:login)
    |> put_change(:users, [user])
  end
end
