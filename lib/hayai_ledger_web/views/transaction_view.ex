defmodule HayaiLedgerWeb.TransactionView do
  use HayaiLedgerWeb, :view

  def render("show.json", %{ transaction: transaction }) when is_map(transaction) do
  	%{
      "account_uid" => transaction.account_uid,
      "amount_currency" => transaction.amount_currency,
      "amount_subunits" => transaction.amount_subunits,
      "description" => transaction.description,
      "entry_uid" => transaction.entry_uid,
      "kind" => transaction.kind,
      "object" => "Transaction",
      "uid" => transaction.uid,
		}
  end

  def render("error.json", %{ errors: errors }) do
  	errors
  end
end
