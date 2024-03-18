defmodule PayCosern.Repo.Migrations.CreateCosernAccountTable do
  use Ecto.Migration

  def change do
    create table("cosern_accounts") do
      add :login, :string, null: false
      add :password, :string, null: false
      add :users_id, references(:users), null: false

      timestamps()
    end
  end
end
