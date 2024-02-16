defmodule PayCosernTest do
  alias PayCosern.Utils.Normalize
  use ExUnit.Case
  doctest PayCosern

  describe "Normalize Module" do
    test "amount/1" do
      assert Normalize.amount("R$ 203,90") == Decimal.new(203.9)
    end
  end
end
