defmodule HayaiLedgerWeb.TransactionView do
  use HayaiLedgerWeb, :view

  import HayaiLedger.Accounts, only: [{:get_account_uid, 1}]
  import HayaiLedger.Ledgers, only: [{:get_entry_uid, 1}]

end
