defmodule PayCosern.Repo.Migrations.CreateCosernAccountTable do
  use Ecto.Migration

  def change do
    create table("cosern_accounts") do
      add :login, :string, null: false
      add :password_hash, :string, null: false
      add :user_id, references(:users), null: false
    end
  end
end
