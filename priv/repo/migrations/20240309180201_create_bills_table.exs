defmodule PayCosern.Repo.Migrations.CreateBillsTable do
  use Ecto.Migration

  @amount_constraint %{name: "amount_should_be_positive", expr: "amount > 0"}

  def change do
    create table("bills") do
      add :amount, :decimal, null: false, check: @amount_constraint
      add :charge_period, {:array, :date}, null: false
      add :due_to, :date, null: false
      add :reference_month, :string, null: false
      add :status, :string, null: false
      add :paid_at, :date
      add :inserted_at, :text_datetime, null: false
      add :updated_at, :text_datetime, null: false
    end

    create_if_not_exists index("bills", :reference_month, unique: true)
  end
end
