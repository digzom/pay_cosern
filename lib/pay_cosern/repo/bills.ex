defmodule PayCosern.Repo.Bills do
  alias PayCosern.Repo.CosernAccounts
  use Ecto.Schema
  import Ecto.Changeset

  # @derive {Jason.Encoder, except: [:__meta__]}

  schema "bills" do
    field :amount, :decimal
    field :charge_period, {:array, :date}
    field :due_to, :date
    field :reference_month, :string
    field :status, :string
    field :paid_at, :date

    belongs_to :cosern_accounts, CosernAccounts

    timestamps()
  end

  def changeset(bill, params \\ %{}) do
    bill
    |> cast(params, [
      :cosern_accounts_id,
      :amount,
      :charge_period,
      :due_to,
      :reference_month,
      :status,
      :paid_at
    ])
    |> unique_constraint(:reference_month)
  end
end
