defmodule HayaiLedgerWeb.AccountControllerTest do
  use HayaiLedgerWeb.ConnCase

  import Support.Fixtures.AccountFixtures, only: [{:account_attrs, 0}, {:account_fixture, 1}]
  import Support.Fixtures.LedgerFixtures, only: [{:transaction_fixture, 1}]

 	alias HayaiLedger.Accounts
 	alias HayaiLedger.Ledgers

  describe "GET /accounts/:uid" do
    test "returns the found account", %{conn: conn} do
      {:ok, account} = Accounts.create_account(account_attrs())
      response = get(conn, Routes.account_path(conn, :show, account.uid))
                  |> json_response(200)

      assert "Account" == response["object"]
      assert account.uid == response["uid"]
    end

    test "returns the error if invalid uid", %{conn: conn} do
      resp_conn = get(conn, Routes.account_path(conn, :show, "555"))
      assert %{"error" => "account not found for uid: 555"} == json_response(resp_conn, 500)
    end
  end

  describe "GET /accounts/balance/:uid" do
  	test "returns the balance json", %{conn: conn} do
  		account = account_fixture(%{ currency: "THB" })
      Ledgers.create_transaction(%{ amount_currency: "THB", account_uid: account.uid, amount_subunits: 1000, kind: "credit" })
      Ledgers.create_transaction(%{ amount_currency: "THB", account_uid: account.uid, amount_subunits: 1000, kind: "debit" })
      Ledgers.create_transaction(%{ amount_currency: "THB", account_uid: account.uid, amount_subunits: 1000, kind: "credit" })
      response = get(conn, Routes.account_path(conn, :balance, account.uid))
      						|> json_response(200)

      assert account.uid == response["account_uid"]
      assert "THB" == response["amount_currency"]
      assert 1000 == response["amount_subunits"]
      assert nil != response["date"]
  	end

  	test "returns an error if account cannot be found", %{conn: conn} do
  		resp_conn = get(conn, Routes.account_path(conn, :balance, "555"))
	  	assert %{"error" => "account not found for uid: 555"} == json_response(resp_conn, 500)
  	end
  end

  describe "GET /accounts/running_balance/:uid" do
    test "returns the balance json", %{conn: conn} do
      equity_account = account_fixture(%{ kind: "equity" })

      Accounts.update_balance(equity_account.id, 1000)
      response = get(conn, Routes.account_path(conn, :running_balance, equity_account.uid))
                  |> json_response(200)

      assert equity_account.uid == response["account_uid"]
      assert equity_account.currency == response["amount_currency"]
      assert 1000 == response["amount_subunits"]
      assert nil != response["date"]
    end

    test "returns an error if account cannot be found", %{conn: conn} do
      resp_conn = get(conn, Routes.account_path(conn, :balance, "555"))
      assert %{"error" => "account not found for uid: 555"} == json_response(resp_conn, 500)
    end
  end

  describe "GET /accounts/transactions/:uid" do
    test "returns the transactions for the account_uid", %{conn: conn} do
      asset_account = account_fixture(%{ kind: "asset" })
      equity_account = account_fixture(%{ kind: "equity" })
      {:ok, entry} = Ledgers.create_entry(%{ desription: "no description" })
      transaction_fixture(%{ account_uid: asset_account.uid, entry_id: entry.id })
      transaction_fixture(%{ account_uid: equity_account.uid, entry_id: entry.id })
      response = get(conn, Routes.account_path(conn, :transactions, equity_account.uid))
                  |> json_response(200)

      assert 1 == length(response["transactions"])
      transaction = hd(response["transactions"])
      assert equity_account.uid == transaction["account_uid"]
    end
  end

  describe "POST /create" do
  	test "returns an account with valid params", %{conn: conn} do
  		response = post(conn, Routes.account_path(conn, :create), account: account_attrs())
    							|> json_response(200)

    	assert "Account" == response["object"]
	  end

	  test "returns an error if invalid data", %{conn: conn} do
	  	resp_conn = post(conn, Routes.account_path(conn, :create), account: %{ "name" => "not enough info" })
      response = json_response(resp_conn, 500)
	  	assert "can't be blank" == response["currency"]
      assert "can't be blank" == response["kind"]
	  end
  end
end
