defmodule PayCosern.Schemas.Bill do
  use Mongo.Collection

  collection "bill" do
    attribute(:amount, Decimal.t())
    attribute(:charge_period, List.t())
    attribute(:due_to, DateTime.t())
    attribute(:reference_month, String.t())
    attribute(:status, String.t())
    attribute(:paid_at, DateTime.t())
  end
end
