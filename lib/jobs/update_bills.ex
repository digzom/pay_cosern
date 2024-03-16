defmodule PayCosern.Jobs.UpdateBills do
  require Logger
  use Oban.Worker
  alias PayCosern.Repo.Bills

  def perform(_job) do
    Logger.info("\nRunning update_bills cronjob.\n")

    today_reference_month = Timex.now() |> Timex.format!("{0M}/{YYYY}")

    reference_month =
      case PayCosern.Query.last_bill() do
        %Bills{reference_month: reference_month} ->
          reference_month

        something ->
          something
      end

    if today_reference_month == reference_month do
      Logger.info("""
      \n
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        ~~~> Data is updated. Last bill reference month: #{reference_month}\n
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        )
      """)

      {:ok, :updated_data}
    else
      data = PayCosern.dive()

      case data do
        {:error, _reason, message} ->
          {:error, message}

        data ->
          data
      end
    end
  end
end
