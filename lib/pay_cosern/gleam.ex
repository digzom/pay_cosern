defmodule PayCosern.Gleam do
  def validate_structure(map) do
    :pay_cosern.validate_bill_structure(map)
  end
end
