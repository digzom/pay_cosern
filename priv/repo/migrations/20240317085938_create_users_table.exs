defmodule PayCosern.Repo.Migrations.CreateUsersTable do
  alias PayCosern.Repo.Users
  use Ecto.Migration

  def change do
    create table("users") do
      add :external_id, :binary_id, null: false
      add :handle, :string, null: false
      add :password_hash, :string, null: false
      add :email, :string

      timestamps()
    end

    create index("users", :handle, unique: true)
  end
end
