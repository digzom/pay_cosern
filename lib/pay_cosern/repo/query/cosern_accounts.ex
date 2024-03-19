defmodule PayCosern.Query.CosernAccounts do
  alias PayCosern.Query
  import Ecto.Query

  def last_bill(account_id) do
    from(b in Query.Bills.last_bill(),
      where: b.account_id == ^account_id
    )
  end
end
