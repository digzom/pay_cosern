defmodule PayCosern.Repo.Migrations.CreateCosernAccountTable do
  use Ecto.Migration

  def change do
    create table("cosern_accounts") do
      add :login, :string, null: false
      add :password, :string, null: false
      add :inserted_at, :text_datetime, null: false
      add :updated_at, :text_datetime, null: false
    end

    create_if_not_exists index("cosern_accounts", :login, unique: true)
  end
end
