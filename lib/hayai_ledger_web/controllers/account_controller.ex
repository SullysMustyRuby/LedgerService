defmodule HayaiLedgerWeb.AccountController do
  use HayaiLedgerWeb, :controller

  alias HayaiLedger.Accounts
  alias HayaiLedger.Ledgers

  action_fallback HayaiLedgerWeb.FallbackController

  # GET
  def balance(conn, %{ "uid" => uid }) do
  	with {:ok, account} <- Accounts.get_account_by_uid(uid),
	  	balance when is_integer(balance) <- Ledgers.transactions_sum_by_account(account.id)
  	do
	  	render(conn, "balance.json", %{ account: account, balance: balance })
	  end
  end

  # POST
  def create(conn, %{ "account" => account_params }) do
		with {:ok, account} <- Accounts.create_account(account_params) do
			render(conn, "new.json", %{ account: account })
		end
  end

  # GET
  def show(conn, %{ "uid" => uid }) do
  	with {:ok, account} <- Accounts.get_account_by_uid(uid) do
	  	render(conn, "show.json", %{ account: account })
	  end
  end
end
