defmodule PayCosern.Query do
  import Ecto.Query
  alias PayCosern.Repo.Bills
  import PayCosern.Repo

  def all_bills() do
    from(Bills) |> all()
  end

  def last_bill() do
    from(b in Bills, order_by: [desc: :inserted_at], limit: 1) |> one()
  end
end
