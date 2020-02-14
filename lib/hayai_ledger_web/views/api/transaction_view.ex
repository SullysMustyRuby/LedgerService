defmodule HayaiLedgerWeb.Api.TransactionView do
  use HayaiLedgerWeb, :view

  import HayaiLedger.Accounts, only: [{:get_account_uid, 1}]
  import HayaiLedger.Ledgers, only: [{:get_entry_uid, 1}]

  def render("show.json", %{ transaction: transaction }) when is_map(transaction) do
  	%{
      "account_uid" => get_account_uid(transaction.account_id),
      "amount_currency" => transaction.amount_currency,
      "amount_subunits" => transaction.amount_subunits,
      "description" => transaction.description,
      "entry_uid" => get_entry_uid(transaction.entry_id),
      "kind" => transaction.kind,
      "object" => "Transaction",
      "uid" => transaction.uid,
		}
  end

  def render("error.json", %{ errors: errors }) do
  	errors
  end
end
