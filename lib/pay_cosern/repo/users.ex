defmodule PayCosern.Repo.Users do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, except: [:__meta__]}

  schema "users" do
    field :external_id, :string
    field :handle, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :email, :string
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:handle, :password_hash, :password, :email])
    |> validate_required([:handle, :password, :email])
    |> unique_constraint(:handle)
  end
end
