defmodule PayCosern.Utils.Normalize do
  def amount(nil), do: 0

  def amount(amount) do
    amount
    |> String.trim()
    |> String.split(" ")
    |> Enum.at(1)
    |> String.replace(".", "", global: true)
    |> String.replace(",", ".", global: true)
    |> Decimal.new()
  end

  def charge_period(charged_period) do
    charged_period
    |> Regex.scan(~r/\b(?:\d{2}\/\d{2}\/\d{4})\b/, "De 19/01/2023 a 15/02/2023 ( 28 dias)")
    |> List.flatten()
    |> Enum.map(&parse_date/1)
  end

  def due_to(due_to) do
    parse_date(due_to)
  end

  defp parse_date(date) do
    [day, month, year] = String.split(date, "/")

    Date.new(year, month, day)
  end
end
