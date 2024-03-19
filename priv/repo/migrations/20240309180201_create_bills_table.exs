defmodule PayCosern.Repo.Migrations.CreateBillsTable do
  use Ecto.Migration

  def change do
    create table("bills") do
      add :amount, :decimal, null: false
      add :charge_period, {:array, :date}, null: false
      add :due_to, :date, null: false
      add :reference_month, :string, null: false
      add :status, :string, null: false
      add :paid_at, :date
      add :inserted_at, :text_datetime, null: false
      add :updated_at, :text_datetime, null: false
    end

    create index("bills", :reference_month, unique: true)
  end
end
