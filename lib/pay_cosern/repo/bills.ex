defmodule PayCosern.Repo.Bills do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bills" do
    field(:amount, :decimal)
    field(:charge_period, {:array, :string})
    field(:due_to, :utc_datetime)
    field(:reference_month, :string)
    field(:status, :string)
    field(:paid_at, :utc_datetime)

    timestamps()
  end

  def changeset(bill, params \\ %{}) do
    bill
    |> cast(params, [:amount, :charge_period, :due_to, :reference_month, :status, :paid_at])
    |> unique_constraint(:reference_month)
  end
end
