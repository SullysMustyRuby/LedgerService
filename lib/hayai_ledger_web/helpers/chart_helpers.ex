defmodule HayaiLedgerWeb.Helpers.ChartHelpers do
  import Ecto.Query, warn: false

  alias HayaiLedger.Accounts.Account
  alias HayaiLedger.Ledgers
  alias HayaiLedger.Ledgers.Transaction
  alias HayaiLedger.Repo

	def debits_credits(%Account{id: id}) do
		credits = Task.async(fn -> Ledgers.list_transactions(%{account_id: id, kind: "credit", from_date: this_year()}) |> sum_by_month() end)
		debits = Task.async(fn -> Ledgers.list_transactions(%{account_id: id, kind: "debit", from_date: this_year()}) |> sum_by_month() end)
		[%{name: "Credits", data: Task.await(credits)}, %{name: "Debits", data: Task.await(debits)}]
	end

	def monthly_balances(%Account{id: id}, year) do
		Task.async_stream(1..12, fn month -> __MODULE__.monthly_sum(id, year, month) end)
		|> Enum.map(fn {:ok, {month, balance}} -> [month, balance] end)
	end

	def monthly_sum(account_id, year, month) do
		{:ok, to_date, 0} = DateTime.from_iso8601("#{year}-#{date_pad(month)}-01T00:00:01Z")
		credits = Task.async(fn -> sum_transactions(account_id, "credit", to_date) end)
		debits = Task.async(fn -> sum_transactions(account_id, "debit", to_date) end)
		{month_abbr(month), total(Task.await(credits), Task.await(debits))}
	end

	def this_year do
		today = Date.utc_today()
		{:ok, datetime, 0} = DateTime.from_iso8601("#{today.year}-01-01T00:00:01Z")
		datetime
	end

	def sum_by_month(transactions) do
		Enum.group_by(transactions, fn %Transaction{date: date} -> month_abbr(date.month) end, fn %Transaction{amount_subunits: amount_subunits} -> amount_subunits end)
		|> Enum.map(fn {month, values} -> [month, Enum.sum(values)] end)
	end

	def month_abbr(month) do
		%{1 => "Jan", 2 => "Feb", 3 => "Mar", 4 => "Apr", 5 => "May", 6 => "Jun", 7 => "Jul", 8 => "Aug", 9 => "Sep", 10 => "Oct", 11 => "Nov", 12 => "Dec"}
		|> Map.get(month)
	end

	defp date_pad(num) when num < 10, do: "0#{num}"

	defp date_pad(num), do: "#{num}"

	defp sum_transactions(account_id, kind, to_date) do
		Repo.one(from t in Transaction,
			where: t.account_id == ^account_id,
			where: t.kind == ^kind,
			where: t.date <= ^to_date,
			select: sum(t.amount_subunits))
	end

	defp total(credits, debits) when is_integer(credits) and is_integer(debits), do: credits - debits
	defp total(nil, nil), do: 0
	defp total(credits, nil), do: credits
	defp total(nil, debits), do: debits
end

# account = HayaiLedger.Accounts.get_account(1)
# year = 2020
# HayaiLedgerWeb.Helpers.ChartHelpers.monthly_balances(account, 2020)

# from_date = ~U[2020-01-01 00:00:01Z]
# to_date = ~U[2020-02-01 00:00:01Z]
# query = (from t in Transaction, 
# 	where: t.account_id == ^account.id, 
# 	where: t.kind == "debit", 
# 	where: t.date >= ^from_date, 
# 	where: t.date <= ^to_date, 
# 	select: sum(t.amount_subunits))
			