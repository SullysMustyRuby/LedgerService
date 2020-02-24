defmodule HayaiLedgerWeb.Api.ProcedureView do
  use HayaiLedgerWeb, :api_view

  alias HayaiLedger.Accounts.Account
  alias HayaiLedgerWeb.Api.AccountView
  alias HayaiLedgerWeb.Api.TransactionView
  alias HayaiLedger.Ledgers.Entry

  def render("show.json", %{ result: %Account{} = account }) do
  	render(AccountView, "show.json", %{ account: account })
  end

  def render("show.json", %{ result: result }) when is_binary(result) do
  	%{ "ok" => result }
  end

  def render("show.json", %{ entry: entry, transactions: transactions }) do
  	%{
      "object" => "Entry",
			"description" => entry.description,
			"object_type" => entry.object_type,
			"object_uid" => entry.object_uid,
			"uid" => entry.uid,
      "transactions" => render_many(transactions, TransactionView, "show.json")
		}
  end
end
