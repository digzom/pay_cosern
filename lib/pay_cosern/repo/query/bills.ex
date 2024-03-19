defmodule PayCosern.Query.Bills do
  import Ecto.Query
  alias PayCosern.Repo.Bills

  def last_bill() do
    from(b in Bills, order_by: [desc: :inserted_at], limit: 1)
  end
end
