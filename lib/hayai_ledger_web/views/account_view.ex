defmodule HayaiLedgerWeb.AccountView do
  use HayaiLedgerWeb, :view

  import HayaiLedger.Accounts, only: [{:balance_amount_subunits_for_account, 1}]

end
