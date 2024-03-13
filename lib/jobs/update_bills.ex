defmodule PayCosern.Jobs.UpdateBills do
  use Oban.Worker

  def perform(_job) do
    data = PayCosern.dive()

    case data do
      {:error, _reason, message} ->
        {:error, message}

      data ->
        data
    end
  end
end
