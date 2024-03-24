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

    asdf =
      Enum.map(cosern_accounts, fn %CosernAccounts{} = cosern_account ->
        PayCosern.dive(cosern_account)
      end)

    if Enum.all?(asdf, fn
         {:ok, _value} ->
           true

         {:error, _value} ->
           false
       end) do
      :ok
    else
      :error
    end
  end
end
