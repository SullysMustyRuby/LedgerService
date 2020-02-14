defmodule HayaiLedgerWeb.Api.AccountController do
  use HayaiLedgerWeb, :api_controller

  alias HayaiLedger.Accounts
  alias HayaiLedger.Ledgers

  action_fallback HayaiLedgerWeb.FallbackController

  # GET
  def show(conn, %{ "uid" => uid }) do
    with {:ok, account} <- Accounts.get_account_by_uid(uid) do
      render(conn, "show.json", %{ account: account })
    end
  end

  # GET
  def balance(conn, %{ "uid" => uid }) do
  	with {:ok, account} <- Accounts.get_account_by_uid(uid),
	  	amount_subunits when is_integer(amount_subunits) <- Ledgers.transactions_sum_by_account(account.id)
  	do
	  	render(conn, "balance.json", %{ account: account, amount_subunits: amount_subunits })
	  end
  end

  # GET
  def running_balance(conn, %{ "uid" => uid }) do
    with {:ok, account} <- Accounts.get_account_by_uid(uid),
      amount_subunits when is_integer(amount_subunits) <- Accounts.balance_amount_subunits_for_account(account.id)
    do
      render(conn, "balance.json", %{ account: account, amount_subunits: amount_subunits })
    end
  end

  # GET
  def transactions(conn, %{ "uid" => uid }) do
    with {:ok, account} <- Accounts.get_account_by_uid(uid),
      transactions when is_list(transactions) <- Ledgers.list_transactions(account.id)
    do
      render(conn, "show.json", %{ account: account, transactions: transactions })
    end
  end

  # POST
  def create(conn, %{ "account" => account_params }) do
		with {:ok, organization_id} <- organization_id(conn),
      {:ok, account} <- Accounts.create_account(account_params, organization_id) 
    do
			render(conn, "new.json", %{ account: account })
		end
  end
end
