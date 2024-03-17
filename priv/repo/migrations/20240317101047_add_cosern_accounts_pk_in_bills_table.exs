defmodule PayCosern.Repo.Migrations.AddCosernAccountsPkInBillsTable do
  use Ecto.Migration

  def change do
    alter table("bills") do
      add :cosern_account, references(:cosern_accounts), null: false
    end
  end
end
