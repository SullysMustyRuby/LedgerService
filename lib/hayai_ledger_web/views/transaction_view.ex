defmodule HayaiLedgerWeb.TransactionView do
  use HayaiLedgerWeb, :view

  alias HayaiLedger.Accounts
  alias HayaiLedger.Ledgers

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

  defp get_account_uid(account_id) do
    Accounts.get_account_uid(account_id)
  end

  defp get_entry_uid(entry_id) do
    Ledgers.get_entry_uid(entry_id)
  end
end
