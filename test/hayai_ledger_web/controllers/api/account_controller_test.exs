defmodule HayaiLedgerWeb.Api.AccountControllerTest do
  use HayaiLedgerWeb.ConnCase

  import Support.Fixtures.AccountFixtures, only: [{:account_attrs, 0}, {:account_fixture, 1}]
  import Support.Fixtures.LedgerFixtures, only: [{:transaction_fixture, 1}]
  import Support.Authentication, only: [{:api_setup, 0}]

 	alias HayaiLedger.Accounts
 	alias HayaiLedger.Ledgers

  setup do
    api_setup()
  end

  describe "GET /accounts/:uid" do
    test "returns the found account", %{ auth_conn: auth_conn, account: account } do
      response = get(auth_conn, Routes.api_account_path(auth_conn, :show, account.uid))
                  |> json_response(200)

      assert "Account" == response["object"]
      assert account.uid == response["uid"]
    end

    test "returns the error if invalid uid", %{ auth_conn: auth_conn } do
      resp_conn = get(auth_conn, Routes.api_account_path(auth_conn, :show, "555"))
      assert %{"error" => "account not found for uid: 555"} == json_response(resp_conn, 500)
    end
  end

  describe "GET /accounts/balance/:uid" do
  	test "returns the balance json", %{ auth_conn: auth_conn } do
  		account = account_fixture(%{ "currency" => "THB" })
      Ledgers.create_transaction(%{ amount_currency: "THB", account_uid: account.uid, amount_subunits: 1000, kind: "credit" })
      Ledgers.create_transaction(%{ amount_currency: "THB", account_uid: account.uid, amount_subunits: 1000, kind: "debit" })
      Ledgers.create_transaction(%{ amount_currency: "THB", account_uid: account.uid, amount_subunits: 1000, kind: "credit" })
      response = get(auth_conn, Routes.api_account_path(auth_conn, :balance, account.uid))
      						|> json_response(200)

      assert account.uid == response["account_uid"]
      assert "THB" == response["amount_currency"]
      assert 1000 == response["amount_subunits"]
      assert nil != response["date"]
  	end

  	test "returns an error if account cannot be found", %{ auth_conn: auth_conn } do
  		resp_conn = get(auth_conn, Routes.api_account_path(auth_conn, :balance, "555"))
	  	assert %{"error" => "account not found for uid: 555"} == json_response(resp_conn, 500)
  	end
  end

  describe "GET /accounts/running_balance/:uid" do
    test "returns the balance json", %{auth_conn: auth_conn} do
      equity_account = account_fixture(%{ "kind" => "equity" })

      Accounts.update_balance(equity_account.id, 1000)
      response = get(auth_conn, Routes.api_account_path(auth_conn, :running_balance, equity_account.uid))
                  |> json_response(200)

      assert equity_account.uid == response["account_uid"]
      assert equity_account.currency == response["amount_currency"]
      assert 1000 == response["amount_subunits"]
      assert nil != response["date"]
    end

    test "returns an error if account cannot be found", %{auth_conn: auth_conn} do
      resp_conn = get(auth_conn, Routes.api_account_path(auth_conn, :balance, "555"))
      assert %{"error" => "account not found for uid: 555"} == json_response(resp_conn, 500)
    end
  end

  describe "GET /accounts/transactions/:uid" do
    test "returns the transactions for the account_uid", %{auth_conn: auth_conn} do
      asset_account = account_fixture(%{ "kind" => "asset" })
      equity_account = account_fixture(%{ "kind" => "equity" })
      {:ok, entry} = Ledgers.create_entry(%{ desription: "no description" })
      transaction_fixture(%{ "account_uid" => asset_account.uid, "entry_id" => entry.id })
      transaction_fixture(%{ "account_uid" => equity_account.uid, "entry_id" => entry.id })
      response = get(auth_conn, Routes.api_account_path(auth_conn, :transactions, equity_account.uid))
                  |> json_response(200)

      assert 1 == length(response["transactions"])
      transaction = hd(response["transactions"])
      assert equity_account.uid == transaction["account_uid"]
    end
  end

  describe "POST /create" do
  	test "returns an account with valid params", %{ auth_conn: auth_conn } do
  		response = post(auth_conn, Routes.api_account_path(auth_conn, :create), account: account_attrs())
    							|> json_response(200)

    	assert "Account" == response["object"]
	  end

	  test "returns an error if invalid data", %{ auth_conn: auth_conn } do
	  	resp_conn = post(auth_conn, Routes.api_account_path(auth_conn, :create), account: %{ "name" => "not enough info" })
      response = json_response(resp_conn, 500)
	  	assert "can't be blank" == response["currency"]
      assert "can't be blank" == response["kind"]
	  end
  end
end
