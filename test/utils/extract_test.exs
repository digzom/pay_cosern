defmodule PayCosernTest do
  alias PayCosern.Utils.Extract
  use ExUnit.Case
  doctest PayCosern.Utils.Extract

  describe "Extract Module" do
    test "amount/1" do
      assert Extract.amount("R$ 203,90") == 203.9
    end

    test "charge_period/1" do
      assert Extract.charge_period("De 19/01/2023 a 15/02/2023 ( 28 dias)") ==
               [~D[2023-01-19], ~D[2023-02-15]]
    end

    test "due_to/1" do
      assert Extract.due_to("24/02/2023") == ~D[2023-02-24]
    end

    test "status/1" do
      assert Extract.status("Paga em 19/07/2023") == "paid"
      assert Extract.status("ATRASADA") == "overdue"
    end

    test "reference_month/1" do
      assert Extract.reference_month("Janeiro 2024") == "01/2024"
    end

    test "paid_at/1" do
      assert Extract.paid_at("Paga em 19/07/2023") == ~D[2023-07-19]
      assert Extract.paid_at("ATRASADA") == nil
    end

    test "from_parsed_data/1" do
      data = [
        %{
          status: "Paga em 26/09/2023",
          amount: "R$ 264,36",
          charge_period: "De 20/07/2023 a 18/08/2023 ( 30 dias)",
          reference_month: "Agosto 2023",
          due_to: "25/08/2023"
        },
        %{
          status: "ATRASADA",
          amount: "R$ 278,73",
          charge_period: "De 09/01/2024 a 05/02/2024 ( 28 dias)",
          reference_month: "Fevereiro 2024",
          due_to: "14/02/2024"
        }
      ]

      assert Extract.from_parsed_data(data) == [
               %{
                 status: "paid",
                 amount: 264.36,
                 charge_period: [~D[2023-07-20], ~D[2023-08-18]],
                 reference_month: "08/2023",
                 due_to: ~D[2023-08-25]
               },
               %{
                 status: "overdue",
                 amount: 278.73,
                 charge_period: [~D[2024-01-09], ~D[2024-02-05]],
                 reference_month: "02/2024",
                 due_to: ~D[2024-02-14]
               }
             ]
    end
  end
end
