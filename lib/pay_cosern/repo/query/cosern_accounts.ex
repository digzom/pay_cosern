defmodule PayCosern.Query.CosernAccounts do
  alias PayCosern.Query
  import Ecto.Query

  def last_bill(account_id) do
    account_id
    |> from_last_bill()
    |> select_bill_data()
  end

  def from_last_bill(account_id) do
    from(b in Query.Bills.last_bill(),
      where: b.cosern_accounts_id == ^account_id
    )
  end

  def bills(account_id) do
    account_id
    |> from_bills()
    |> select_bill_data()
  end

  def from_bills(account_id) do
    from(b in Query.Bills.bills(),
      as: :bill,
      where: b.cosern_accounts_id == ^account_id
    )
  end

  def select_bill_data(query) do
    from(b in query,
      select: %{
        amount: b.amount,
        charge_period: b.charge_period,
        due_to: b.due_to,
        reference_month: b.reference_month,
        status: b.status,
        paid_at: b.paid_at
      }
    )
  end
end
