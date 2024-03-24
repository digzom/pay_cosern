defmodule PayCosern.Utils.Extract do
  require Logger
  alias Wallaby.Element
  # alias PayCosern.Gleam

  @type parsed_data :: %{
          status: String.t(),
          amount: String.t(),
          charge_period: String.t(),
          reference_month: String.t(),
          due_to: String.t(),
          paid_at: Date.t()
        }

  @keys [:reference_month, :charge_period, :due_to, :amount, :status, :paid_at]

  @spec parse_raw_data(raw_data :: list()) :: {:ok, any()}
  def parse_raw_data(raw_data) do
    parsed_data =
      raw_data
      |> Enum.map(fn data -> Element.text(data) end)
      |> Enum.filter(&(&1 != ""))
      |> Enum.chunk_every(5)
      |> Enum.map(fn list ->
        paid_at = List.last(list)
        list = list ++ [paid_at]

        @keys
        |> Enum.zip(list)
        |> Enum.into(%{})

        # we have to do this to validate the structure and make sure of the type
        # |> Gleam.validate_structure()
      end)

    # |> Enum.filter(fn value -> {"ok", _} = value end)

    {:ok, parsed_data}
  end

  def from_parsed_data(parsed_data_list) do
    extracted_data =
      Enum.map(parsed_data_list, fn parsed_data ->
        Map.new(parsed_data, fn {key, val} ->
          {key, apply(__MODULE__, key, [val])}
        end)
      end)

    {:ok, extracted_data}
  end

  @doc ~S"""
    Parse string to decimal

    ## Examples

      iex> PayCosern.Utils.Extract.amount("10,00")
      "10.00"

      iex> PayCosern.Utils.Extract.amount("10.00")
      "10.00"

      iex> PayCosern.Utils.Extract.amount("10.000,00")
      "10000.00"

      iex> PayCosern.Utils.Extract.amount("10,000.00")
      "10000.00"

      iex> PayCosern.Utils.Extract.amount("10,000")
      "10.000"

      iex> PayCosern.Utils.Extract.amount("10.000")
      "10.000"

      iex> PayCosern.Utils.Extract.amount("10,000,000.00")
      "10000000.00"

      iex> PayCosern.Utils.Extract.amount("10.000.000,00")
      "10000000.00"

      iex> PayCosern.Utils.Extract.amount("  100.000,00 ")
      "100000.00"

      iex> PayCosern.Utils.Extract.amount("4.252.")
      "4.252"

      iex> PayCosern.Utils.Extract.amount(".4,252.")
      "4.252"
  """
  def amount(nil), do: 0

  def amount(value) do
    cond do
      Regex.match?(~r/R\$ \d{1,3}(,\d{2})?/, value) ->
        value
        |> String.split(" ")
        |> Enum.at(1)
        |> String.replace(".", "")
        |> String.replace(",", ".")
        |> String.trim(".")
        |> String.trim(",")
        |> String.trim()
        |> String.to_float()

      Regex.match?(~r/\d+\.\d+\,\d+/, value) ->
        value
        |> String.replace(".", "")
        |> String.replace(",", ".")
        |> String.trim(".")
        |> String.trim(",")
        |> String.trim()

      Regex.match?(~r/\d+\,\d+\.\d+/, value) ->
        value
        |> String.replace(",", "")
        |> String.replace(",", ".")
        |> String.trim(".")
        |> String.trim(",")
        |> String.trim()

      Regex.match?(~r/\d+\,\d+/, value) ->
        value |> String.replace(",", ".") |> String.trim(".") |> String.trim(",") |> String.trim()

      Regex.match?(~r/^[.,\d]+$/, value) ->
        value
        |> String.replace(",", "")
        |> String.replace(",", ".")
        |> String.trim(".")
        |> String.trim(",")
        |> String.trim()

      true ->
        value
    end
  end

  def charge_period(charge_period) do
    ~r/\b(?:\d{2}\/\d{2}\/\d{4})\b/
    |> Regex.scan(charge_period)
    |> List.flatten()
    |> Enum.map(&parse_date/1)
  end

  def due_to(due_to) do
    parse_date(due_to)
  end

  def status("ATRASADA"), do: "overdue"
  def status("A VENCER"), do: "about_to_due"
  def status(_), do: "paid"

  def reference_month(date) do
    [month, year] = String.split(date, " ")

    month_number = get_month_number(month)

    "#{month_number}/#{year}"
  end

  def paid_at("ATRASADA"), do: nil
  def paid_at("A VENCER"), do: nil
  def paid_at(nil), do: nil

  def paid_at(string) do
    string
    |> String.split(" ")
    |> Enum.at(2)
    |> parse_date
  end

  defp parse_date(date) do
    [day, month, year] = date |> String.split("/") |> Enum.map(&String.to_integer/1)

    {:ok, date} = Date.new(year, month, day)

    date
  end

  defp get_month_number(month) do
    %{
      "Janeiro" => "01",
      "Fevereiro" => "02",
      "Março" => "03",
      "Abril" => "04",
      "Maio" => "05",
      "Junho" => "06",
      "Julho" => "07",
      "Agosto" => "08",
      "Setembro" => "09",
      "Outubro" => "10",
      "Novembro" => "11",
      "Dezembro" => "12"
    }[month]
  end
end
