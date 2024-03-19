defmodule PayCosern.Jobs.UpdateBills do
  alias PayCosern.Repo.Query.CosernAccounts
  alias PayCosern.Repo.Query.CosernAccounts
  alias PayCosern.Repo.Query.CosernAccounts
  alias PayCosern.Repo.CosernAccounts
  use Oban.Worker, max_attempts: 10
  require Logger
  alias PayCosern.Repo

  def perform(_job) do
    Logger.info("\nRunning update_bills cronjob.\n")

    cosern_accounts = Repo.all(CosernAccounts)

    Enum.map(cosern_accounts, fn %CosernAccounts{} = cosern_account ->
      data = PayCosern.dive(cosern_account)

      case data do
        {:error, _reason, message} ->
          {:error, message}

        data ->
          {:ok, data}
      end
    end)
  end
end
