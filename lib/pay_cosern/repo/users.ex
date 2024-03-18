defmodule PayCosern.Repo.Users do
  alias Ecto.Changeset
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.UUID, only: [generate: 0]

  @derive {Jason.Encoder, except: [:__meta__]}

  schema "users" do
    field :external_id, :binary_id
    field :handle, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :email, :string

    timestamps()
  end

  def changeset(user, params) do
    user
    |> cast(params, [:handle, :password, :email])
    |> validate_required([:handle, :password, :email])
    |> unique_constraint(:handle)
    |> put_external_id()
    |> put_password_hash()
  end

  def changeset(params \\ %{}), do: changeset(%__MODULE__{}, params)

  def put_external_id(changeset), do: put_change(changeset, :external_id, generate())

  def put_password_hash(%Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, password_hash: Argon2.hash_pwd_salt(password))
  end

  def put_password_hash(changeset), do: changeset
end
