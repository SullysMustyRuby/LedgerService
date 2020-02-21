defmodule HayaiLedgerWeb.AccountView do
  use HayaiLedgerWeb, :view

  def account_types() do
  	HayaiLedger.Accounts.Account.types()
  end

  def current_balance(account_id) do
  	HayaiLedger.Accounts.balance_amount_subunits_for_account(account_id)
  end
end
