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

    if Enum.all?(dive_each_account(cosern_accounts), fn
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

  defp dive_each_account(account_list) do
    Enum.map(account_list, fn %CosernAccounts{} = cosern_account ->
      PayCosern.dive(cosern_account)
    end)
  end
end
