defmodule PayCosern.Repo.Migrations.CreateBillsTable do
  use Ecto.Migration

  def change do
    create table("bills") do
      add(:amount, :decimal, null: false)
      add(:charge_period, {:array, :string}, null: false)
      add(:due_to, :utc_datetime, null: false)
      add(:reference_month, :string, null: false)
      add(:status, :string, null: false)
      add(:paid_at, :utc_datetime, null: false)
    end
  end
end
