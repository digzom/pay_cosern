defmodule PayCosern.Query do
  import Ecto.Query
  alias PayCosern.Repo.Bills
  alias PayCosern.Repo.Users
  import PayCosern.Repo

  def all_bills() do
    from(Bills) |> all()
  end

  def last_bill() do
    from(b in Bills, order_by: [desc: :inserted_at], limit: 1) |> one()
  end

  def user_by_id(id) do
    from(user in Users, where: user.id == ^id) |> one()
  end

  def user_by_handle(handle) do
    from(user in Users, where: user.handle == ^handle) |> one()
  end
end
