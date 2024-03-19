defmodule PayCosern.Repo.Migrations.CreateUsersCosernAccountTable do
  use Ecto.Migration

  def change do
    create table("users_cosern_accounts") do
      add :users_id, references(:users), null: false
      add :cosern_accounts_id, references(:cosern_accounts), null: false
      add :inserted_at, :text_datetime, null: false
      add :updated_at, :text_datetime, null: false
    end
  end
end
